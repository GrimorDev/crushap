/// A user's public profile, as returned by the server (see server/README.md).
/// `distanceKm` is only ever real (Redis GEO between two opted-in users) —
/// null means "unknown", never a fabricated placeholder.
class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.age,
    this.distanceKm,
    this.verified = false,
    required this.bio,
    required this.tags,
    this.gender,
    this.lookingFor,
    this.photos = const [],
  });

  final String id;
  final String name;
  final int age;
  final double? distanceKm;
  final bool verified;
  final String bio;
  final List<String> tags;
  /// One of 'woman' / 'man' / 'nonbinary', or null for accounts created
  /// before this field existed (or who skipped it, if that's ever allowed).
  final String? gender;
  /// One of 'relationship' / 'casual' / 'friends' / 'unsure', or null if
  /// unset — shown as the status pill on the swipe card.
  final String? lookingFor;
  final List<String> photos;

  /// Formatted distance value only — the "X km away" phrasing is locale-
  /// dependent, so that part is added at the UI layer (AppLocalizations).
  String? get distanceValue =>
      distanceKm?.toStringAsFixed(distanceKm! < 10 ? 1 : 0);

  factory Profile.fromJson(Map<String, dynamic> j) {
    return Profile(
      id: j['id'] as String,
      name: j['name'] as String,
      // Tolerant on purpose, mirroring the server's tag parsing: one
      // account with corrupted/missing legacy age data (e.g. from before
      // the profile-save bug was fixed) must not throw and take the whole
      // list — Discover, Matches, Likes, Search — down with it.
      age: (j['age'] as num?)?.toInt() ?? 0,
      distanceKm: (j['distanceKm'] as num?)?.toDouble(),
      verified: j['verified'] as bool? ?? false,
      bio: j['bio'] as String? ?? '',
      tags: (j['tags'] as List?)?.map((e) => e as String).toList() ?? const [],
      gender: j['gender'] as String?,
      lookingFor: j['lookingFor'] as String?,
      photos: (j['photos'] as List?)?.map((e) => e as String).toList() ?? const [],
    );
  }
}
