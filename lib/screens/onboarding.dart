import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../widgets/art.dart';
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
        child: Stack(children: [
          const Positioned(
              left: 0, right: 0, top: 170, height: 230, child: Skyline(height: 230)),
          SafeArea(
            child: LayoutBuilder(builder: (context, box) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: box.maxHeight - 44),
                  child: IntrinsicHeight(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(24)),
                          child: Image.asset('assets/images/sevasindhu-logo.png',
                              width: 86, height: 86, semanticLabel: 'SevaOne'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(context.tr('Government of Karnataka', 'ಕರ್ನಾಟಕ ಸರ್ಕಾರ'),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                      const Spacer(),
                      const SizedBox(height: 120),
                      Text('SevaOne',
                          style: context.tt.headlineMedium?.copyWith(color: Colors.white, fontSize: 38)),
                      const SizedBox(height: 6),
                      Text(
                        context.tr('One Government, One Digital Platform',
                            'ಒಂದು ಸರ್ಕಾರ, ಒಂದು ಡಿಜಿಟಲ್ ವೇದಿಕೆ'),
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      const SizedBox(height: 24),
                      Text(context.tr('Choose your language', 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ'),
                          style: const TextStyle(color: Colors.white)),
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
              );
            }),
          ),
        ]),
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
  final mobile = TextEditingController();
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
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: [
        Stack(children: [
          Positioned.fill(
            bottom: 34,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                gradient: Seva.headerGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: const Skyline(height: 150),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 8, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: context.tr('Change language', 'ಭಾಷೆ ಬದಲಿಸಿ'),
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => app.set(() => app.onboarded = false),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(6),
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Image.asset('assets/images/sevasindhu-logo.png',
                    width: 52, height: 52, semanticLabel: 'SevaOne'),
              ),
              const SizedBox(height: 14),
              Text(context.tr('Welcome to SevaOne', 'ಸೇವಾಒನ್‌ಗೆ ಸ್ವಾಗತ'),
                  style: context.tt.headlineMedium?.copyWith(color: Colors.white)),
              const SizedBox(height: 4),
              Text(
                context.tr('One account for every government service in Karnataka.',
                    'ಕರ್ನಾಟಕದ ಎಲ್ಲಾ ಸರ್ಕಾರಿ ಸೇವೆಗಳಿಗೆ ಒಂದೇ ಖಾತೆ.'),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 22),
              SevaCard(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(context.tr('Sign in', 'ಸೈನ್ ಇನ್'), style: context.tt.titleLarge),
                  const SizedBox(height: 12),
                  TextField(
                    controller: mobile,
                    keyboardType: TextInputType.phone,
                    enabled: !otpSent,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.cs.surface,
                      labelText: context.tr('Mobile number', 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ'),
                      prefixText: '+91  ',
                    ),
                  ),
                  if (otpSent) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: otp,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.cs.surface,
                        labelText: context.tr('OTP', 'ಒಟಿಪಿ'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Pill(context.tr('OTP read from SMS', 'ಎಸ್‌ಎಂಎಸ್‌ನಿಂದ ಒಟಿಪಿ ಓದಲಾಗಿದೆ'),
                          color: context.cs.secondary, icon: Icons.check_circle_outline),
                    ),
                  ],
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: busy || mobile.text.trim().length < 10
                        ? null
                        : (otpSent ? verify : sendOtp),
                    child: busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.4))
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
                ]),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('What you can do', 'ನೀವು ಏನು ಮಾಡಬಹುದು'),
                style: context.tt.titleLarge?.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            for (final (i, t, b) in [
              (Icons.workspace_premium, context.tr('Apply for certificates', 'ಪ್ರಮಾಣಪತ್ರಗಳಿಗೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'),
                  context.tr('Income, caste, residence and more', 'ಆದಾಯ, ಜಾತಿ, ವಾಸಸ್ಥಳ ಮತ್ತು ಇನ್ನಷ್ಟು')),
              (Icons.volunteer_activism, context.tr('Find your schemes', 'ನಿಮ್ಮ ಯೋಜನೆಗಳನ್ನು ಹುಡುಕಿ'),
                  context.tr('See every benefit you qualify for', 'ನಿಮಗೆ ಅರ್ಹವಾದ ಎಲ್ಲಾ ಸೌಲಭ್ಯಗಳನ್ನು ನೋಡಿ')),
              (Icons.receipt_long, context.tr('Pay your bills', 'ನಿಮ್ಮ ಬಿಲ್‌ಗಳನ್ನು ಪಾವತಿಸಿ'),
                  context.tr('Electricity, water and property tax', 'ವಿದ್ಯುತ್, ನೀರು ಮತ್ತು ಆಸ್ತಿ ತೆರಿಗೆ')),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  IconBadge(i, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(b, style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                    ]),
                  ),
                ]),
              ),
          ]),
        ),
      ]),
    );
  }
}
