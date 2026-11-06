import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/seed.dart';
import '../router.dart';
import '../widgets/common.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    Widget tile(IconData i, String t, VoidCallback tap, {String? sub}) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(i, color: context.cs.primary),
          title: Text(t),
          subtitle: sub == null ? null : Text(sub),
          trailing: const Icon(Icons.chevron_right),
          onTap: tap,
        );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.tr('Profile', 'ಪ್ರೊಫೈಲ್')),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: [
        SevaCard(
          child: Row(children: [
            const IconBadge(Icons.person_outline, size: 52),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.loc(citizenName), style: context.tt.titleLarge),
                Text('$citizenMobile · ${context.loc(citizenDistrict)}',
                    style: TextStyle(color: context.cs.onSurfaceVariant)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.translate, color: context.cs.primary),
          title: Text(context.tr('Language', 'ಭಾಷೆ')),
          trailing: SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'kn', label: Text('ಕನ್ನಡ')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {s.lang},
            onSelectionChanged: (v) => app.set(() => app.lang = v.first),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(Icons.fingerprint, color: context.cs.primary),
          title: Text(context.tr('Fingerprint or Face ID login', 'ಬೆರಳಚ್ಚು ಅಥವಾ ಮುಖ ಗುರುತು ಲಾಗಿನ್')),
          value: s.biometric,
          onChanged: (v) => app.set(() => app.biometric = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(Icons.dark_mode_outlined, color: context.cs.primary),
          title: Text(context.tr('Dark mode', 'ಡಾರ್ಕ್ ಮೋಡ್')),
          value: s.darkMode,
          onChanged: (v) => app.set(() => app.darkMode = v),
        ),
        tile(Icons.group_add_outlined, context.tr('Family profiles', 'ಕುಟುಂಬದ ಪ್ರೊಫೈಲ್‌ಗಳು'),
            () => openRoute('family')),
        tile(Icons.receipt_long_outlined, context.tr('Transaction history', 'ವಹಿವಾಟು ಇತಿಹಾಸ'),
            () => openRoute('transactions')),
        tile(Icons.timeline, context.tr('Track status', 'ಸ್ಥಿತಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ'), () => openRoute('track')),
        tile(Icons.qr_code_2, context.tr('My QR code', 'ನನ್ನ ಕ್ಯೂಆರ್ ಕೋಡ್'), () => openRoute('myqr')),
        tile(Icons.menu_book_outlined, context.tr('Service directory', 'ಸೇವಾ ಡೈರೆಕ್ಟರಿ'),
            () => openRoute('directory')),
        tile(Icons.sign_language_outlined, context.tr('Sign language chatbot', 'ಸಂಕೇತ ಭಾಷೆ ಚಾಟ್‌ಬಾಟ್'),
            () => openRoute('isl')),
        tile(Icons.network_check, context.tr('Mobile signal check', 'ಮೊಬೈಲ್ ಸಿಗ್ನಲ್ ಪರಿಶೀಲನೆ'),
            () => openRoute('signal')),
        tile(Icons.accessibility_new, context.tr('Accessibility', 'ಪ್ರವೇಶಿಸುವಿಕೆ'),
            () => openRoute('accessibility')),
        tile(Icons.notifications_outlined, context.tr('Notifications', 'ಅಧಿಸೂಚನೆಗಳು'),
            () => openRoute('notifications')),
        tile(Icons.lock_outline, 'DigiLocker', () => openRoute('documents'),
            sub: s.digilockerLinked
                ? context.tr('Linked', 'ಲಿಂಕ್ ಆಗಿದೆ')
                : context.tr('Not linked', 'ಲಿಂಕ್ ಆಗಿಲ್ಲ')),
        tile(Icons.support_agent_outlined, context.tr('Help', 'ಸಹಾಯ'), () => openRoute('help')),
        tile(Icons.star_outline, context.tr('Give feedback', 'ಪ್ರತಿಕ್ರಿಯೆ ನೀಡಿ'),
            () => openRoute('feedback')),
        tile(Icons.checklist_rtl, context.tr('Feature map', 'ವೈಶಿಷ್ಟ್ಯ ನಕ್ಷೆ'),
            () => openRoute('features'),
            sub: context.tr('Every planned feature, one tap away', 'ಪ್ರತಿ ವೈಶಿಷ್ಟ್ಯವೂ ಒಂದೇ ಟ್ಯಾಪ್‌ನಲ್ಲಿ')),
        const SizedBox(height: 12),
        if (s.digilockerLinked)
          TextButton(
            onPressed: app.unlinkDigilocker,
            child: Text(context.tr('Unlink DigiLocker', 'ಡಿಜಿಲಾಕರ್ ಅನ್‌ಲಿಂಕ್ ಮಾಡಿ')),
          ),
        TextButton(
          onPressed: app.logout,
          child: Text(context.tr('Sign out', 'ಸೈನ್ ಔಟ್')),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil((r) => r.isFirst);
            app.resetDemo();
          },
          child: Text(context.tr('Reset demo', 'ಡೆಮೊ ಮರುಹೊಂದಿಸಿ')),
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
    Widget sw(String t, String sub, bool v, void Function(bool) f) => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(t),
          subtitle: Text(sub),
          value: v,
          onChanged: (x) => app.set(() => f(x)),
        );
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Accessibility', 'ಪ್ರವೇಶಿಸುವಿಕೆ'))),
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
        const SizedBox(height: 8),
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

/// Demo aid: the plan's feature list, with a jump to each one.
class FeatureMapScreen extends StatelessWidget {
  const FeatureMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watchApp;
    const f = <(int, String, String, String)>[
      (1, 'Integrated DigiLocker', 'Improved', 'documents'),
      (2, 'Automatic document fetching', 'Live', 'services'),
      (3, 'Voice bot', 'New', 'voice'),
      (4, 'Kannada and English', 'Live', 'profile'),
      (5, 'SMS-based access', 'New', 'sms'),
      (6, 'Voice-based discovery', 'Live', 'search'),
      (7, 'Feedback', 'New', 'feedback'),
      (8, 'Application tracking', 'Improved', 'track'),
      (9, 'Utility payments', 'New', 'bills'),
      (10, 'Schemes and services split', 'Improved', 'schemes'),
      (11, 'Eligibility recommendation', 'New', 'eligibility'),
      (12, 'Accessibility', 'New', 'accessibility'),
      (13, 'Document verification', 'Improved', 'verify'),
      (14, 'iPGRS grievance', 'Live', 'grievance'),
      (15, 'Aadhaar and e-Sign', 'Improved', 'services'),
      (16, 'Live chat and helpline', 'Improved', 'chat'),
      (17, 'Document scanner', 'New', 'scanner'),
      (18, 'OCR', 'New', 'scanner'),
      (19, 'GramaOne / Karnataka One centres', 'New', 'centres'),
      (20, 'Weather and AQI', 'New', 'weather'),
      (21, 'Push notifications', 'New', 'notifications'),
      (22, 'Life events (from UMANG)', 'New', 'life'),
      (23, 'Finance calculators (from UMANG)', 'New', 'calculators'),
      (24, 'IVR helpline (from UMANG)', 'New', 'help'),
      (25, 'Biometric login (from UMANG)', 'New', 'profile'),
      (26, 'Seva AI home and situations (from UMANG)', 'New', 'life'),
      (27, 'Browse by persona and category (from UMANG)', 'New', 'services'),
      (28, 'Scheme and document explorers (from UMANG)', 'New', 'schemes'),
      (29, 'Helplines, emergency, jobs (from UMANG)', 'New', 'helplines'),
      (30, 'DIGIPIN and authenticator (from UMANG)', 'New', 'digipin'),
      (31, 'WhatsApp channel (from UMANG)', 'New', 'whatsapp'),
      (32, 'Sign language bot, signal check, QR (from UMANG)', 'New', 'isl'),
      (33, 'Family, transactions, directory (from UMANG)', 'New', 'family'),
    ];
    Color tone(String s) => switch (s) {
          'New' => context.cs.primary,
          'Improved' => context.cs.secondary,
          _ => context.cs.onSurfaceVariant,
        };
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Feature map', 'ವೈಶಿಷ್ಟ್ಯ ನಕ್ಷೆ'))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: f.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final (n, name, status, route) = f[i];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              width: 26,
              child: Text('$n', style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            title: Text(name),
            trailing: Pill(status, color: tone(status)),
            onTap: () => openRoute(route),
          );
        },
      ),
    );
  }
}
