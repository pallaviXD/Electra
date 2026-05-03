import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/timeline_event.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  List<TimelineEvent> get _events => [
    TimelineEvent(
      id: '1',
      title: 'Voter Registration Deadline',
      description: 'Last date to register as a voter or update details in the electoral roll.',
      date: DateTime(2026, 3, 15),
      icon: '📋',
      isCompleted: true,
    ),
    TimelineEvent(
      id: '2',
      title: 'Nomination Filing',
      description: 'Candidates file their nominations with the Election Commission.',
      date: DateTime(2026, 4, 1),
      icon: '📝',
      isCompleted: true,
    ),
    TimelineEvent(
      id: '3',
      title: 'Campaign Period',
      description: 'Official campaigning period begins. Rallies, debates, and outreach.',
      date: DateTime(2026, 4, 15),
      icon: '📢',
      isCurrent: true,
    ),
    TimelineEvent(
      id: '4',
      title: 'Campaign Silence',
      description: '48-hour silence period before voting. No campaigning allowed.',
      date: DateTime(2026, 5, 10),
      icon: '🤫',
    ),
    TimelineEvent(
      id: '5',
      title: 'Voting Day - Phase 1',
      description: 'First phase of voting across multiple constituencies.',
      date: DateTime(2026, 5, 12),
      icon: '🗳️',
    ),
    TimelineEvent(
      id: '6',
      title: 'Voting Day - Phase 2',
      description: 'Second phase of voting in remaining constituencies.',
      date: DateTime(2026, 5, 19),
      icon: '🗳️',
    ),
    TimelineEvent(
      id: '7',
      title: 'Vote Counting',
      description: 'Counting of votes begins across all constituencies.',
      date: DateTime(2026, 5, 23),
      icon: '🔢',
    ),
    TimelineEvent(
      id: '8',
      title: 'Results Declaration',
      description: 'Final election results announced by the Election Commission.',
      date: DateTime(2026, 5, 25),
      icon: '📊',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final events = _events;

    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(
        backgroundColor: ElectraTheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Election Timeline',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminders feature coming soon!',
                    style: GoogleFonts.inter()),
                  backgroundColor: ElectraTheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final isLast = index == events.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline indicator
                SizedBox(
                  width: 40,
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: event.isCompleted
                              ? ElectraTheme.primary
                              : event.isCurrent
                                  ? ElectraTheme.primary.withValues(alpha: 0.2)
                                  : ElectraTheme.divider,
                          shape: BoxShape.circle,
                          border: event.isCurrent
                              ? Border.all(color: ElectraTheme.primary, width: 2)
                              : null,
                          boxShadow: event.isCurrent
                              ? ElectraTheme.shadowGreen
                              : null,
                        ),
                        child: Center(
                          child: event.isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : Text(
                                  event.icon,
                                  style: const TextStyle(fontSize: 14),
                                ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: event.isCompleted
                                ? ElectraTheme.primary.withValues(alpha: 0.4)
                                : ElectraTheme.divider,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: event.isCurrent
                          ? ElectraTheme.primary.withValues(alpha: 0.05)
                          : ElectraTheme.cardBg,
                      borderRadius: BorderRadius.circular(ElectraTheme.radiusMd),
                      border: Border.all(
                        color: event.isCurrent
                            ? ElectraTheme.primary.withValues(alpha: 0.3)
                            : ElectraTheme.divider,
                      ),
                      boxShadow: event.isCurrent
                          ? ElectraTheme.shadowSm
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (event.isCurrent)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: ElectraTheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'NOW',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                event.title,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: event.isCompleted
                                      ? ElectraTheme.textTertiary
                                      : ElectraTheme.textPrimary,
                                  decoration: event.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          event.description,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: ElectraTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_formatDate(event.date)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: event.isCurrent
                                ? ElectraTheme.primary
                                : ElectraTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
