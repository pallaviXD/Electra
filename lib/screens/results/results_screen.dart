import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results = [
      {'party': 'Party Alpha', 'symbol': '🌸', 'seats': 245, 'color': const Color(0xFFE74C3C), 'change': '+12'},
      {'party': 'Party Beta', 'symbol': '🌿', 'seats': 180, 'color': const Color(0xFF27AE60), 'change': '-8'},
      {'party': 'Party Gamma', 'symbol': '⭐', 'seats': 68, 'color': const Color(0xFFF39C12), 'change': '+5'},
      {'party': 'Others', 'symbol': '🔵', 'seats': 50, 'color': const Color(0xFF3498DB), 'change': '-9'},
    ];
    const total = 543;

    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(backgroundColor: ElectraTheme.surface,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Election Results', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        // Majority marker
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
          gradient: ElectraTheme.darkGradient, borderRadius: BorderRadius.circular(20), boxShadow: ElectraTheme.shadowLg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('MAJORITY MARK: 272 SEATS', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white60, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            // Stacked bar
            ClipRRect(borderRadius: BorderRadius.circular(6),
              child: SizedBox(height: 24, child: Row(children: results.map((r) {
                final width = (r['seats'] as int) / total;
                return Expanded(flex: (width * 100).round(),
                  child: Container(color: r['color'] as Color,
                    child: Center(child: Text('${r['seats']}', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)))));
              }).toList()))),
            const SizedBox(height: 12),
            Row(children: results.map((r) => Padding(padding: const EdgeInsets.only(right: 14),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: r['color'] as Color, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text(r['party'] as String, style: GoogleFonts.inter(fontSize: 10, color: Colors.white70)),
              ]))).toList()),
          ])),
        const SizedBox(height: 20),
        Text('Party-wise Results', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...results.map((r) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ElectraTheme.divider), boxShadow: ElectraTheme.shadowSm),
          child: Row(children: [
            Text(r['symbol'] as String, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r['party'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              ClipRRect(borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(value: (r['seats'] as int) / total,
                  backgroundColor: ElectraTheme.divider, color: r['color'] as Color, minHeight: 6)),
            ])),
            const SizedBox(width: 14),
            Column(children: [
              Text('${r['seats']}', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: r['color'] as Color)),
              Text(r['change'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600,
                color: (r['change'] as String).startsWith('+') ? ElectraTheme.success : ElectraTheme.error)),
            ]),
          ]))),

        const SizedBox(height: 20),
        // What happens next
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
          color: ElectraTheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ElectraTheme.primary.withValues(alpha: 0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.lightbulb_outline_rounded, color: ElectraTheme.primary, size: 20), const SizedBox(width: 8),
              Text('What Happens Next?', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: ElectraTheme.primaryDark)),
            ]),
            const SizedBox(height: 12),
            _nextStep('1', 'The party/coalition with majority (272+) is invited to form government'),
            _nextStep('2', 'The leader is sworn in as Prime Minister by the President'),
            _nextStep('3', 'Council of Ministers is formed and portfolios assigned'),
            _nextStep('4', 'New government presents its agenda in Parliament'),
          ])),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
          color: ElectraTheme.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ElectraTheme.info.withValues(alpha: 0.2))),
          child: Row(children: [
            const Icon(Icons.info_outline, color: ElectraTheme.info, size: 18), const SizedBox(width: 10),
            Expanded(child: Text('Sample data for demonstration purposes only.', style: GoogleFonts.inter(fontSize: 11, color: ElectraTheme.info))),
          ])),
        const SizedBox(height: 40),
      ]),
    );
  }

  Widget _nextStep(String num, String text) => Padding(padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 22, height: 22, decoration: BoxDecoration(
        color: ElectraTheme.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
        child: Center(child: Text(num, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: ElectraTheme.primary)))),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 13, color: ElectraTheme.textSecondary, height: 1.4))),
    ]));
}
