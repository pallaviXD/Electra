import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  int _currentStep = 0;
  bool? _isEligible;
  final Map<String, dynamic> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How old are you?',
      'subtitle': 'You must be 18 or older to vote',
      'icon': Icons.cake_rounded,
      'type': 'age',
      'options': ['Under 18', '18-25', '26-40', '41-60', '60+'],
    },
    {
      'question': 'Are you a citizen of the country?',
      'subtitle': 'Only citizens are eligible to vote',
      'icon': Icons.flag_rounded,
      'type': 'citizenship',
      'options': ['Yes', 'No', 'Not sure'],
    },
    {
      'question': 'Do you have a valid Voter ID?',
      'subtitle': 'An EPIC card or equivalent voter ID',
      'icon': Icons.badge_rounded,
      'type': 'voterid',
      'options': ['Yes, I have it', 'Applied, waiting', 'No, I don\'t have one', 'I lost it'],
    },
    {
      'question': 'Are you registered in the electoral roll?',
      'subtitle': 'Check at the Election Commission website',
      'icon': Icons.checklist_rounded,
      'type': 'registration',
      'options': ['Yes', 'No', 'Not sure'],
    },
  ];

  void _selectOption(String option) {
    setState(() {
      _answers[_questions[_currentStep]['type']] = option;

      if (_currentStep < _questions.length - 1) {
        _currentStep++;
      } else {
        _checkEligibility();
      }
    });
  }

  void _checkEligibility() {
    final age = _answers['age'];
    final citizen = _answers['citizenship'];
    final voterId = _answers['voterid'];
    final registered = _answers['registration'];

    setState(() {
      _isEligible = age != 'Under 18' &&
          citizen == 'Yes' &&
          (voterId == 'Yes, I have it' || voterId == 'Applied, waiting') &&
          (registered == 'Yes');
    });
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
      _isEligible = null;
      _answers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(
        backgroundColor: ElectraTheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Voter Readiness',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: _isEligible != null ? _buildResult() : _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_currentStep];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            children: List.generate(_questions.length, (i) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= _currentStep
                        ? ElectraTheme.primary
                        : ElectraTheme.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Step ${_currentStep + 1} of ${_questions.length}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: ElectraTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ElectraTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(q['icon'], color: ElectraTheme.primary, size: 28),
          ),
          const SizedBox(height: 20),
          Text(
            q['question'],
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: ElectraTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            q['subtitle'],
            style: GoogleFonts.inter(
              fontSize: 14,
              color: ElectraTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ...List.generate(
            (q['options'] as List<String>).length,
            (i) {
              final option = (q['options'] as List<String>)[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _selectOption(option),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ElectraTheme.cardBg,
                      borderRadius: BorderRadius.circular(ElectraTheme.radiusMd),
                      border: Border.all(color: ElectraTheme.divider),
                      boxShadow: ElectraTheme.shadowSm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ElectraTheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          option,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: ElectraTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _isEligible!
                  ? ElectraTheme.success.withValues(alpha: 0.1)
                  : ElectraTheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isEligible!
                  ? Icons.check_circle_rounded
                  : Icons.warning_rounded,
              color: _isEligible! ? ElectraTheme.success : ElectraTheme.error,
              size: 56,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _isEligible! ? 'You\'re Ready to Vote! 🎉' : 'Not Ready Yet',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: ElectraTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isEligible!
                ? 'Great news! Based on your responses, you appear to be eligible to vote. Make sure to exercise your right!'
                : 'Based on your responses, there are some steps you need to complete before you can vote.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: ElectraTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          if (!_isEligible!) ...[
            _ActionStep(
              icon: Icons.app_registration_rounded,
              title: 'Register as a Voter',
              subtitle: 'Visit the Election Commission portal to register',
            ),
            _ActionStep(
              icon: Icons.badge_rounded,
              title: 'Get your Voter ID',
              subtitle: 'Apply for EPIC card online or at local office',
            ),
            _ActionStep(
              icon: Icons.fact_check_rounded,
              title: 'Verify Electoral Roll',
              subtitle: 'Check your name in the voter list',
            ),
          ],
          const SizedBox(height: 24),
          GradientButton(
            label: 'Start Over',
            icon: Icons.refresh_rounded,
            onPressed: _reset,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _ActionStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActionStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ElectraTheme.cardBg,
        borderRadius: BorderRadius.circular(ElectraTheme.radiusMd),
        border: Border.all(color: ElectraTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ElectraTheme.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ElectraTheme.warning, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ElectraTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ElectraTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: ElectraTheme.textTertiary,
          ),
        ],
      ),
    );
  }
}
