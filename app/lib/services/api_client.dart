import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/chat_message.dart';
import '../models/profile.dart';
import 'session.dart';

/// Picked images don't reliably carry a filename with a real extension
/// (camera captures in particular often come back as a bare temp name), and
/// MultipartFile.fromBytes falls back to application/octet-stream when it
/// can't guess one — which the server's multer fileFilter silently rejects,
/// producing a "No image file" error with no obvious cause. Naming the
/// content type explicitly avoids relying on that guess.
MediaType _imageMediaType(String filename) {
  final lower = filename.toLowerCase();
  if (lower.endsWith('.png')) return MediaType('image', 'png');
  if (lower.endsWith('.webp')) return MediaType('image', 'webp');
  if (lower.endsWith('.heic')) return MediaType('image', 'heic');
  if (lower.endsWith('.gif')) return MediaType('image', 'gif');
  return MediaType('image', 'jpeg');
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class SwipeResult {
  const SwipeResult({required this.matched, this.profile});
  final bool matched;
  final Profile? profile;
}

class MatchEntry {
  const MatchEntry({required this.profile, this.lastMessageText});
  final Profile profile;
  final String? lastMessageText;
}

/// Mirrors the query params /api/discover understands. `showMe` is one of
/// 'women' / 'men' / 'everyone' (or null, same as 'everyone' — no filter).
class DiscoverFilters {
  const DiscoverFilters({
    this.maxAge,
    this.maxDistanceKm,
    this.verifiedOnly = false,
    this.hasPhoto = false,
    this.showMe,
    this.tags = const [],
  });

  final int? maxAge;
  final double? maxDistanceKm;
  final bool verifiedOnly;
  final bool hasPhoto;
  final String? showMe;
  final List<String> tags;
}

/// `relaxedFilters` lists which of the caller's filters the server had to
/// drop (in priority order — see server/src/routes/profiles.js) to find
/// enough people; empty means every filter was honored as-is.
class DiscoverResult {
  const DiscoverResult({required this.profiles, required this.relaxedFilters});
  final List<Profile> profiles;
  final List<String> relaxedFilters;
}

/// Thin REST client for the crushap-server API (see server/README.md).
/// Every call reads the current base URL / token from [session] so a
/// server-address or login change takes effect immediately, with no client
/// rebuild needed.
class ApiClient {
  ApiClient(this.session);

  final Session session;

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = session.serverUrl;
    if (base == null) throw ApiException('No server configured yet.');
    return Uri.parse('$base$path').replace(queryParameters: query);
  }

  Map<String, String> _headers({bool json = true}) {
    final h = <String, String>{};
    if (json) h['Content-Type'] = 'application/json';
    final token = session.token;
    if (token != null) h['Authorization'] = 'Bearer $token';
    return h;
  }

  Future<Map<String, dynamic>> _decode(http.Response res) async {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      body = const {};
    }
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw ApiException((body['error'] as String?) ?? 'Something went wrong (${res.statusCode}).');
  }

  Future<void> checkHealth(String baseUrl) async {
    final res = await http
        .get(Uri.parse('$baseUrl/health'))
        .timeout(const Duration(seconds: 6));
    if (res.statusCode != 200) throw ApiException('Server replied with ${res.statusCode}.');
  }

  Future<(String token, Profile me)> register({
    required String name,
    required String email,
    required String password,
    required int age,
    String? bio,
    List<String>? tags,
    String? gender,
  }) async {
    final res = await http.post(
      _uri('/api/auth/register'),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'age': age,
        'bio': bio,
        'tags': tags,
        'gender': gender,
      }),
    );
    final body = await _decode(res);
    return (body['token'] as String, Profile.fromJson(body['user'] as Map<String, dynamic>));
  }

  Future<(String token, Profile me)> login({required String email, required String password}) async {
    final res = await http.post(
      _uri('/api/auth/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = await _decode(res);
    return (body['token'] as String, Profile.fromJson(body['user'] as Map<String, dynamic>));
  }

  Future<Profile> getMe() async {
    final res = await http.get(_uri('/api/me'), headers: _headers());
    final body = await _decode(res);
    return Profile.fromJson(body['user'] as Map<String, dynamic>);
  }

  Future<Profile> updateMe({
    String? name,
    String? bio,
    int? age,
    List<String>? tags,
    String? gender,
    double? lat,
    double? lng,
  }) async {
    // Only send fields that actually changed — sending an explicit `null`
    // for the rest would overwrite them server-side (PATCH is a partial
    // update; a present-but-null key looks like "clear this field").
    final fields = <String, dynamic>{
      'name': ?name,
      'bio': ?bio,
      'age': ?age,
      'tags': ?tags,
      'gender': ?gender,
      'lat': ?lat,
      'lng': ?lng,
    };
    final res = await http.patch(_uri('/api/me'), headers: _headers(), body: jsonEncode(fields));
    final body = await _decode(res);
    return Profile.fromJson(body['user'] as Map<String, dynamic>);
  }

  /// Fire-and-forget-ish location update — a thin wrapper over updateMe so
  /// callers that only want to push a fresh GPS fix don't need to know
  /// updateMe's full signature.
  Future<void> updateLocation({required double lat, required double lng}) async {
    await updateMe(lat: lat, lng: lng);
  }

  /// Takes raw bytes (not a `dart:io` File) so this works from an XFile on
  /// every platform, web included — `image_picker`'s XFile.readAsBytes()
  /// is the cross-platform way to get there.
  Future<String> uploadPhoto(Uint8List bytes, String filename) async {
    final req = http.MultipartRequest('POST', _uri('/api/me/photos'));
    req.headers.addAll(_headers(json: false));
    req.files.add(http.MultipartFile.fromBytes(
      'photo',
      bytes,
      filename: filename,
      contentType: _imageMediaType(filename),
    ));
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    final body = await _decode(res);
    return body['url'] as String;
  }

  Future<void> deletePhoto(String url) async {
    final req = http.Request('DELETE', _uri('/api/me/photos'));
    req.headers.addAll(_headers());
    req.body = jsonEncode({'url': url});
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    await _decode(res);
  }

  Future<DiscoverResult> discover({DiscoverFilters? filters}) async {
    final query = <String, String>{};
    if (filters != null) {
      if (filters.maxAge != null) query['maxAge'] = filters.maxAge!.toString();
      if (filters.maxDistanceKm != null) query['maxDistanceKm'] = filters.maxDistanceKm!.toString();
      if (filters.verifiedOnly) query['verifiedOnly'] = 'true';
      if (filters.hasPhoto) query['hasPhoto'] = 'true';
      if (filters.showMe != null) query['showMe'] = filters.showMe!;
      if (filters.tags.isNotEmpty) query['tags'] = filters.tags.join(',');
    }
    final res = await http.get(_uri('/api/discover', query.isEmpty ? null : query), headers: _headers());
    final body = await _decode(res);
    return DiscoverResult(
      profiles: (body['profiles'] as List).map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList(),
      relaxedFilters: (body['relaxedFilters'] as List?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Future<List<Profile>> search(String query) async {
    final res = await http.get(_uri('/api/search', {'q': query}), headers: _headers());
    final body = await _decode(res);
    return (body['profiles'] as List).map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SwipeResult> swipe(String targetId, String action) async {
    final res = await http.post(
      _uri('/api/swipes'),
      headers: _headers(),
      body: jsonEncode({'targetId': targetId, 'action': action}),
    );
    final body = await _decode(res);
    final matched = body['matched'] as bool;
    return SwipeResult(
      matched: matched,
      profile: matched ? Profile.fromJson(body['profile'] as Map<String, dynamic>) : null,
    );
  }

  Future<void> undoSwipe(String targetId) async {
    final res = await http.post(
      _uri('/api/swipes/undo'),
      headers: _headers(),
      body: jsonEncode({'targetId': targetId}),
    );
    await _decode(res);
  }

  Future<List<MatchEntry>> matches() async {
    final res = await http.get(_uri('/api/matches'), headers: _headers());
    final body = await _decode(res);
    return (body['matches'] as List).map((e) {
      final map = e as Map<String, dynamic>;
      final lastMessage = map['lastMessage'] as Map<String, dynamic>?;
      return MatchEntry(profile: Profile.fromJson(map), lastMessageText: lastMessage?['text'] as String?);
    }).toList();
  }

  Future<List<ChatMessage>> chatHistory(String otherUserId) async {
    final res = await http.get(_uri('/api/chat/$otherUserId/messages'), headers: _headers());
    final body = await _decode(res);
    return (body['messages'] as List).map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Resolves a server-relative asset path (e.g. a photo URL from the API)
  /// against the configured server, or null if there's nothing to show.
  String? mediaUrl(String? relativeOrAbsolute) {
    if (relativeOrAbsolute == null || relativeOrAbsolute.isEmpty) return null;
    if (relativeOrAbsolute.startsWith('http')) return relativeOrAbsolute;
    return '${session.serverUrl}$relativeOrAbsolute';
  }
}
