import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/settings_provider.dart';
import '../../services/ai_orchestrator.dart';
import '../../services/trust_service.dart';
import '../../widgets/gradient_button.dart';

class MisinfoScreen extends StatefulWidget {
  const MisinfoScreen({super.key});
  @override
  State<MisinfoScreen> createState() => _MisinfoScreenState();
}

class _MisinfoScreenState extends State<MisinfoScreen> {
  final _controller = TextEditingController();
  String? _result;
  bool _loading = false;

  Future<void> _check() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() { _loading = true; _result = null; });
    final language = context.read<SettingsProvider>().language;
    final response = await AiOrchestrator.instance.processRequest(
      type: AITaskType.misinformation,
      input: _controller.text,
      language: language,
    );
    setState(() { _loading = false; _result = response; });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(backgroundColor: ElectraTheme.surface,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Fact Checker', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
          color: ElectraTheme.error.withValues(alpha:0.06), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ElectraTheme.error.withValues(alpha:0.15))),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(
              color: ElectraTheme.error.withValues(alpha:0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.fact_check_rounded, color: ElectraTheme.error, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Misinformation Detector', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
              Text('Paste any claim from WhatsApp, social media, or news', style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textSecondary)),
            ])),
          ])),
        const SizedBox(height: 20),
        Text('Claim to verify', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ElectraTheme.divider)),
          child: TextField(controller: _controller, maxLines: 5,
            decoration: InputDecoration(hintText: 'Paste the claim here...', border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16), hintStyle: GoogleFonts.inter(color: ElectraTheme.textTertiary, fontSize: 14)),
            style: GoogleFonts.inter(fontSize: 14, height: 1.5))),
        const SizedBox(height: 16),
        GradientButton(label: 'Verify Claim', icon: Icons.search_rounded, onPressed: _check, isLoading: _loading, width: double.infinity),
        if (_result != null) ...[
          const SizedBox(height: 24),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
            color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ElectraTheme.divider), boxShadow: ElectraTheme.shadowSm),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.analytics_rounded, color: ElectraTheme.primary, size: 20), const SizedBox(width: 8),
                Text('Analysis', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 12),
              Text(_result!, style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: ElectraTheme.textPrimary)),
              const SizedBox(height: 12),
              TrustMetadataWidget(
                metadata: TrustService.instance.getMetadataForResponse(_result!),
              ),
            ])),
        ],
      ])),
    );
  }
}
