import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../widgets/common.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    Widget option(String code, String title, String sub) {
      final on = s.lang == code;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: Colors.white.withValues(alpha: on ? 1 : 0.1),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => app.set(() => app.lang = code),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: on ? Seva.navy : Colors.white)),
                    Text(sub, style: TextStyle(color: on ? Seva.navy : Colors.white70)),
                  ]),
                ),
                Icon(on ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: on ? Seva.blue : Colors.white70),
              ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: Seva.headerGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Image.asset('assets/images/sevasindhu-logo.png',
                      width: 46, height: 46, semanticLabel: 'SevaOne'),
                ),
                const Spacer(),
                const DemoChip(onDark: true),
              ]),
              const Spacer(),
              Text('SevaOne',
                  style: context.tt.headlineMedium?.copyWith(color: Colors.white, fontSize: 38)),
              const SizedBox(height: 6),
              Text(
                context.tr('One Government, One Digital Platform',
                    'ಒಂದು ಸರ್ಕಾರ, ಒಂದು ಡಿಜಿಟಲ್ ವೇದಿಕೆ'),
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
              const SizedBox(height: 28),
              Text(context.tr('Choose your language', 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ'),
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              option('kn', 'ಕನ್ನಡ', 'Kannada'),
              option('en', 'English', 'ಇಂಗ್ಲಿಷ್'),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Seva.gold, foregroundColor: Seva.navy),
                  onPressed: () => app.set(() => app.onboarded = true),
                  child: Text(context.tr('Continue', 'ಮುಂದುವರಿಸಿ')),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobile = TextEditingController(text: '9800000210');
  final otp = TextEditingController();
  bool otpSent = false;
  bool busy = false;

  Future<void> sendOtp() async {
    setState(() => busy = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      busy = false;
      otpSent = true;
      otp.text = '123456';
    });
  }

  Future<void> verify() async {
    setState(() => busy = true);
    await Future.delayed(const Duration(milliseconds: 700));
    app.login();
  }

  @override
  void dispose() {
    mobile.dispose();
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: context.tr('Change language', 'ಭಾಷೆ ಬದಲಿಸಿ'),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => app.set(() => app.onboarded = false),
        ),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(22), children: [
        Text(context.tr('Sign in to SevaOne', 'ಸೇವಾಒನ್‌ಗೆ ಸೈನ್ ಇನ್ ಮಾಡಿ'),
            style: context.tt.headlineMedium),
        const SizedBox(height: 8),
        Text(
          context.tr('One account for every state service.', 'ಎಲ್ಲಾ ರಾಜ್ಯ ಸೇವೆಗಳಿಗೆ ಒಂದೇ ಖಾತೆ.'),
          style: TextStyle(color: context.cs.onSurfaceVariant),
        ),
        const SizedBox(height: 26),
        TextField(
          controller: mobile,
          keyboardType: TextInputType.phone,
          enabled: !otpSent,
          decoration: InputDecoration(
            labelText: context.tr('Mobile number', 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ'),
            prefixText: '+91  ',
          ),
        ),
        if (otpSent) ...[
          const SizedBox(height: 14),
          TextField(
            controller: otp,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: context.tr('OTP', 'ಒಟಿಪಿ')),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Pill(context.tr('Demo OTP filled in for you', 'ಡೆಮೊ ಒಟಿಪಿ ಭರ್ತಿ ಮಾಡಲಾಗಿದೆ'),
                color: const Color(0xFF8A5F00), icon: Icons.info_outline),
          ),
        ],
        const SizedBox(height: 22),
        FilledButton(
          onPressed: busy ? null : (otpSent ? verify : sendOtp),
          child: busy
              ? const SizedBox(
                  width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4))
              : Text(otpSent
                  ? context.tr('Verify and sign in', 'ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಸೈನ್ ಇನ್ ಮಾಡಿ')
                  : context.tr('Send OTP', 'ಒಟಿಪಿ ಕಳುಹಿಸಿ')),
        ),
        if (app.biometric) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: busy ? null : verify,
            icon: const Icon(Icons.fingerprint),
            label: Text(context.tr('Use fingerprint or Face ID', 'ಬೆರಳಚ್ಚು ಅಥವಾ ಮುಖ ಗುರುತು ಬಳಸಿ')),
          ),
        ],
        const SizedBox(height: 26),
        Text(
          context.tr(
              'This is a demonstration app. No real login, payment or government record is involved.',
              'ಇದು ಪ್ರದರ್ಶನ ಆ್ಯಪ್. ಯಾವುದೇ ನೈಜ ಲಾಗಿನ್, ಪಾವತಿ ಅಥವಾ ಸರ್ಕಾರಿ ದಾಖಲೆ ಒಳಗೊಂಡಿಲ್ಲ.'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant),
        ),
      ]),
    );
  }
}
