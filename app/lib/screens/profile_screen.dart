import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import '../constants.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/profile.dart';
import '../services/api_client.dart';
import '../services/session.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_badge.dart';
import '../widgets/core/app_button.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/app_icon_button.dart';
import '../widgets/core/language_sheet.dart';
import '../widgets/core/photo_source_sheet.dart';
import '../widgets/forms/app_input.dart';
import '../widgets/navigation/bottom_nav.dart';

/// Ported from ui_kits/dating-app/ProfileScreen.jsx, now backed by
/// `GET/PATCH /api/me` and real photo upload instead of static copy.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.session,
    required this.api,
    required this.activeTab,
    required this.onTabChanged,
    required this.onOpenServerSettings,
    required this.onLogout,
    required this.onLocaleChanged,
  });

  final Session session;
  final ApiClient api;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;
  final VoidCallback onOpenServerSettings;
  final VoidCallback onLogout;
  final VoidCallback onLocaleChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? _me;
  bool _editing = false;
  bool _saving = false;
  bool _uploadingPhoto = false;
  late final _bioController = TextEditingController();
  final Set<String> _editTags = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final me = await widget.api.getMe();
      if (mounted) setState(() => _me = me);
    } catch (_) {
      // Leave _me null; the screen just stays on its loading state.
    }
  }

  void _startEditing() {
    final me = _me;
    if (me == null) return;
    _bioController.text = me.bio;
    _editTags
      ..clear()
      ..addAll(me.tags);
    setState(() => _editing = true);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final updated = await widget.api.updateMe(bio: _bioController.text.trim(), tags: _editTags.toList());
      setState(() {
        _me = updated;
        _editing = false;
      });
    } catch (_) {
      // Keep the edit sheet open so the user can retry.
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickPhoto() async {
    final source = await showPhotoSourceSheet(context);
    if (source == null) return;
    final file = await ImagePicker().pickImage(source: source, maxWidth: 1600, imageQuality: 85);
    if (file == null) return;
    setState(() => _uploadingPhoto = true);
    try {
      final Uint8List bytes = await file.readAsBytes();
      await widget.api.uploadPhoto(bytes, file.name);
      await _load();
    } catch (_) {
      // Ignore — the avatar just stays whatever it was.
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _pickLanguage() async {
    final choice = await showLanguageSheet(context, widget.session.localeOverride);
    if (choice == null) return;
    await widget.session.setLocaleOverride(choice.locale);
    widget.onLocaleChanged();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final me = _me;
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: me == null
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: _pickPhoto,
                                child: Container(
                                  width: 112,
                                  height: 112,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CrushapColors.surfaceCard,
                                    border: Border.all(color: CrushapColors.borderSubtle),
                                    image: me.photos.isEmpty
                                        ? null
                                        : DecorationImage(
                                            image: NetworkImage(widget.api.mediaUrl(me.photos.first)!),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  child: me.photos.isEmpty
                                      ? const CrushapIcon('image', size: 32, color: CrushapColors.textTertiary)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${me.name}, ${me.age}', style: CrushapText.displayMd),
                                  if (me.verified) ...[
                                    const SizedBox(width: 8),
                                    CrushapBadge(
                                      label: t.verifiedBadge,
                                      variant: CrushapBadgeVariant.verified,
                                      icon: const CrushapIcon('shield-check', size: 12),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 12),
                              CrushapIconButton(
                                icon: 'camera',
                                label: t.editPhotoLabel,
                                variant: CrushapIconButtonVariant.surface,
                                onPressed: _uploadingPhoto ? null : _pickPhoto,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          if (_editing) ..._buildEditor(t) else ..._buildReadonly(me, t),
                          const SizedBox(height: 24),
                          _SettingsRow(label: t.editProfileRow, onTap: _editing ? null : _startEditing),
                          _SettingsRow(label: t.notificationsRow, onTap: null),
                          _SettingsRow(label: t.privacySafetyRow, onTap: null),
                          _SettingsRow(label: t.subscriptionRow, onTap: null),
                          _SettingsRow(label: t.languageRow, onTap: _pickLanguage),
                          _SettingsRow(label: t.serverRow, onTap: widget.onOpenServerSettings),
                          _SettingsRow(label: t.logOutRow, isLast: true, onTap: widget.onLogout),
                        ],
                      ),
                    ),
            ),
            CrushapBottomNav(active: widget.activeTab, onChanged: widget.onTabChanged),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReadonly(Profile me, AppLocalizations t) {
    return [
      _SectionLabel(t.aboutSection),
      const SizedBox(height: 10),
      Text(
        me.bio.isEmpty ? t.addBioPrompt : me.bio,
        style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
      ),
      const SizedBox(height: 24),
      _SectionLabel(t.interestsSection),
      const SizedBox(height: 10),
      me.tags.isEmpty
          ? Text(t.noInterestsYet, style: CrushapText.bodySm.copyWith(color: CrushapColors.textTertiary))
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final tag in me.tags) CrushapChip(label: tag, selected: true)],
            ),
    ];
  }

  List<Widget> _buildEditor(AppLocalizations t) {
    return [
      _SectionLabel(t.aboutSection),
      const SizedBox(height: 10),
      CrushapInput(controller: _bioController, placeholder: t.bioEditPlaceholder),
      const SizedBox(height: 24),
      _SectionLabel(t.interestsSection),
      const SizedBox(height: 10),
      StatefulBuilder(
        builder: (context, setInner) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in kInterestOptions)
              CrushapChip(
                label: tag,
                selected: _editTags.contains(tag),
                onTap: () => setInner(() => _editTags.contains(tag) ? _editTags.remove(tag) : _editTags.add(tag)),
              ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: CrushapButton(
              label: t.cancelLabel,
              variant: CrushapButtonVariant.ghost,
              expand: true,
              onPressed: _saving ? null : () => setState(() => _editing = false),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CrushapButton(
              label: _saving ? t.savingLabel : t.saveLabel,
              expand: true,
              onPressed: _saving ? null : _save,
            ),
          ),
        ],
      ),
    ];
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: CrushapText.bodySm.copyWith(
        color: CrushapColors.textTertiary,
        letterSpacing: CrushapText.trackingWide * 14,
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, this.isLast = false, required this.onTap});
  final String label;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: CrushapColors.borderSubtle)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: CrushapText.body),
            Transform.rotate(
              angle: math.pi,
              child: const CrushapIcon('chevron-left', size: 16, color: CrushapColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
