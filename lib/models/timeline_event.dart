class TimelineEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String icon;
  final bool isCompleted;
  final bool isCurrent;

  TimelineEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}
