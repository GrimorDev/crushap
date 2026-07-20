import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/navigation/bottom_nav.dart';

/// No source screen exists for the Search / Matches nav tabs (BottomNav.jsx
/// lists them, but the UI kit never builds those screens) — rather than
/// invent a design for them, this is a purposely minimal placeholder,
/// styled with existing tokens only.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.message,
    required this.activeTab,
    required this.onTabChanged,
  });

  final String title;
  final String message;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Center(child: Text(title, style: CrushapText.title)),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
                  ),
                ),
              ),
            ),
            CrushapBottomNav(active: activeTab, onChanged: onTabChanged),
          ],
        ),
      ),
    );
  }
}
