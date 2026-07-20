import 'package:flutter/widgets.dart';
import '../services/api_client.dart';
import '../services/session.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_button.dart';
import '../widgets/forms/app_input.dart';

/// First-run (and later, editable from Profile → Server) step: where's the
/// backend? There's no way to know the user's VPS address ahead of time
/// (see ../../DEPLOYMENT.md), so this is asked once and persisted.
class ServerSetupScreen extends StatefulWidget {
  const ServerSetupScreen({super.key, required this.session, required this.onSaved});

  final Session session;
  final VoidCallback onSaved;

  @override
  State<ServerSetupScreen> createState() => _ServerSetupScreenState();
}

class _ServerSetupScreenState extends State<ServerSetupScreen> {
  late final _controller = TextEditingController(text: widget.session.serverUrl ?? 'http://');
  bool _checking = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final url = _controller.text.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      setState(() => _error = 'Include http:// or https://');
      return;
    }
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      await ApiClient(widget.session).checkHealth(url.endsWith('/') ? url.substring(0, url.length - 1) : url);
      await widget.session.setServerUrl(url);
      if (mounted) widget.onSaved();
    } catch (e) {
      setState(() => _error = "Couldn't reach that server. Double-check the address and that it's running.");
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Connect to your server', style: CrushapText.title),
                    const SizedBox(height: 12),
                    Text(
                      "Enter the address of your Crushap server (see DEPLOYMENT.md) — "
                      "something like http://203.0.113.5:3000.",
                      style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    CrushapInput(
                      controller: _controller,
                      placeholder: 'http://your-server-ip:3000',
                      keyboardType: TextInputType.url,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(_error!, style: CrushapText.bodySm.copyWith(color: CrushapColors.actionPass)),
                    ],
                  ],
                  ),
                ),
              ),
              CrushapButton(
                label: _checking ? 'Checking…' : 'Continue',
                size: CrushapButtonSize.lg,
                expand: true,
                onPressed: _checking ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
