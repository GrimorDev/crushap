import 'package:flutter/material.dart';
import 'models/chat_message.dart';
import 'models/profile.dart';
import 'screens/chat_inbox_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
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

/// Mia is the profile the onboarding/original prototype always demoed with
/// a pre-filled conversation; every other match starts from a blank thread.
List<ChatMessage> _seedThreadFor(Profile p) {
  if (p.id != 'mia') return [];
  return const [
    ChatMessage(fromMe: false, text: 'Hey! Your hiking photos are amazing 😄'),
    ChatMessage(fromMe: true, text: "Ha thanks! That was Half Dome, brutal but worth it"),
    ChatMessage(fromMe: false, text: "Ok that's officially a date idea"),
  ];
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  bool _onboarded = false;
  CrushapNavTab _tab = CrushapNavTab.discover;
  Profile? _pendingMatch;
  final List<Profile> _matches = [];
  final Map<String, List<ChatMessage>> _threads = {};

  void _onTabChanged(CrushapNavTab tab) => setState(() => _tab = tab);

  void _onMatch(Profile p) {
    setState(() {
      if (!_matches.any((m) => m.id == p.id)) {
        _matches.add(p);
        _threads[p.id] = _seedThreadFor(p);
      }
      _pendingMatch = p;
    });
  }

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
          matchName: profile.name,
          initialMessages: _threads[profile.id] ?? const [],
          onSend: (message) {
            setState(() {
              _threads.putIfAbsent(profile.id, () => []).add(message);
            });
          },
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
      CrushapNavTab.chat => ChatInboxScreen(
          matches: _matches,
          threads: _threads,
          onOpenThread: _openThread,
          activeTab: _tab,
          onTabChanged: _onTabChanged,
        ),
      CrushapNavTab.profile => ProfileScreen(activeTab: _tab, onTabChanged: _onTabChanged),
      CrushapNavTab.search => SearchScreen(activeTab: _tab, onTabChanged: _onTabChanged),
      CrushapNavTab.matches => MatchesScreen(
          matches: _matches,
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
            onMessage: _openChatWithMatch,
            onKeepSwiping: _dismissMatch,
          ),
      ],
    );
  }
}
