/// Build-time configuration, injected via `--dart-define` at
/// `flutter build`/`flutter run` time (see .github/workflows/build-apk.yml).
///
/// Without this, every install of the app made a user type in the VPS
/// address by hand on first launch. `defaultServerUrl` lets whoever builds
/// the APK bake their deployed server's address in once, so ordinary users
/// never see the server-setup screen at all — it still exists, and is still
/// reachable from Profile → Server, for anyone who needs to point at a
/// different backend (e.g. during development).
class BuildConfig {
  BuildConfig._();

  static const defaultServerUrl = String.fromEnvironment('DEFAULT_SERVER_URL');

  static bool get hasDefaultServerUrl => defaultServerUrl.isNotEmpty;
}
