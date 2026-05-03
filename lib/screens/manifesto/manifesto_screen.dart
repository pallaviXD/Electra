import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/settings_provider.dart';
import '../../services/ai_orchestrator.dart';
import '../../services/trust_service.dart';
import '../../widgets/gradient_button.dart';

class ManifestoScreen extends StatefulWidget {
  const ManifestoScreen({super.key});
  @override
  State<ManifestoScreen> createState() => _ManifestoScreenState();
}

class _ManifestoScreenState extends State<ManifestoScreen> {
  final _controller = TextEditingController();
  String? _simplified;
  bool _loading = false;

  Future<void> _simplify() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() { _loading = true; _simplified = null; });
    
    final language = context.read<SettingsProvider>().language;
    final result = await AiOrchestrator.instance.processRequest(
      type: AITaskType.manifesto,
      input: _controller.text,
      language: language,
    );
    
    setState(() {
      _loading = false;
      _simplified = result;
    });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(backgroundColor: ElectraTheme.surface,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Manifesto Simplifier', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
          gradient: ElectraTheme.subtleGradient, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(
              color: ElectraTheme.primary.withValues(alpha:0.15), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.auto_awesome, color: ElectraTheme.primary, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('AI-Powered Simplification', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
              Text('Paste any manifesto text and get easy-to-understand bullet points', style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textSecondary)),
            ])),
          ])),
        const SizedBox(height: 20),
        Text('Manifesto Text', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ElectraTheme.divider)),
          child: TextField(controller: _controller, maxLines: 8,
            decoration: InputDecoration(hintText: 'Paste manifesto text here...', border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: GoogleFonts.inter(color: ElectraTheme.textTertiary, fontSize: 14)),
            style: GoogleFonts.inter(fontSize: 14, height: 1.5))),
        const SizedBox(height: 16),
        GradientButton(label: 'Simplify with AI', icon: Icons.auto_awesome, onPressed: _simplify,
          isLoading: _loading, width: double.infinity),
        if (_simplified != null) ...[
          const SizedBox(height: 24),
          Text('Simplified Version', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
            color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ElectraTheme.primary.withValues(alpha:0.2)), boxShadow: ElectraTheme.shadowSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_simplified!, style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: ElectraTheme.textPrimary)),
                const SizedBox(height: 12),
                TrustMetadataWidget(
                  metadata: TrustService.instance.getMetadataForResponse(_simplified!),
                ),
              ],
            ),
          ),
        ],
      ])),
    );
  }
}
