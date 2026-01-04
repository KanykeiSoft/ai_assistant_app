import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'main_page.dart';
import 'services/auth_service.dart';
import 'services/profile_service.dart';

class ProfileOnboardingPage extends StatefulWidget {
  const ProfileOnboardingPage({super.key});

  @override
  State<ProfileOnboardingPage> createState() => _ProfileOnboardingPageState();
}

class _ProfileOnboardingPageState extends State<ProfileOnboardingPage> {
  final _formKey = GlobalKey<FormState>();

  final _ageCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();

  String _assistantStyle = 'Friendly';
  int _sleepHours = 8;

  bool _loading = true;
  bool _saving = false;

  late final AuthService _auth;
  late final ProfileService _profile;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _profile = ProfileService(_auth);
    _load();
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    _goalCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final me = await _profile.getMe();
      if (me != null) {
        final age = me['age'];
        final goal = me['goal'];
        final style = me['assistantStyle'];
        final sleep = me['sleepHours'];

        if (age != null) _ageCtrl.text = age.toString();
        if (goal != null) _goalCtrl.text = goal.toString();
        if (style != null && style.toString().trim().isNotEmpty) {
          _assistantStyle = style.toString();
        }
        if (sleep != null) {
          final v = int.tryParse(sleep.toString());
          if (v != null) _sleepHours = v.clamp(1, 16);
        }
      }
    } catch (e) {
      // если токена нет / ошибка — покажем сообщение
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateAge(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Enter your age';
    final n = int.tryParse(value);
    if (n == null) return 'Age must be a number';
    if (n < 10 || n > 100) return 'Age must be between 10 and 100';
    return null;
  }

  String? _validateGoal(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Enter your goal';
    if (value.length < 3) return 'Goal is too short';
    return null;
  }

  InputDecoration _decoration({
    required String label,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_saving) return;

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final age = int.parse(_ageCtrl.text.trim());
    final goal = _goalCtrl.text.trim();

    setState(() => _saving = true);

    try {
      await _profile.createOrUpdate(
        age: age,
        goal: goal,
        assistantStyle: _assistantStyle,
        sleepHours: _sleepHours,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved ✅')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile setup'),
      ),
      body: Container(
        color: const Color(0xFFD8D4C9), // бежевый как у твоих страниц
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Welcome',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us a bit about you so the assistant can personalize your experience.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.secondary.withOpacity(0.85),
                            height: 1.35,
                          ),
                    ),
                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: _loading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(strokeWidth: 3),
                                ),
                              ),
                            )
                          : Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _ageCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: _decoration(
                                      label: 'Age',
                                      hint: 'e.g. 29',
                                    ),
                                    validator: _validateAge,
                                  ),
                                  const SizedBox(height: 14),

                                  TextFormField(
                                    controller: _goalCtrl,
                                    decoration: _decoration(
                                      label: 'Goal',
                                      hint: 'e.g. Get fit, sleep better, learn Flutter',
                                    ),
                                    validator: _validateGoal,
                                  ),
                                  const SizedBox(height: 14),

                                  DropdownButtonFormField<String>(
                                    value: _assistantStyle,
                                    decoration: _decoration(
                                      label: 'Assistant style',
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: 'Friendly', child: Text('Friendly')),
                                      DropdownMenuItem(value: 'Strict', child: Text('Strict')),
                                      DropdownMenuItem(value: 'Coach', child: Text('Coach')),
                                      DropdownMenuItem(value: 'Minimal', child: Text('Minimal')),
                                    ],
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() => _assistantStyle = v);
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sleep hours: $_sleepHours',
                                      style: TextStyle(
                                        color: AppColors.secondary.withOpacity(0.9),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Slider(
                                    value: _sleepHours.toDouble(),
                                    min: 1,
                                    max: 16,
                                    divisions: 15,
                                    onChanged: (v) => setState(() => _sleepHours = v.round()),
                                  ),

                                  const SizedBox(height: 8),

                                  SizedBox(
                                    height: 52,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      onPressed: _saving ? null : _submit,
                                      child: _saving
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.4,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Continue',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    const SizedBox(height: 14),
                    Text(
                      'You can change this later in settings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.45),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
