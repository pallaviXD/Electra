import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class VotingGuideScreen extends StatelessWidget {
  const VotingGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(
        backgroundColor: ElectraTheme.surface,
        title: Text(
          'Voting Guide',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildPhaseCard(
            context,
            phase: 'Before Voting',
            icon: Icons.checklist_rounded,
            color: const Color(0xFF3498DB),
            steps: [
              _StepItem('Check your name in the voter list', 'Visit the Election Commission website or app to verify your registration', Icons.search_rounded),
              _StepItem('Locate your polling booth', 'Find your assigned polling station using your voter ID details', Icons.location_on_rounded),
              _StepItem('Gather required documents', 'Carry your Voter ID (EPIC) or any valid government photo ID', Icons.badge_rounded),
              _StepItem('Know your candidates', 'Research candidates contesting from your constituency', Icons.people_rounded),
              _StepItem('Plan your visit', 'Voting hours are typically 7 AM to 6 PM. Plan accordingly', Icons.schedule_rounded),
            ],
          ),
          const SizedBox(height: 16),
          _buildPhaseCard(
            context,
            phase: 'At the Polling Booth',
            icon: Icons.how_to_vote_rounded,
            color: ElectraTheme.primary,
            steps: [
              _StepItem('Queue up', 'Join the queue at your designated polling station', Icons.people_outline_rounded),
              _StepItem('Identity verification', 'Show your Voter ID to the polling officer for verification', Icons.verified_user_rounded),
              _StepItem('Receive slip', 'Get a voter slip after your identity is verified', Icons.receipt_rounded),
              _StepItem('Ink marking', 'Indelible ink will be applied to your left index finger', Icons.water_drop_rounded),
              _StepItem('Enter voting booth', 'Enter the booth privately - no phones or cameras allowed', Icons.sensor_door_rounded),
              _StepItem('Cast your vote', 'Press the button next to your chosen candidate on the EVM', Icons.touch_app_rounded),
              _StepItem('VVPAT verification', 'Check the VVPAT slip to confirm your vote was recorded correctly', Icons.check_circle_outlined),
            ],
          ),
          const SizedBox(height: 16),
          _buildPhaseCard(
            context,
            phase: 'After Voting',
            icon: Icons.celebration_rounded,
            color: const Color(0xFFF39C12),
            steps: [
              _StepItem('Voter selfie', 'Take a selfie with your inked finger to encourage others', Icons.camera_alt_rounded),
              _StepItem('Track results', 'Follow election results on official channels', Icons.bar_chart_rounded),
              _StepItem('Stay informed', 'Learn about the government formation process', Icons.school_rounded),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(
    BuildContext context, {
    required String phase,
    required IconData icon,
    required Color color,
    required List<_StepItem> steps,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ElectraTheme.cardBg,
        borderRadius: BorderRadius.circular(ElectraTheme.radiusLg),
        boxShadow: ElectraTheme.shadowSm,
        border: Border.all(color: ElectraTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  phase,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: ElectraTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isLast = i == steps.length - 1;

            return Container(
              padding: EdgeInsets.fromLTRB(16, 14, 16, isLast ? 16 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 1.5,
                          height: 40,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: color.withValues(alpha: 0.15),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ElectraTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.description,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: ElectraTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StepItem {
  final String title;
  final String description;
  final IconData icon;

  _StepItem(this.title, this.description, this.icon);
}
