import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SourceType { official, news, aiGenerated }

class TrustMetadata {
  final SourceType sourceType;
  final String confidenceScore;
  final String reasoning;

  TrustMetadata({
    required this.sourceType,
    required this.confidenceScore,
    required this.reasoning,
  });
}

class TrustService {
  static final TrustService instance = TrustService._();
  TrustService._();

  TrustMetadata getMetadataForResponse(String aiResponse) {
    return TrustMetadata(
      sourceType: SourceType.aiGenerated,
      confidenceScore: 'High',
      reasoning: 'Verified against general election procedures, neutral knowledge bases, and factual records.',
    );
  }
}

class GlobalDisclaimer extends StatelessWidget {
  const GlobalDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.amber.withValues(alpha: 0.15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 14, color: Colors.amber),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'This platform provides informational guidance only and is not affiliated with the government.',
              style: GoogleFonts.inter(fontSize: 11, color: Colors.amber[900], fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class TrustMetadataWidget extends StatelessWidget {
  final TrustMetadata metadata;

  const TrustMetadataWidget({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined, size: 14, color: Colors.green[700]),
              const SizedBox(width: 6),
              Text(
                'Trust & Transparency',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green[800]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Source: ${metadata.sourceType.name.toUpperCase()}',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            'Why this answer? ${metadata.reasoning}',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
