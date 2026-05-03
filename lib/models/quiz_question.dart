class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final Map<String, Map<String, int>> scoring; // option -> {party: score}

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.scoring,
  });
}
