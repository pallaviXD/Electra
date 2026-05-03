import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/gradient_button.dart';

class AuthScreen extends StatefulWidget {
  final bool startOnSignup;
  const AuthScreen({super.key, this.startOnSignup = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.startOnSignup ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: ElectraTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: ElectraTheme.shadowGreen,
                    ),
                    child: const Icon(Icons.how_to_vote_rounded,
                        color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 16),
                  Text('Electra',
                      style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: ElectraTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text('Your AI-Powered Election Assistant',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: ElectraTheme.textSecondary)),
                  const SizedBox(height: 28),
                  Container(
                    decoration: BoxDecoration(
                      color: ElectraTheme.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ElectraTheme.divider),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: ElectraTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: ElectraTheme.textSecondary,
                      labelStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      unselectedLabelStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      tabs: const [Tab(text: 'Sign In'), Tab(text: 'Sign Up')],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [_LoginForm(), _SignupForm()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Login ─────────────────────────────────────────────────────────────────────

class _LoginForm extends StatefulWidget {
  const _LoginForm();
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final err = await context.read<AuthProvider>().signIn(
          email: _email.text.trim(),
          password: _password.text,
        );
    if (mounted) {
      setState(() { _loading = false; _error = err; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (_error != null) _ErrorBanner(message: _error!),
            _Field(
              controller: _email,
              label: 'Email Address',
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$').hasMatch(v)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _password,
              label: 'Password',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: ElectraTheme.textTertiary, size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Password is required' : null,
            ),
            const SizedBox(height: 28),
            GradientButton(
              label: 'Sign In',
              icon: Icons.login_rounded,
              onPressed: _submit,
              isLoading: _loading,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Signup ────────────────────────────────────────────────────────────────────

class _SignupForm extends StatefulWidget {
  const _SignupForm();
  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  DateTime? _dob;
  bool _loading = false;
  bool _obscure = true;
  bool _obscureC = true;
  String? _error;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  int? get _age {
    if (_dob == null) return null;
    final t = DateTime.now();
    int a = t.year - _dob!.year;
    if (t.month < _dob!.month || (t.month == _dob!.month && t.day < _dob!.day)) a--;
    return a;
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 18),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: ElectraTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null) {
      setState(() => _error = 'Please select your date of birth.');
      return;
    }
    if ((_age ?? 0) < 18) {
      setState(() => _error = 'You must be at least 18 years old.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    final err = await context.read<AuthProvider>().signUp(
          fullName: _fullName.text.trim(),
          email: _email.text.trim(),
          phone: _phone.text.trim(),
          password: _password.text,
          dob: _dob!,
        );
    if (mounted) {
      setState(() { _loading = false; _error = err; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (_error != null) _ErrorBanner(message: _error!),

            // Info notice
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: ElectraTheme.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ElectraTheme.info.withValues(alpha: 0.25)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded, color: ElectraTheme.info, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'We collect only information required for voter verification. Minimum age: 18 years.',
                    style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.info, height: 1.4),
                  ),
                ),
              ]),
            ),

            _Field(
              controller: _fullName,
              label: 'Full Name',
              hint: 'As per government ID',
              icon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Full name is required';
                if (v.trim().split(' ').length < 2) return 'Enter your full name';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // DOB picker
            GestureDetector(
              onTap: _pickDob,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: ElectraTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (_dob != null && (_age ?? 0) < 18)
                        ? ElectraTheme.error
                        : ElectraTheme.divider,
                  ),
                ),
                child: Row(children: [
                  Icon(Icons.cake_outlined,
                      color: _dob == null ? ElectraTheme.textTertiary : ElectraTheme.primary,
                      size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Date of Birth',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: ElectraTheme.textTertiary, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(
                        _dob == null ? 'Select your date of birth' : DateFormat('dd MMMM yyyy').format(_dob!),
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: _dob == null ? ElectraTheme.textTertiary : ElectraTheme.textPrimary,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                  ),
                  if (_dob != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (_age ?? 0) >= 18
                            ? ElectraTheme.success.withValues(alpha: 0.1)
                            : ElectraTheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Age: $_age',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: (_age ?? 0) >= 18 ? ElectraTheme.success : ElectraTheme.error)),
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.calendar_today_rounded, color: ElectraTheme.textTertiary, size: 18),
                ]),
              ),
            ),
            if (_dob != null && (_age ?? 0) < 18)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text('You must be at least 18 years old.',
                    style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.error)),
              ),
            const SizedBox(height: 14),

            _Field(
              controller: _phone,
              label: 'Mobile Number',
              hint: '10-digit mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Mobile number is required';
                if (v.length != 10) return 'Enter a valid 10-digit number';
                return null;
              },
            ),
            const SizedBox(height: 14),

            _Field(
              controller: _email,
              label: 'Email Address',
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$').hasMatch(v)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            _Field(
              controller: _password,
              label: 'Password',
              hint: 'Min. 8 characters',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscure,
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: ElectraTheme.textTertiary, size: 20),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 8) return 'Minimum 8 characters';
                return null;
              },
            ),
            const SizedBox(height: 14),

            _Field(
              controller: _confirm,
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscureC,
              suffixIcon: IconButton(
                icon: Icon(_obscureC ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: ElectraTheme.textTertiary, size: 20),
                onPressed: () => setState(() => _obscureC = !_obscureC),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please confirm your password';
                if (v != _password.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 28),

            GradientButton(
              label: 'Create Account',
              icon: Icons.person_add_rounded,
              onPressed: _submit,
              isLoading: _loading,
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            Text(
              'By registering, you confirm you are a citizen of India and meet the minimum age requirement of 18 years.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 11, color: ElectraTheme.textTertiary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ElectraTheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ElectraTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline_rounded, color: ElectraTheme.error, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message,
              style: GoogleFonts.inter(fontSize: 13, color: ElectraTheme.error, height: 1.4)),
        ),
      ]),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 14, color: ElectraTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: ElectraTheme.textTertiary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: ElectraTheme.cardBg,
        labelStyle: GoogleFonts.inter(fontSize: 13, color: ElectraTheme.textSecondary),
        hintStyle: GoogleFonts.inter(fontSize: 13, color: ElectraTheme.textTertiary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ElectraTheme.divider)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ElectraTheme.primary, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ElectraTheme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ElectraTheme.error, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
