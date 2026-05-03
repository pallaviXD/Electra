import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/disclaimer_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      body: SafeArea(
        child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ─────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: ElectraTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'E',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Electra',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: ElectraTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'Your Election Assistant',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: ElectraTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: ElectraTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 600.ms).slideY(begin: -0.2),
              ),

              // ── Search Bar ──────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: GestureDetector(
                    onTap: () => context.push('/chat'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: ElectraTheme.cardBg,
                        borderRadius: BorderRadius.circular(ElectraTheme.radiusRound),
                        boxShadow: ElectraTheme.shadowSm,
                        border: Border.all(color: ElectraTheme.divider),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: ElectraTheme.textTertiary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Ask anything about elections...',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: ElectraTheme.textTertiary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: ElectraTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: ElectraTheme.primary,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Hero Card ──────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: ElectraTheme.darkGradient,
                      borderRadius: BorderRadius.circular(ElectraTheme.radiusXl),
                      boxShadow: ElectraTheme.shadowLg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ElectraTheme.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: ElectraTheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'UPCOMING',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: ElectraTheme.primaryLight,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'General Elections 2026',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Stay informed, vote responsibly. Your voice matters in shaping the future.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _HeroStat(label: 'States', value: '28+'),
                            const SizedBox(width: 24),
                            _HeroStat(label: 'Seats', value: '543'),
                            const SizedBox(width: 24),
                            _HeroStat(label: 'Voters', value: '96Cr+'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => context.push('/timeline'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: ElectraTheme.primary,
                              borderRadius: BorderRadius.circular(ElectraTheme.radiusRound),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View Timeline',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 300.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad)
                   .animate(onPlay: (controller) => controller.repeat(reverse: true))
                   .shimmer(duration: 3000.ms, color: Colors.white.withValues(alpha: 0.1)),
                ),
              ),

              // ── Quick Actions Header ────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Text(
                    'Quick Actions',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ElectraTheme.textPrimary,
                    ),
                  ),
                ),
              ),

              // ── Quick Action Grid ───────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildListDelegate([
                    QuickActionCard(
                      icon: Icons.how_to_vote_rounded,
                      label: 'How to\nVote',
                      color: ElectraTheme.primary,
                      onTap: () => context.push('/voting-guide'),
                    ).animate().fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.timeline_rounded,
                      label: 'Election\nTimeline',
                      color: const Color(0xFF3498DB),
                      onTap: () => context.push('/timeline'),
                    ).animate(delay: 100.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.verified_user_rounded,
                      label: 'Check\nEligibility',
                      color: const Color(0xFF9B59B6),
                      onTap: () => context.push('/eligibility'),
                    ).animate(delay: 200.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.auto_awesome,
                      label: 'Ask\nAI',
                      color: const Color(0xFFE67E22),
                      onTap: () => context.push('/chat'),
                    ).animate(delay: 300.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.newspaper_rounded,
                      label: 'News &\nUpdates',
                      color: const Color(0xFFE74C3C),
                      onTap: () => context.go('/news'),
                    ).animate(delay: 400.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.location_on_rounded,
                      label: 'Find\nBooth',
                      color: const Color(0xFF1ABC9C),
                      onTap: () => context.push('/polling-booth'),
                    ).animate(delay: 500.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                  ]),
                ),
              ),

              // ── Smart Tools Header ──────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Text(
                    'Smart Tools',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ElectraTheme.textPrimary,
                    ),
                  ),
                ),
              ),

              // ── Smart Tools Grid ────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildListDelegate([
                    QuickActionCard(
                      icon: Icons.touch_app_rounded,
                      label: 'Voting\nSimulator',
                      color: const Color(0xFF2ECC71),
                      onTap: () => context.push('/simulator'),
                    ).animate(delay: 600.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.compare_arrows_rounded,
                      label: 'Compare\nCandidates',
                      color: const Color(0xFF3498DB),
                      onTap: () => context.push('/candidates'),
                    ).animate(delay: 700.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.description_rounded,
                      label: 'Manifesto\nSimplifier',
                      color: const Color(0xFFF39C12),
                      onTap: () => context.push('/manifesto'),
                    ).animate(delay: 800.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.quiz_rounded,
                      label: 'Who\nMatches?',
                      color: const Color(0xFF8E44AD),
                      onTap: () => context.push('/quiz'),
                    ).animate(delay: 900.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.fact_check_rounded,
                      label: 'Fact\nChecker',
                      color: const Color(0xFFE74C3C),
                      onTap: () => context.push('/fact-check'),
                    ).animate(delay: 1000.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                    QuickActionCard(
                      icon: Icons.bar_chart_rounded,
                      label: 'Results\nTracker',
                      color: const Color(0xFF16A085),
                      onTap: () => context.push('/results'),
                    ).animate(delay: 1100.ms).fade(duration: 400.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
                  ]),
                ),
              ),

              // ── Disclaimer ──────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 100),
                  child: DisclaimerBanner(),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ElectraTheme.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
