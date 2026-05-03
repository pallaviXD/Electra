import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';

class PollingBoothScreen extends StatefulWidget {
  const PollingBoothScreen({super.key});
  @override
  State<PollingBoothScreen> createState() => _PollingBoothScreenState();
}

class _PollingBoothScreenState extends State<PollingBoothScreen> {
  final _controller = TextEditingController();
  bool _searching = false;
  bool _found = false;

  void _search() {
    if (_controller.text.trim().isEmpty) return;
    setState(() { _searching = true; _found = false; });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() { _searching = false; _found = true; });
    });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(
        backgroundColor: ElectraTheme.surface,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Polling Booth Locator', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          // Simulated Map Background
          Positioned.fill(
            child: Container(
              color: ElectraTheme.surface,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 80, color: ElectraTheme.divider),
                    const SizedBox(height: 16),
                    Text(
                      _found ? 'Map view loaded (Simulation)' : 'Enter your pincode to find your booth',
                      style: GoogleFonts.inter(color: ElectraTheme.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Panel
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ElectraTheme.cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Find Your Polling Station', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: ElectraTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ElectraTheme.divider),
                    ),
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter your 6-digit pincode...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintStyle: GoogleFonts.inter(color: ElectraTheme.textTertiary, fontSize: 14),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.my_location_rounded, color: ElectraTheme.primary),
                          onPressed: () {
                            _controller.text = '110001';
                            _search();
                          },
                        ),
                      ),
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    label: 'Search Booth',
                    icon: Icons.search_rounded,
                    onPressed: _search,
                    isLoading: _searching,
                    width: double.infinity,
                  ),
                  if (_found) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ElectraTheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ElectraTheme.primary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: ElectraTheme.primary, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.where_to_vote_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Central Public School', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text('Booth No. 42 • 1.2 km away', style: GoogleFonts.inter(fontSize: 13, color: ElectraTheme.textSecondary)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.directions_rounded, color: ElectraTheme.primary),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
