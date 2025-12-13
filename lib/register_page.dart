import 'package:flutter/material.dart';

// Reuse your palette (adjust/remove if already defined globally)
const Color kBg = Color(0xFFFFF3F6);
const Color kText = Color(0xFF111827);
const Color kMuted = Color(0xFF6B7280);
const Color kPrimary = Color(0xFF5A8F3E);
const Color kSurface = Colors.white;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

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

  void _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // TODO: Connect to backend later via AuthService.register(...)
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _loading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created (fake for now).")),
    );

    // Example: go to login screen after register
    Navigator.pop(context);
  }

  InputDecoration _decoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: kSurface,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kPrimary.withOpacity(0.8), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        foregroundColor: kText,
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
                    "Welcome 👋",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: kText,
                          fontWeight: FontWeight.w800,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Create your account to start tracking habits and planning your day.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kMuted,
                          height: 1.4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),

                  // Card container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
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
                              hint: "e.g. Aida K.",
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
                                  color: kMuted,
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
                                  color: kMuted,
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
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
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
                    child: const Text(
                      "Already have an account? Log in",
                      style: TextStyle(color: kPrimary, fontWeight: FontWeight.w700),
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
