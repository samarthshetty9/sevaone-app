import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/seed.dart';
import '../router.dart';
import '../app/theme.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    Widget tile(IconData i, String t, VoidCallback tap, {String? sub}) => ListTile(
          leading: IconBadge(i, size: 36),
          title: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: sub == null ? null : Text(sub),
          trailing: const Icon(Icons.chevron_right),
          onTap: tap,
        );
    Widget group(String title, List<Widget> kids) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 8, left: 4),
              child: Text(title, style: context.tt.titleLarge?.copyWith(fontSize: 17)),
            ),
            SevaCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: kids),
            ),
          ],
        );
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Profile', 'ಪ್ರೊಫೈಲ್'))),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 28), children: [
        GlowPanel(
          child: Row(children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: s.profileScore / 10,
                    strokeWidth: 5,
                    color: Seva.gold,
                    backgroundColor: Colors.white24,
                  ),
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text(context.tr('AG', 'ಅ'),
                      style: const TextStyle(
                          color: Seva.navy, fontWeight: FontWeight.w700, fontSize: 18)),
                ),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.loc(citizenName),
                    style: context.tt.titleLarge?.copyWith(color: Colors.white)),
                Text('$citizenMobile · ${context.loc(citizenDistrict)}',
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(height: 4),
                Text(context.tr('Profile ${s.profileScore}/10 complete', 'ಪ್ರೊಫೈಲ್ ${s.profileScore}/10 ಪೂರ್ಣ'),
                    style: const TextStyle(color: Seva.gold, fontWeight: FontWeight.w600, fontSize: 13)),
              ]),
            ),
          ]),
        ),
        group(context.tr('My account', 'ನನ್ನ ಖಾತೆ'), [
          tile(Icons.group_add, context.tr('Family profiles', 'ಕುಟುಂಬದ ಪ್ರೊಫೈಲ್‌ಗಳು'), () => openRoute('family')),
          tile(Icons.receipt_long, context.tr('Transaction history', 'ವಹಿವಾಟು ಇತಿಹಾಸ'), () => openRoute('transactions')),
          tile(Icons.timeline, context.tr('Track status', 'ಸ್ಥಿತಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ'), () => openRoute('track')),
          tile(Icons.qr_code_2, context.tr('My QR code', 'ನನ್ನ ಕ್ಯೂಆರ್ ಕೋಡ್'), () => openRoute('myqr')),
          tile(Icons.lock, 'DigiLocker', () => openRoute('documents'),
              sub: s.digilockerLinked
                  ? context.tr('Linked', 'ಲಿಂಕ್ ಆಗಿದೆ')
                  : context.tr('Not linked', 'ಲಿಂಕ್ ಆಗಿಲ್ಲ')),
        ]),
        group(context.tr('Preferences', 'ಆದ್ಯತೆಗಳು'), [
          ListTile(
            leading: const IconBadge(Icons.translate, size: 36),
            title: Text(context.tr('Language', 'ಭಾಷೆ'), style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 'kn', label: Text('ಕ')),
                ButtonSegment(value: 'en', label: Text('En')),
              ],
              selected: {s.lang},
              onSelectionChanged: (v) => app.set(() => app.lang = v.first),
            ),
          ),
          SwitchListTile(
            secondary: const IconBadge(Icons.dark_mode, size: 36),
            title: Text(context.tr('Dark mode', 'ಡಾರ್ಕ್ ಮೋಡ್'), style: const TextStyle(fontWeight: FontWeight.w600)),
            value: s.darkMode,
            onChanged: (v) => app.set(() => app.darkMode = v),
          ),
          SwitchListTile(
            secondary: const IconBadge(Icons.fingerprint, size: 36),
            title: Text(context.tr('Fingerprint or Face ID', 'ಬೆರಳಚ್ಚು ಅಥವಾ ಮುಖ ಗುರುತು'),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            value: s.biometric,
            onChanged: (v) => app.set(() => app.biometric = v),
          ),
          tile(Icons.notifications, context.tr('Notifications', 'ಅಧಿಸೂಚನೆಗಳು'), () => openRoute('notifications')),
          tile(Icons.accessibility_new, context.tr('Accessibility', 'ಪ್ರವೇಶಿಸುವಿಕೆ'), () => openRoute('accessibility')),
        ]),
        group(context.tr('Help and tools', 'ಸಹಾಯ ಮತ್ತು ಸಾಧನಗಳು'), [
          tile(Icons.support_agent, context.tr('Help', 'ಸಹಾಯ'), () => openRoute('help')),
          tile(Icons.menu_book, context.tr('Service directory', 'ಸೇವಾ ಡೈರೆಕ್ಟರಿ'), () => openRoute('directory')),
          tile(Icons.sign_language, context.tr('Sign language chatbot', 'ಸಂಕೇತ ಭಾಷೆ ಚಾಟ್‌ಬಾಟ್'), () => openRoute('isl')),
          tile(Icons.network_check, context.tr('Mobile signal check', 'ಮೊಬೈಲ್ ಸಿಗ್ನಲ್ ಪರಿಶೀಲನೆ'), () => openRoute('signal')),
          tile(Icons.star, context.tr('Give feedback', 'ಪ್ರತಿಕ್ರಿಯೆ ನೀಡಿ'), () => openRoute('feedback')),
        ]),
        const SizedBox(height: 12),
        if (s.digilockerLinked)
          TextButton(
            onPressed: app.unlinkDigilocker,
            child: Text(context.tr('Unlink DigiLocker', 'ಡಿಜಿಲಾಕರ್ ಅನ್‌ಲಿಂಕ್ ಮಾಡಿ')),
          ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(foregroundColor: context.cs.error),
          onPressed: () {
            Navigator.of(context).popUntil((r) => r.isFirst);
            app.logout();
          },
          icon: const Icon(Icons.logout),
          label: Text(context.tr('Sign out', 'ಸೈನ್ ಔಟ್')),
        ),
      ]),
    );
  }
}

/// Feature 12. VoiceOver and TalkBack work through Semantics labels; the rest
/// are app-level settings applied in the MaterialApp builder.
class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    Widget sw(String t, String sub, bool v, void Function(bool) f) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SevaCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(sub),
              value: v,
              onChanged: (x) => app.set(() => f(x)),
            ),
          ),
        );
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Accessibility', 'ಪ್ರವೇಶಿಸುವಿಕೆ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(context.tr('Text size', 'ಪಠ್ಯ ಗಾತ್ರ'), style: context.tt.titleMedium),
        Slider(
          value: s.textScale,
          min: 0.9,
          max: 1.6,
          divisions: 7,
          label: '${(s.textScale * 100).round()}%',
          onChanged: (v) => app.set(() => app.textScale = v),
        ),
        SevaCard(
          child: Text(context.tr('This is how text will look.', 'ಪಠ್ಯ ಹೀಗೆ ಕಾಣುತ್ತದೆ.')),
        ),
        const SizedBox(height: 14),
        sw(context.tr('High contrast', 'ಹೆಚ್ಚಿನ ಕಾಂಟ್ರಾಸ್ಟ್'),
            context.tr('Stronger colours and bold text', 'ಗಾಢ ಬಣ್ಣಗಳು ಮತ್ತು ದಪ್ಪ ಪಠ್ಯ'),
            s.highContrast, (v) => app.highContrast = v),
        sw(context.tr('Dark mode', 'ಡಾರ್ಕ್ ಮೋಡ್'),
            context.tr('Easier on the eyes at night', 'ರಾತ್ರಿಯಲ್ಲಿ ಕಣ್ಣಿಗೆ ಹಿತ'),
            s.darkMode, (v) => app.darkMode = v),
        sw(context.tr('Reduce motion', 'ಚಲನೆ ಕಡಿಮೆ ಮಾಡಿ'),
            context.tr('Turn off animations', 'ಅನಿಮೇಶನ್‌ಗಳನ್ನು ಆಫ್ ಮಾಡಿ'),
            s.reduceMotion, (v) => app.reduceMotion = v),
        sw(context.tr('Read aloud button', 'ಗಟ್ಟಿಯಾಗಿ ಓದುವ ಬಟನ್'),
            context.tr('Shows on service pages', 'ಸೇವಾ ಪುಟಗಳಲ್ಲಿ ಕಾಣುತ್ತದೆ'),
            s.readAloud, (v) => app.readAloud = v),
        const SizedBox(height: 8),
        SevaCard(
          child: Row(children: [
            Icon(Icons.record_voice_over_outlined, color: context.cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(context.tr(
                  'Screen readers: SevaOne works with VoiceOver and TalkBack.',
                  'ಸ್ಕ್ರೀನ್ ರೀಡರ್: ಸೇವಾಒನ್ ವಾಯ್ಸ್‌ಓವರ್ ಮತ್ತು ಟಾಕ್‌ಬ್ಯಾಕ್ ಜೊತೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ.')),
            ),
          ]),
        ),
      ]),
    );
  }
}
