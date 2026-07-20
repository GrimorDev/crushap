import 'package:flutter/material.dart';
import 'models/profile.dart';
import 'screens/chat_screen.dart';
import 'screens/coming_soon_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
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
      home: const _AppRoot(),
    );
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  bool _onboarded = false;
  CrushapNavTab _tab = CrushapNavTab.discover;
  Profile? _matched;

  void _onTabChanged(CrushapNavTab tab) => setState(() => _tab = tab);

  void _onMatch(Profile p) => setState(() => _matched = p);

  void _dismissMatch() => setState(() => _matched = null);

  void _openChatWithMatch() {
    setState(() {
      _matched = null;
      _tab = CrushapNavTab.chat;
    });
  }

  void _openFilters() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FiltersScreen(onClose: () => Navigator.of(context).pop())),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_onboarded) {
      return OnboardingScreen(onDone: () => setState(() => _onboarded = true));
    }

    final Widget mainScreen = switch (_tab) {
      CrushapNavTab.discover => DiscoverScreen(
          onMatch: _onMatch,
          onOpenFilters: _openFilters,
          activeTab: _tab,
          onTabChanged: _onTabChanged,
        ),
      CrushapNavTab.chat => ChatScreen(
          matchName: _matched?.name ?? 'Mia',
          activeTab: _tab,
          onTabChanged: _onTabChanged,
        ),
      CrushapNavTab.profile => ProfileScreen(activeTab: _tab, onTabChanged: _onTabChanged),
      CrushapNavTab.search => ComingSoonScreen(
          title: 'Search',
          message: "Search is warming up. In the meantime, Discover's got plenty of people to meet.",
          activeTab: _tab,
          onTabChanged: _onTabChanged,
        ),
      CrushapNavTab.matches => ComingSoonScreen(
          title: 'Matches',
          message: 'Your matches will line up here. Get swiping to start the list.',
          activeTab: _tab,
          onTabChanged: _onTabChanged,
        ),
    };

    return Stack(
      children: [
        Positioned.fill(child: mainScreen),
        if (_matched != null)
          CrushapMatchOverlay(
            matchName: _matched!.name,
            onMessage: _openChatWithMatch,
            onKeepSwiping: _dismissMatch,
          ),
      ],
    );
  }
}
