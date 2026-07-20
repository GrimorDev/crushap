import 'package:flutter/widgets.dart';
import '../../services/api_client.dart';
import '../../services/session.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../widgets/core/app_button.dart';
import '../../widgets/forms/app_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.session, required this.onLoggedIn, required this.onBack});

  final Session session;
  final VoidCallback onLoggedIn;
  final VoidCallback onBack;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final (token, me) = await ApiClient(widget.session).login(
        email: _email.text.trim(),
        password: _password.text,
      );
      await widget.session.setAuth(token: token, userId: me.id);
      if (mounted) widget.onLoggedIn();
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = "Couldn't reach the server. Try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
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
              CrushapButton(label: '← Back', variant: CrushapButtonVariant.ghost, onPressed: widget.onBack),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back', style: CrushapText.title),
                    const SizedBox(height: 20),
                    CrushapInput(placeholder: 'Email', controller: _email, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    CrushapInput(placeholder: 'Password', controller: _password, obscureText: true),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(_error!, style: CrushapText.bodySm.copyWith(color: CrushapColors.actionPass)),
                    ],
                  ],
                ),
              ),
              CrushapButton(
                label: _busy ? 'Logging in…' : 'Log in',
                size: CrushapButtonSize.lg,
                expand: true,
                onPressed: _busy ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
