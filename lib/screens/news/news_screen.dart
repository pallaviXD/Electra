import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = [
      {'title': 'Election Commission Announces Phase-wise Voting Schedule', 'source': 'National Times', 'time': '2h ago', 'cat': 'Official', 'color': const Color(0xFF3498DB)},
      {'title': 'Voter Registration Numbers Reach All-Time High', 'source': 'Democracy Today', 'time': '4h ago', 'cat': 'Registration', 'color': const Color(0xFF27AE60)},
      {'title': 'New Guidelines for Polling Booth Accessibility Released', 'source': 'Civic Herald', 'time': '6h ago', 'cat': 'Accessibility', 'color': const Color(0xFF9B59B6)},
      {'title': 'Digital Voting ID Now Accepted at Polling Stations', 'source': 'Tech & Politics', 'time': '8h ago', 'cat': 'Technology', 'color': const Color(0xFFF39C12)},
      {'title': 'Youth Voter Turnout Expected to Rise This Election', 'source': 'Youth Voice', 'time': '12h ago', 'cat': 'Analysis', 'color': const Color(0xFFE74C3C)},
    ];

    return Scaffold(
      backgroundColor: ElectraTheme.background,
      body: SafeArea(child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text('News & Updates', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700)))),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Text('Multi-source, AI-summarized election news', style: GoogleFonts.inter(fontSize: 13, color: ElectraTheme.textSecondary)))),
        // Category chips
        SliverToBoxAdapter(child: SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: ['All', 'Official', 'Analysis', 'Technology', 'Registration'].map((c) =>
            Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: c == 'All' ? ElectraTheme.primary : ElectraTheme.cardBg,
                borderRadius: BorderRadius.circular(100), border: Border.all(color: c == 'All' ? ElectraTheme.primary : ElectraTheme.divider)),
              child: Text(c, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600,
                color: c == 'All' ? Colors.white : ElectraTheme.textSecondary)))).toList()))),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(delegate: SliverChildBuilderDelegate((context, i) {
            final a = articles[i];
            return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ElectraTheme.divider), boxShadow: ElectraTheme.shadowSm),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: (a['color'] as Color).withValues(alpha:0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(a['cat'] as String, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: a['color'] as Color))),
                  const Spacer(),
                  Text(a['time'] as String, style: GoogleFonts.inter(fontSize: 11, color: ElectraTheme.textTertiary)),
                ]),
                const SizedBox(height: 10),
                Text(a['title'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, height: 1.3)),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.newspaper_rounded, size: 14, color: ElectraTheme.textTertiary),
                  const SizedBox(width: 4),
                  Text(a['source'] as String, style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textTertiary)),
                  const Spacer(),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: ElectraTheme.primary.withValues(alpha:0.1), borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.auto_awesome, size: 12, color: ElectraTheme.primary),
                      const SizedBox(width: 4),
                      Text('AI Summary', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: ElectraTheme.primary)),
                    ])),
                ]),
              ]));
          }, childCount: articles.length))),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ])),
    );
  }
}
