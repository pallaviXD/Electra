import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  int? _selectedCandidate;
  bool _showConfirmation = false;
  bool _voteRecorded = false;

  final List<Map<String, dynamic>> _candidates = [
    {'name': 'Candidate A', 'party': 'Party Alpha', 'symbol': '🌸', 'color': const Color(0xFFE74C3C)},
    {'name': 'Candidate B', 'party': 'Party Beta', 'symbol': '🌿', 'color': const Color(0xFF27AE60)},
    {'name': 'Candidate C', 'party': 'Party Gamma', 'symbol': '⭐', 'color': const Color(0xFFF39C12)},
    {'name': 'Candidate D', 'party': 'Party Delta', 'symbol': '🔵', 'color': const Color(0xFF3498DB)},
    {'name': 'Candidate E', 'party': 'Independent', 'symbol': '🕊️', 'color': const Color(0xFF9B59B6)},
    {'name': 'NOTA', 'party': 'None of the Above', 'symbol': '✖️', 'color': const Color(0xFF7F8C8D)},
  ];

  void _reset() {
    setState(() {
      _selectedCandidate = null;
      _showConfirmation = false;
      _voteRecorded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(
        backgroundColor: ElectraTheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Voting Simulator',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: _voteRecorded ? _buildSuccess() : _buildEVM(),
    );
  }

  Widget _buildEVM() {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ElectraTheme.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(ElectraTheme.radiusMd),
            border: Border.all(color: ElectraTheme.info.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: ElectraTheme.info, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'This is an educational simulation. No real votes are recorded.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ElectraTheme.info,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        // EVM Machine
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50),
              borderRadius: BorderRadius.circular(ElectraTheme.radiusLg),
              boxShadow: ElectraTheme.shadowLg,
            ),
            child: Column(
              children: [
                // EVM Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'ELECTRONIC VOTING MACHINE (SIMULATOR)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white60,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                // Candidate List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _candidates.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final candidate = _candidates[index];
                      final isSelected = _selectedCandidate == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCandidate = index;
                            _showConfirmation = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (candidate['color'] as Color).withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? (candidate['color'] as Color)
                                  : Colors.white.withValues(alpha: 0.1),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                candidate['symbol'],
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      candidate['name'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      candidate['party'],
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Vote button light
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ElectraTheme.success
                                      : Colors.white.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Confirm Button
        if (_showConfirmation) ...[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _reset,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ElectraTheme.cardBg,
                        borderRadius: BorderRadius.circular(ElectraTheme.radiusRound),
                        border: Border.all(color: ElectraTheme.divider),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ElectraTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _voteRecorded = true;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: ElectraTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(ElectraTheme.radiusRound),
                        boxShadow: ElectraTheme.shadowGreen,
                      ),
                      child: Center(
                        child: Text(
                          'Confirm Vote',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSuccess() {
    final selected = _candidates[_selectedCandidate!];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: ElectraTheme.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: ElectraTheme.success,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Vote Recorded! ✅',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: ElectraTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You voted for ${selected['name']} (${selected['party']})',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: ElectraTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This was a simulation. In real elections, your vote is completely secret and anonymous.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: ElectraTheme.textTertiary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _reset,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: ElectraTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(ElectraTheme.radiusRound),
                  boxShadow: ElectraTheme.shadowGreen,
                ),
                child: Text(
                  'Try Again',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
