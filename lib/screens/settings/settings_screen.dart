import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _largeText = false;

  static const List<Map<String, String>> _languages = [
    {'code': 'English', 'label': 'English', 'native': 'English'},
    {'code': 'हिन्दी', 'label': 'Hindi', 'native': 'हिन्दी'},
    {'code': 'తెలుగు', 'label': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'தமிழ்', 'label': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'ಕನ್ನಡ', 'label': 'Kannada', 'native': 'ಕನ್ನಡ'},
    {'code': 'मराठी', 'label': 'Marathi', 'native': 'मराठी'},
    {'code': 'বাংলা', 'label': 'Bengali', 'native': 'বাংলা'},
    {'code': 'ગુજરાતી', 'label': 'Gujarati', 'native': 'ગુજરાતી'},
    {'code': 'ਪੰਜਾਬੀ', 'label': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
    {'code': 'മലയാളം', 'label': 'Malayalam', 'native': 'മലയാളം'},
    {'code': 'اردو', 'label': 'Urdu', 'native': 'اردو'},
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Settings', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('Customize your Electra experience', style: GoogleFonts.inter(fontSize: 13, color: ElectraTheme.textSecondary)),
        const SizedBox(height: 24),

        // Profile card
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
          gradient: ElectraTheme.primaryGradient, borderRadius: BorderRadius.circular(16), boxShadow: ElectraTheme.shadowGreen),
          child: Row(children: [
            Container(width: 52, height: 52, decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user?.fullName ?? 'User',
                style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
              Text(user?.email ?? '',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
            ])),
            GestureDetector(
              onTap: () => auth.signOut(),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                child: Text('Sign Out',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: ElectraTheme.primary))),
            ),
          ])),

        const SizedBox(height: 24),
        _sectionTitle('Preferences'),
        _settingTile('Language', settings.language, Icons.translate_rounded, onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (_) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.85,
              builder: (_, controller) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: ElectraTheme.divider, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Text('Select Language', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('The AI chatbot will respond in your selected language', style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textSecondary)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(controller: controller, children: _languages.map((l) =>
                      ListTile(
                        leading: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: settings.language == l['code']
                                ? ElectraTheme.primary.withValues(alpha: 0.1)
                                : ElectraTheme.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(l['native']!.substring(0, 1),
                            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600,
                              color: settings.language == l['code'] ? ElectraTheme.primary : ElectraTheme.textSecondary))),
                        ),
                        title: Text(l['label']!, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                        subtitle: Text(l['native']!, style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textTertiary)),
                        trailing: settings.language == l['code']
                            ? const Icon(Icons.check_circle_rounded, color: ElectraTheme.primary)
                            : null,
                        onTap: () { settings.setLanguage(l['code']!); Navigator.pop(context); },
                      )).toList()),
                  ),
                ])),
            ));
        }),
        _switchTile('Notifications', 'Get election reminders', Icons.notifications_rounded, _notifications, (v) => setState(() => _notifications = v)),
        _switchTile('Large Text', 'Increase font size', Icons.text_increase_rounded, _largeText, (v) => setState(() => _largeText = v)),

        const SizedBox(height: 20),
        _sectionTitle('About'),
        _settingTile('Privacy Policy', 'Your data is safe', Icons.privacy_tip_rounded, onTap: () {}),
        _settingTile('Terms of Service', 'Read our terms', Icons.description_rounded, onTap: () {}),
        _settingTile('Version', '1.0.0', Icons.info_outline_rounded, onTap: () {}),

        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
          color: ElectraTheme.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ElectraTheme.info.withValues(alpha: 0.2))),
          child: Column(children: [
            Row(children: [
              const Icon(Icons.shield_rounded, color: ElectraTheme.info, size: 18), const SizedBox(width: 10),
              Text('Privacy Promise', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: ElectraTheme.info)),
            ]),
            const SizedBox(height: 6),
            Text('Electra does not collect sensitive voter data, store voter ID numbers, or share any personal information with third parties.',
              style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.info, height: 1.4)),
          ])),
        const SizedBox(height: 100),
      ])),
    );
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: ElectraTheme.textTertiary, letterSpacing: 0.5)));

  Widget _settingTile(String title, String subtitle, IconData icon, {VoidCallback? onTap}) => GestureDetector(onTap: onTap,
    child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: ElectraTheme.divider)),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: ElectraTheme.background, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: ElectraTheme.textSecondary, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textTertiary)),
        ])),
        const Icon(Icons.chevron_right_rounded, color: ElectraTheme.textTertiary, size: 20),
      ])));

  Widget _switchTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) =>
    Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: ElectraTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: ElectraTheme.divider)),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: ElectraTheme.background, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: ElectraTheme.textSecondary, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: ElectraTheme.textTertiary)),
        ])),
        Switch.adaptive(value: value, onChanged: onChanged, activeThumbColor: ElectraTheme.primary, activeTrackColor: ElectraTheme.primary.withValues(alpha: 0.4)),
      ]));
}
