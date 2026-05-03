import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/candidate.dart';

class CandidateCompareScreen extends StatefulWidget {
  const CandidateCompareScreen({super.key});
  @override
  State<CandidateCompareScreen> createState() => _CandidateCompareScreenState();
}

class _CandidateCompareScreenState extends State<CandidateCompareScreen> {
  int _selA = 0, _selB = 1;

  final _candidates = [
    Candidate(id:'1',name:'Candidate A',party:'Party Alpha',partySymbol:'🌸',education:'MBA, Political Science',experience:'12 yrs public service',age:52,constituency:'Central',promises:['Education reform','Healthcare','Infrastructure'],stats:{'cases':0,'attend':87,'questions':145,'assets':8.5}),
    Candidate(id:'2',name:'Candidate B',party:'Party Beta',partySymbol:'🌿',education:'PhD Economics',experience:'8 yrs council member',age:45,constituency:'Central',promises:['Job creation','Environment','Digital governance'],stats:{'cases':1,'attend':72,'questions':89,'assets':15.2}),
    Candidate(id:'3',name:'Candidate C',party:'Party Gamma',partySymbol:'⭐',education:'B.Tech, Law',experience:'15 yrs social activism',age:48,constituency:'Central',promises:['Women safety','Agriculture','Anti-corruption'],stats:{'cases':0,'attend':91,'questions':210,'assets':3.2}),
  ];

  @override
  Widget build(BuildContext context) {
    final a = _candidates[_selA], b = _candidates[_selB];
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(backgroundColor: ElectraTheme.surface,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Compare Candidates', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Row(children: [
          Expanded(child: _sel(a, true)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(width: 32, height: 32, decoration: BoxDecoration(color: ElectraTheme.primary.withValues(alpha:0.1), shape: BoxShape.circle),
              child: const Center(child: Text('VS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ElectraTheme.primary))))),
          Expanded(child: _sel(b, false)),
        ]),
        const SizedBox(height: 20),
        _row('Age', '${a.age}', '${b.age}'), _row('Education', a.education, b.education),
        _row('Experience', a.experience, b.experience), _row('Party', a.party, b.party),
        const SizedBox(height: 16),
        Text('Key Promises', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(children: a.promises.map((p) => _promise(p)).toList())),
          const SizedBox(width: 12),
          Expanded(child: Column(children: b.promises.map((p) => _promise(p)).toList())),
        ]),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
          color: ElectraTheme.info.withValues(alpha:0.08), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ElectraTheme.info.withValues(alpha:0.2))),
          child: Row(children: [
            const Icon(Icons.info_outline, color: ElectraTheme.info, size: 18), const SizedBox(width: 10),
            Expanded(child: Text('Sample data for demonstration only.', style: GoogleFonts.inter(fontSize: 11, color: ElectraTheme.info))),
          ])),
        const SizedBox(height: 40),
      ]),
    );
  }

  Widget _sel(Candidate c, bool left) => GestureDetector(
    onTap: () => showModalBottomSheet(context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Select', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)), const SizedBox(height: 12),
        ..._candidates.asMap().entries.map((e) => ListTile(
          leading: Text(e.value.partySymbol, style: const TextStyle(fontSize: 24)),
          title: Text(e.value.name), subtitle: Text(e.value.party),
          onTap: () { setState(() { if(left) _selA=e.key; else _selB=e.key; }); Navigator.pop(context); })),
      ]))),
    child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
      color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: ElectraTheme.divider), boxShadow: ElectraTheme.shadowSm),
      child: Column(children: [
        Text(c.partySymbol, style: const TextStyle(fontSize: 28)), const SizedBox(height: 6),
        Text(c.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        Text(c.party, style: GoogleFonts.inter(fontSize: 11, color: ElectraTheme.textTertiary)),
        Text('Tap to change ▼', style: GoogleFonts.inter(fontSize: 10, color: ElectraTheme.primary)),
      ])));

  Widget _row(String label, String va, String vb) => Padding(padding: const EdgeInsets.only(bottom: 10),
    child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
      color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: ElectraTheme.divider)),
      child: Column(children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textTertiary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: Text(va, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
          Container(width: 1, height: 20, color: ElectraTheme.divider),
          Expanded(child: Text(vb, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
        ]),
      ])));

  Widget _promise(String p) => Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: ElectraTheme.divider)),
    child: Row(children: [
      const Icon(Icons.arrow_right_rounded, size: 18, color: ElectraTheme.primary), const SizedBox(width: 4),
      Expanded(child: Text(p, style: GoogleFonts.inter(fontSize: 12))),
    ]));
}
