import 'package:flutter/widgets.dart' show Locale;
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted "which server, which logged-in user" state. The server's
/// address isn't known at build time (it's whatever VPS the user deploys
/// to — see ../../DEPLOYMENT.md), so it's entered once in the app and
/// stored locally, same as the auth token.
class Session {
  Session._(this._prefs);

  final SharedPreferences _prefs;

  static const _kServerUrl = 'server_url';
  static const _kToken = 'auth_token';
  static const _kUserId = 'user_id';
  static const _kLocale = 'locale_override';

  static Future<Session> load() async {
    return Session._(await SharedPreferences.getInstance());
  }

  String? get serverUrl => _prefs.getString(_kServerUrl);
  String? get token => _prefs.getString(_kToken);
  String? get userId => _prefs.getString(_kUserId);

  bool get hasServer => serverUrl != null && serverUrl!.isNotEmpty;
  bool get isLoggedIn => token != null && userId != null;

  /// Derives the WebSocket origin from the REST base URL (http->ws,
  /// https->wss) so the user only ever has to enter one address.
  String? get wsUrl {
    final url = serverUrl;
    if (url == null) return null;
    if (url.startsWith('https://')) return 'wss://${url.substring(8)}';
    if (url.startsWith('http://')) return 'ws://${url.substring(7)}';
    return url;
  }

  Future<void> setServerUrl(String url) async {
    var normalized = url.trim();
    if (normalized.endsWith('/')) normalized = normalized.substring(0, normalized.length - 1);
    await _prefs.setString(_kServerUrl, normalized);
  }

  Future<void> setAuth({required String token, required String userId}) async {
    await _prefs.setString(_kToken, token);
    await _prefs.setString(_kUserId, userId);
  }

  Future<void> clearAuth() async {
    await _prefs.remove(_kToken);
    await _prefs.remove(_kUserId);
  }

  /// null means "follow the device's language" (falling back to English
  /// if the device language isn't one of ours — see supportedLocales).
  Locale? get localeOverride {
    final code = _prefs.getString(_kLocale);
    return code == null ? null : Locale(code);
  }

  Future<void> setLocaleOverride(Locale? locale) async {
    if (locale == null) {
      await _prefs.remove(_kLocale);
    } else {
      await _prefs.setString(_kLocale, locale.languageCode);
    }
  }

  /// Generic on/off settings (notification + privacy toggles) — these are
  /// device-local preferences only, not synced to the server, so a flat
  /// namespaced bool store is enough; no need for a dedicated field per key.
  bool getFlag(String key, {bool defaultValue = true}) => _prefs.getBool('flag_$key') ?? defaultValue;

  Future<void> setFlag(String key, bool value) => _prefs.setBool('flag_$key', value);
}
