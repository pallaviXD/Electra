import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _step = 0;
  final Map<int, int> _answers = {};
  bool _done = false;

  final _questions = [
    {'q': 'What matters most to you?', 'opts': ['Economic growth', 'Social welfare', 'Environmental protection', 'National security']},
    {'q': 'How should education be funded?', 'opts': ['Increase public spending', 'Encourage private sector', 'Mix of both', 'Focus on vocational training']},
    {'q': 'What\'s your stance on healthcare?', 'opts': ['Universal free healthcare', 'Insurance-based system', 'Public-private partnership', 'Improve existing infrastructure']},
    {'q': 'How should employment be addressed?', 'opts': ['Government job creation', 'Support startups & SMEs', 'Skill development programs', 'Foreign investment']},
    {'q': 'What\'s your view on technology?', 'opts': ['Digital India push', 'Data privacy first', 'Tech in agriculture', 'AI & automation focus']},
  ];

  void _answer(int opt) {
    setState(() {
      _answers[_step] = opt;
      if (_step < _questions.length - 1) { _step++; } else { _done = true; }
    });
  }

  void _reset() { setState(() { _step = 0; _answers.clear(); _done = false; }); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(backgroundColor: ElectraTheme.surface,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Who Matches Me?', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600))),
      body: _done ? _buildResults() : _buildQuiz(),
    );
  }

  Widget _buildQuiz() {
    final q = _questions[_step];
    return Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: List.generate(_questions.length, (i) => Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(color: i <= _step ? ElectraTheme.primary : ElectraTheme.divider, borderRadius: BorderRadius.circular(2)))))),
      const SizedBox(height: 8),
      Text('${_step + 1} of ${_questions.length}', style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textTertiary)),
      const SizedBox(height: 32),
      Text(q['q'] as String, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
      const SizedBox(height: 24),
      ...(q['opts'] as List<String>).asMap().entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(onTap: () => _answer(e.key),
          child: Container(width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ElectraTheme.divider), boxShadow: ElectraTheme.shadowSm),
            child: Text(e.value, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)))))),
    ]));
  }

  Widget _buildResults() {
    final alignments = [
      {'party': 'Party Alpha', 'symbol': '🌸', 'match': 78, 'color': const Color(0xFFE74C3C)},
      {'party': 'Party Beta', 'symbol': '🌿', 'match': 65, 'color': const Color(0xFF27AE60)},
      {'party': 'Party Gamma', 'symbol': '⭐', 'match': 52, 'color': const Color(0xFFF39C12)},
    ];

    return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
      const SizedBox(height: 20),
      Text('Your Alignment Results', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text('Based on your preferences, here\'s how your views align:', style: GoogleFonts.inter(fontSize: 14, color: ElectraTheme.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 24),
      ...alignments.map((a) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ElectraTheme.divider), boxShadow: ElectraTheme.shadowSm),
        child: Row(children: [
          Text(a['symbol'] as String, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a['party'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            ClipRRect(borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: (a['match'] as int) / 100, backgroundColor: ElectraTheme.divider,
                color: a['color'] as Color, minHeight: 6)),
          ])),
          const SizedBox(width: 12),
          Text('${a['match']}%', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: a['color'] as Color)),
        ]))),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
        color: ElectraTheme.warning.withValues(alpha:0.08), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ElectraTheme.warning.withValues(alpha:0.2))),
        child: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: ElectraTheme.warning, size: 18), const SizedBox(width: 10),
          Expanded(child: Text('This is a simplified quiz. Real political alignment is more complex. We do NOT recommend any party.', style: GoogleFonts.inter(fontSize: 11, color: ElectraTheme.warning, height: 1.3))),
        ])),
      const SizedBox(height: 20),
      GestureDetector(onTap: _reset, child: Container(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(gradient: ElectraTheme.primaryGradient, borderRadius: BorderRadius.circular(100), boxShadow: ElectraTheme.shadowGreen),
        child: Text('Take Again', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)))),
    ]));
  }
}
