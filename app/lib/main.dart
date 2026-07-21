import 'package:flutter/material.dart';
import 'l10n/gen/app_localizations.dart';
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
import 'screens/settings/notifications_screen.dart';
import 'screens/settings/privacy_screen.dart';
import 'screens/settings/subscription_screen.dart';
import 'services/api_client.dart';
import 'services/session.dart';
import 'theme/colors.dart';
import 'widgets/dating/match_overlay.dart';
import 'widgets/navigation/bottom_nav.dart';

void main() {
  runApp(const CrushapApp());
}

ImageProvider? _networkImage(String? url) => url == null ? null : NetworkImage(url);

class CrushapApp extends StatefulWidget {
  const CrushapApp({super.key});

  @override
  State<CrushapApp> createState() => _CrushapAppState();
}

class _CrushapAppState extends State<CrushapApp> {
  Session? _session;
  ApiClient? _api;
  bool _showLogin = false;
  CrushapNavTab _tab = CrushapNavTab.discover;
  Profile? _pendingMatch;

  // This State's own `context` sits ABOVE the MaterialApp it builds (and
  // therefore above the Navigator MaterialApp creates around `home`), so
  // calling Navigator.of(context) from here throws "does not include a
  // Navigator". A navigatorKey gives every push/pop callback below a
  // handle straight into that Navigator instead.
  final _navigatorKey = GlobalKey<NavigatorState>();

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

  void _onLocaleChanged() => setState(() {});

  void _onTabChanged(CrushapNavTab tab) => setState(() => _tab = tab);

  void _onMatch(Profile p) => setState(() => _pendingMatch = p);

  void _dismissMatch() => setState(() => _pendingMatch = null);

  void _openChatWithMatch() {
    final match = _pendingMatch;
    setState(() => _pendingMatch = null);
    if (match != null) _openThread(match);
  }

  void _openThread(Profile profile) {
    _navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          session: _session!,
          api: _api!,
          matchId: profile.id,
          matchName: profile.name,
          matchPhotoUrl: _api!.mediaUrl(profile.photos.isNotEmpty ? profile.photos.first : null),
          onBack: () => _navigatorKey.currentState!.pop(),
        ),
      ),
    );
  }

  void _openFilters() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => FiltersScreen(onClose: () => _navigatorKey.currentState!.pop())),
    );
  }

  void _openServerSettings() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => ServerSetupScreen(session: _session!, onSaved: () => _navigatorKey.currentState!.pop()),
      ),
    );
  }

  void _openNotifications() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => NotificationsScreen(session: _session!, onBack: () => _navigatorKey.currentState!.pop()),
      ),
    );
  }

  void _openPrivacy() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => PrivacyScreen(session: _session!, onBack: () => _navigatorKey.currentState!.pop()),
      ),
    );
  }

  void _openSubscription() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => SubscriptionScreen(onBack: () => _navigatorKey.currentState!.pop())),
    );
  }

  Future<void> _logout() async {
    await _session!.clearAuth();
    setState(() => _tab = CrushapNavTab.discover);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'crushap',
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: _session?.localeOverride,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
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
      home: Material(color: CrushapColors.surfaceApp, child: _buildBody()),
    );
  }

  Widget _buildBody() {
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
          session: session,
          api: api,
          activeTab: _tab,
          onTabChanged: _onTabChanged,
          onOpenServerSettings: _openServerSettings,
          onOpenNotifications: _openNotifications,
          onOpenPrivacy: _openPrivacy,
          onOpenSubscription: _openSubscription,
          onLogout: _logout,
          onLocaleChanged: _onLocaleChanged,
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
