class Candidate {
  final String id;
  final String name;
  final String party;
  final String partySymbol;
  final String? photoUrl;
  final String education;
  final String experience;
  final int age;
  final String constituency;
  final List<String> promises;
  final Map<String, dynamic>? stats;

  Candidate({
    required this.id,
    required this.name,
    required this.party,
    required this.partySymbol,
    this.photoUrl,
    required this.education,
    required this.experience,
    required this.age,
    required this.constituency,
    required this.promises,
    this.stats,
  });
}
