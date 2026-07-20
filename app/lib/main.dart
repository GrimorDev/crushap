import 'package:flutter/material.dart';
import 'models/profile.dart';
import 'screens/auth/login_screen.dart';
import 'screens/chat_inbox_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/server_setup_screen.dart';
import 'services/api_client.dart';
import 'services/session.dart';
import 'theme/colors.dart';
import 'widgets/dating/match_overlay.dart';
import 'widgets/navigation/bottom_nav.dart';

void main() {
  runApp(const CrushapApp());
}

class CrushapApp extends StatelessWidget {
  const CrushapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'crushap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CrushapColors.surfaceApp,
        primaryColor: CrushapColors.accentPrimary,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: CrushapColors.accentPrimary,
          selectionColor: CrushapColors.accentGlow,
          selectionHandleColor: CrushapColors.accentPrimary,
        ),
      ),
      // No screen uses Scaffold (the design system's chrome is hand-rolled,
      // not Material's), but a couple of leaf widgets (TextField) still
      // require a Material ancestor to satisfy their internal assertions —
      // one Material here covers the whole app instead of wrapping each.
      home: const Material(color: CrushapColors.surfaceApp, child: _AppRoot()),
    );
  }
}

ImageProvider? _networkImage(String? url) => url == null ? null : NetworkImage(url);

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  Session? _session;
  ApiClient? _api;
  bool _showLogin = false;
  CrushapNavTab _tab = CrushapNavTab.discover;
  Profile? _pendingMatch;

  @override
  void initState() {
    super.initState();
    Session.load().then((session) {
      setState(() {
        _session = session;
        _api = ApiClient(session);
      });
    });
  }

  void _onTabChanged(CrushapNavTab tab) => setState(() => _tab = tab);

  void _onMatch(Profile p) => setState(() => _pendingMatch = p);

  void _dismissMatch() => setState(() => _pendingMatch = null);

  void _openChatWithMatch() {
    final match = _pendingMatch;
    setState(() => _pendingMatch = null);
    if (match != null) _openThread(match);
  }

  void _openThread(Profile profile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          session: _session!,
          api: _api!,
          matchId: profile.id,
          matchName: profile.name,
          matchPhotoUrl: _api!.mediaUrl(profile.photos.isNotEmpty ? profile.photos.first : null),
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _openFilters() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FiltersScreen(onClose: () => Navigator.of(context).pop())),
    );
  }

  void _openServerSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServerSetupScreen(session: _session!, onSaved: () => Navigator.of(context).pop()),
      ),
    );
  }

  Future<void> _logout() async {
    await _session!.clearAuth();
    setState(() => _tab = CrushapNavTab.discover);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    final api = _api;
    if (session == null || api == null) {
      return const ColoredBox(color: CrushapColors.surfaceApp);
    }

    if (!session.hasServer) {
      return ServerSetupScreen(session: session, onSaved: () => setState(() {}));
    }

    if (!session.isLoggedIn) {
      return _showLogin
          ? LoginScreen(
              session: session,
              onLoggedIn: () => setState(() {}),
              onBack: () => setState(() => _showLogin = false),
            )
          : OnboardingScreen(
              session: session,
              onDone: () => setState(() {}),
              onLogin: () => setState(() => _showLogin = true),
            );
    }

    final Widget mainScreen = switch (_tab) {
      CrushapNavTab.discover => DiscoverScreen(
          api: api,
          onMatch: _onMatch,
          onOpenFilters: _openFilters,
          activeTab: _tab,
          onTabChanged: _onTabChanged,
        ),
      CrushapNavTab.chat => ChatInboxScreen(
          api: api,
          onOpenThread: _openThread,
          activeTab: _tab,
          onTabChanged: _onTabChanged,
        ),
      CrushapNavTab.profile => ProfileScreen(
          api: api,
          activeTab: _tab,
          onTabChanged: _onTabChanged,
          onOpenServerSettings: _openServerSettings,
          onLogout: _logout,
        ),
      CrushapNavTab.search => SearchScreen(api: api, activeTab: _tab, onTabChanged: _onTabChanged),
      CrushapNavTab.matches => MatchesScreen(
          api: api,
          onOpenThread: _openThread,
          activeTab: _tab,
          onTabChanged: _onTabChanged,
        ),
    };

    return Stack(
      children: [
        Positioned.fill(child: mainScreen),
        if (_pendingMatch != null)
          CrushapMatchOverlay(
            matchName: _pendingMatch!.name,
            matchPhoto: _networkImage(api.mediaUrl(_pendingMatch!.photos.isNotEmpty ? _pendingMatch!.photos.first : null)),
            onMessage: _openChatWithMatch,
            onKeepSwiping: _dismissMatch,
          ),
      ],
    );
  }
}
