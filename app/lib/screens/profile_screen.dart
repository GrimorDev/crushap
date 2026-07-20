import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import '../constants.dart';
import '../models/profile.dart';
import '../services/api_client.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_badge.dart';
import '../widgets/core/app_button.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/app_icon_button.dart';
import '../widgets/forms/app_input.dart';
import '../widgets/navigation/bottom_nav.dart';

const _settingsRows = ['Notifications', 'Privacy & safety', 'Subscription'];

/// Ported from ui_kits/dating-app/ProfileScreen.jsx, now backed by
/// `GET/PATCH /api/me` and real photo upload instead of static copy.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.api,
    required this.activeTab,
    required this.onTabChanged,
    required this.onOpenServerSettings,
    required this.onLogout,
  });

  final ApiClient api;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;
  final VoidCallback onOpenServerSettings;
  final VoidCallback onLogout;

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
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 85);
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

  @override
  Widget build(BuildContext context) {
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
                                    const CrushapBadge(
                                      label: 'Verified',
                                      variant: CrushapBadgeVariant.verified,
                                      icon: CrushapIcon('shield-check', size: 12),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 12),
                              CrushapIconButton(
                                icon: 'camera',
                                label: 'Edit photo',
                                variant: CrushapIconButtonVariant.surface,
                                onPressed: _uploadingPhoto ? null : _pickPhoto,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          if (_editing) ..._buildEditor() else ..._buildReadonly(me),
                          const SizedBox(height: 24),
                          _SettingsRow(label: 'Edit profile', onTap: _editing ? null : _startEditing),
                          for (final t in _settingsRows) _SettingsRow(label: t, onTap: null),
                          _SettingsRow(label: 'Server', onTap: widget.onOpenServerSettings),
                          _SettingsRow(label: 'Log out', isLast: true, onTap: widget.onLogout),
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

  List<Widget> _buildReadonly(Profile me) {
    return [
      const _SectionLabel('About'),
      const SizedBox(height: 10),
      Text(
        me.bio.isEmpty ? 'Add a bio so people know a little about you.' : me.bio,
        style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
      ),
      const SizedBox(height: 24),
      const _SectionLabel('Interests'),
      const SizedBox(height: 10),
      me.tags.isEmpty
          ? Text('No interests added yet.', style: CrushapText.bodySm.copyWith(color: CrushapColors.textTertiary))
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final t in me.tags) CrushapChip(label: t, selected: true)],
            ),
    ];
  }

  List<Widget> _buildEditor() {
    return [
      const _SectionLabel('About'),
      const SizedBox(height: 10),
      CrushapInput(controller: _bioController, placeholder: 'A little about you'),
      const SizedBox(height: 24),
      const _SectionLabel('Interests'),
      const SizedBox(height: 10),
      StatefulBuilder(
        builder: (context, setInner) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in kInterestOptions)
              CrushapChip(
                label: t,
                selected: _editTags.contains(t),
                onTap: () => setInner(() => _editTags.contains(t) ? _editTags.remove(t) : _editTags.add(t)),
              ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: CrushapButton(
              label: 'Cancel',
              variant: CrushapButtonVariant.ghost,
              expand: true,
              onPressed: _saving ? null : () => setState(() => _editing = false),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CrushapButton(
              label: _saving ? 'Saving…' : 'Save',
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
