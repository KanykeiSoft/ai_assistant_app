import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'services/auth_service.dart';
import 'app_buttons.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();


  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }
Future<void> _submit() async {
  FocusScope.of(context).unfocus();

  if (!_formKey.currentState!.validate()) return;

  setState(() => _loading = true);

  try {
    final timezone = DateTime.now().timeZoneName; // например: EST / EDT

    await _auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      timezone: timezone,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created ✅")),
    );

    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Register error: $e")),
    );
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

  InputDecoration _decoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    // Важно: базовые стили уже задаются в ThemeData (main.dart),
    // здесь мы только добавляем label/hint/suffix.
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor НЕ задаём — берётся из ThemeData (AppColors.bg)
      appBar: AppBar(
        // AppBar стиль тоже лучше оставить темой,
        // тут только title
        title: const Text("Create account"),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "Welcome ",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Create your account to start tracking habits and planning your day.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondary.withValues(alpha: 0.85),
                          height: 1.4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),

                  // Card container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameCtrl,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              label: "Full name",
                              hint: "e.g. Aidar K.",
                            ),
                            validator: (v) {
                              final value = (v ?? "").trim();
                              if (value.isEmpty) return "Please enter your name";
                              if (value.length < 2) return "Name is too short";
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              label: "Email",
                              hint: "you@example.com",
                            ),
                            validator: (v) {
                              final value = (v ?? "").trim();
                              if (value.isEmpty) return "Please enter your email";
                              final emailOk = RegExp(r'^\S+@\S+\.\S+$').hasMatch(value);
                              if (!emailOk) return "Enter a valid email";
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscurePass,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              label: "Password",
                              hint: "Minimum 6 characters",
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscurePass = !_obscurePass),
                                icon: Icon(
                                  _obscurePass ? Icons.visibility : Icons.visibility_off,
                                  color: AppColors.secondary.withValues(alpha: 0.75),
                                ),
                              ),
                            ),
                            validator: (v) {
                              final value = (v ?? "");
                              if (value.isEmpty) return "Please enter a password";
                              if (value.length < 6) return "Password must be at least 6 chars";
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _confirmCtrl,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            decoration: _decoration(
                              label: "Confirm password",
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                                icon: Icon(
                                  _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                                  color: AppColors.secondary.withValues(alpha: 0.75),
                                ),
                              ),
                            ),
                            validator: (v) {
                              final value = (v ?? "");
                              if (value.isEmpty) return "Please confirm your password";
                              if (value != _passCtrl.text) return "Passwords do not match";
                              return null;
                            },
                            onFieldSubmitted: (_) => _loading ? null : _submit(),
                          ),

                          const SizedBox(height: 18),

                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: ElevatedButton(
                              // ❗ стиль НЕ задаём — берётся из общего Theme
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Create account",
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Already have an account? Log in",
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
