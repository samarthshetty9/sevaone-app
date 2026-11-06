import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../router.dart';
import '../widgets/common.dart';
import 'bills.dart';
import 'locker.dart';
import 'support.dart';
import 'track.dart';

/// Features 2 + 15: details prefill, documents auto-fetch from DigiLocker,
/// Aadhaar e-KYC and e-Sign, then payment.
class ApplyFlow extends StatefulWidget {
  final Service v;
  const ApplyFlow(this.v, {super.key});

  @override
  State<ApplyFlow> createState() => _ApplyFlowState();
}

class _ApplyFlowState extends State<ApplyFlow> {
  int step = 0;
  bool fetching = false;
  bool fetched = false;
  bool signing = false;
  bool signed = false;
  Application? done;

  List<String> get titles => [
        tx('Your details', 'ನಿಮ್ಮ ವಿವರಗಳು'),
        tx('Documents', 'ದಾಖಲೆಗಳು'),
        tx('Sign', 'ಸಹಿ'),
        tx('Review', 'ಪರಿಶೀಲನೆ'),
      ];

  void next() => setState(() => step++);

  Future<void> submit() async {
    final v = widget.v;
    if (v.fee > 0) {
      final ok = await push<bool>(
          context,
          PaymentScreen(
            title: context.loc(v.name),
            amount: v.fee,
            onPaid: () {},
          ));
      if (ok != true || !mounted) return;
    }
    setState(() => done = app.submitApplication(v));
  }

  @override
  Widget build(BuildContext context) {
    if (done != null) return _Submitted(done!);
    final s = context.watchApp;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc(widget.v.name)),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
          child: Semantics(
            label: context.tr('Step ${step + 1} of 4, ${titles[step]}',
                'ಹಂತ ${step + 1} / 4, ${titles[step]}'),
            excludeSemantics: true,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${step + 1}/4 · ${titles[step]}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(value: (step + 1) / 4, minHeight: 6),
              ),
            ]),
          ),
        ),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(16), children: switch (step) {
            0 => _details(context),
            1 => _documents(context, s),
            2 => _sign(context),
            _ => _review(context),
          }),
        ),
      ]),
      bottomNavigationBar: BottomAction(child: _cta(context)),
    );
  }

  Widget _cta(BuildContext context) {
    return switch (step) {
      0 => FilledButton(onPressed: next, child: Text(context.tr('Continue', 'ಮುಂದುವರಿಸಿ'))),
      1 => FilledButton(
          onPressed: fetched ? next : null, child: Text(context.tr('Continue', 'ಮುಂದುವರಿಸಿ'))),
      2 => FilledButton(
          onPressed: signed ? next : null, child: Text(context.tr('Continue', 'ಮುಂದುವರಿಸಿ'))),
      _ => FilledButton(
          onPressed: submit,
          child: Text(widget.v.fee > 0
              ? context.tr('Pay ${money(widget.v.fee)} and submit', '${money(widget.v.fee)} ಪಾವತಿಸಿ ಸಲ್ಲಿಸಿ')
              : context.tr('Submit application', 'ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'))),
    };
  }

  List<Widget> _details(BuildContext context) {
    Widget row(String k, String v) => ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(k, style: TextStyle(color: context.cs.onSurfaceVariant)),
          subtitle: Text(v,
              style: TextStyle(
                  fontSize: 15.5, color: context.cs.onSurface, fontWeight: FontWeight.w600)),
        );
    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Pill(context.tr('Prefilled from your profile', 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್‌ನಿಂದ ಭರ್ತಿಯಾಗಿದೆ'),
            color: context.cs.secondary, icon: Icons.auto_awesome),
      ),
      const SizedBox(height: 8),
      row(context.tr('Name', 'ಹೆಸರು'), context.loc(citizenName)),
      row(context.tr('Mobile', 'ಮೊಬೈಲ್'), citizenMobile),
      row(context.tr('District', 'ಜಿಲ್ಲೆ'), context.loc(citizenDistrict)),
      row(context.tr('Taluk', 'ತಾಲೂಕು'), context.tr('Bengaluru North', 'ಬೆಂಗಳೂರು ಉತ್ತರ')),
      row(context.tr('Address', 'ವಿಳಾಸ'),
          context.tr('12, 3rd Main, Malleshwaram', '12, 3ನೇ ಮುಖ್ಯ ರಸ್ತೆ, ಮಲ್ಲೇಶ್ವರಂ')),
    ];
  }

  List<Widget> _documents(BuildContext context, AppState s) {
    final docs = widget.v.docs.map(docById).toList();
    return [
      Text(context.tr('No uploads needed', 'ಅಪ್‌ಲೋಡ್ ಅಗತ್ಯವಿಲ್ಲ'), style: context.tt.titleLarge),
      const SizedBox(height: 4),
      Text(
        context.tr('SevaOne pulls these straight from the issuing department.',
            'ಸೇವಾಒನ್ ಇವುಗಳನ್ನು ನೇರವಾಗಿ ನೀಡುವ ಇಲಾಖೆಯಿಂದ ಪಡೆಯುತ್ತದೆ.'),
        style: TextStyle(color: context.cs.onSurfaceVariant),
      ),
      const SizedBox(height: 12),
      if (!s.digilockerLinked)
        SevaCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('Link DigiLocker to continue', 'ಮುಂದುವರಿಯಲು ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್ ಮಾಡಿ'),
                style: context.tt.titleMedium),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () => push(context, const DigilockerLinkScreen()),
              child: Text(context.tr('Link DigiLocker', 'ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್ ಮಾಡಿ')),
            ),
          ]),
        )
      else if (!fetching && !fetched)
        FilledButton.icon(
          onPressed: () => setState(() => fetching = true),
          icon: const Icon(Icons.cloud_download_outlined),
          label: Text(context.tr('Fetch ${docs.length} documents', '${docs.length} ದಾಖಲೆಗಳನ್ನು ಪಡೆಯಿರಿ')),
        )
      else if (fetching)
        SevaCard(
          child: SimSteps(
            steps: [
              for (final d in docs) context.tr('Fetching ${d.name.en}', '${d.name.kn} ಪಡೆಯಲಾಗುತ್ತಿದೆ'),
            ],
            stepTime: const Duration(milliseconds: 650),
            onDone: () => setState(() {
              fetching = false;
              fetched = true;
            }),
          ),
        )
      else
        for (final d in docs)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              child: Row(children: [
                IconBadge(d.icon, color: context.cs.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(context.loc(d.name), style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(context.loc(d.issuer),
                        style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                  ]),
                ),
                Icon(Icons.verified, color: context.cs.secondary),
              ]),
            ),
          ),
    ];
  }

  List<Widget> _sign(BuildContext context) {
    return [
      Text(context.tr('Aadhaar e-Sign', 'ಆಧಾರ್ ಇ-ಸೈನ್'), style: context.tt.titleLarge),
      const SizedBox(height: 4),
      Text(
        context.tr('Confirm your identity once. Your signature is added to the application.',
            'ನಿಮ್ಮ ಗುರುತನ್ನು ಒಮ್ಮೆ ದೃಢೀಕರಿಸಿ. ನಿಮ್ಮ ಸಹಿಯನ್ನು ಅರ್ಜಿಗೆ ಸೇರಿಸಲಾಗುತ್ತದೆ.'),
        style: TextStyle(color: context.cs.onSurfaceVariant),
      ),
      const SizedBox(height: 14),
      if (signed)
        SevaCard(
          child: Row(children: [
            Icon(Icons.draw_outlined, color: context.cs.secondary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                  context.tr('Signed by ${citizenName.en} (Aadhaar ending 4821)',
                      '${citizenName.kn} ಸಹಿ ಮಾಡಿದ್ದಾರೆ (ಆಧಾರ್ ಕೊನೆಯ ಅಂಕೆ 4821)'),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ]),
        )
      else if (signing)
        SevaCard(
          child: SimSteps(
            steps: [
              context.tr('Sending OTP to Aadhaar mobile', 'ಆಧಾರ್ ಮೊಬೈಲ್‌ಗೆ ಒಟಿಪಿ ಕಳುಹಿಸಲಾಗುತ್ತಿದೆ'),
              context.tr('Aadhaar e-KYC check', 'ಆಧಾರ್ ಇ-ಕೆವೈಸಿ ಪರಿಶೀಲನೆ'),
              context.tr('Applying e-Sign', 'ಇ-ಸೈನ್ ಅನ್ವಯಿಸಲಾಗುತ್ತಿದೆ'),
            ],
            onDone: () => setState(() {
              signing = false;
              signed = true;
            }),
          ),
        )
      else
        FilledButton.icon(
          onPressed: () => setState(() => signing = true),
          icon: const Icon(Icons.draw_outlined),
          label: Text(context.tr('Sign with Aadhaar', 'ಆಧಾರ್ ಮೂಲಕ ಸಹಿ ಮಾಡಿ')),
        ),
    ];
  }

  List<Widget> _review(BuildContext context) {
    final v = widget.v;
    Widget row(String k, String val) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Expanded(child: Text(k, style: TextStyle(color: context.cs.onSurfaceVariant))),
            Flexible(
              child: Text(val,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ]),
        );
    return [
      Text(context.tr('Check and submit', 'ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಸಲ್ಲಿಸಿ'), style: context.tt.titleLarge),
      const SizedBox(height: 10),
      SevaCard(
        child: Column(children: [
          row(context.tr('Service', 'ಸೇವೆ'), context.loc(v.name)),
          row(context.tr('Department', 'ಇಲಾಖೆ'), context.loc(v.dept)),
          row(context.tr('Documents', 'ದಾಖಲೆಗಳು'), '${v.docs.length}'),
          row(context.tr('Signed', 'ಸಹಿ'), context.tr('Aadhaar e-Sign', 'ಆಧಾರ್ ಇ-ಸೈನ್')),
          row(context.tr('Sakala deadline', 'ಸಕಾಲ ಗಡುವು'),
              dateStr(DateTime.now().add(Duration(days: v.sakalaDays)))),
          const Divider(height: 18),
          row(context.tr('Fee', 'ಶುಲ್ಕ'), v.fee == 0 ? context.tr('Free', 'ಉಚಿತ') : money(v.fee)),
        ]),
      ),
    ];
  }
}

class _Submitted extends StatelessWidget {
  final Application a;
  const _Submitted(this.a);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const SizedBox(height: 40),
          const Center(child: SuccessTick()),
          const SizedBox(height: 18),
          Text(context.tr('Application submitted', 'ಅರ್ಜಿ ಸಲ್ಲಿಸಲಾಗಿದೆ'),
              textAlign: TextAlign.center, style: context.tt.headlineSmall),
          const SizedBox(height: 6),
          Text(context.loc(a.service),
              textAlign: TextAlign.center, style: TextStyle(color: context.cs.onSurfaceVariant)),
          const SizedBox(height: 18),
          SevaCard(
            child: Column(children: [
              Text(context.tr('Application number', 'ಅರ್ಜಿ ಸಂಖ್ಯೆ'),
                  style: TextStyle(color: context.cs.onSurfaceVariant)),
              const SizedBox(height: 4),
              SelectableText(a.id, style: context.tt.titleMedium),
            ]),
          ),
          const SizedBox(height: 10),
          Text(
            context.tr('Watch for a notification: this demo moves your application forward on its own.',
                'ಅಧಿಸೂಚನೆಗಾಗಿ ನೋಡಿ: ಈ ಡೆಮೊ ನಿಮ್ಮ ಅರ್ಜಿಯನ್ನು ತಾನಾಗಿ ಮುಂದುವರಿಸುತ್ತದೆ.'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () {
              Navigator.of(context).popUntil((r) => r.isFirst);
              push(navigatorKey.currentContext!, ApplicationDetail(a));
            },
            child: Text(context.tr('Track this application', 'ಈ ಅರ್ಜಿಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ')),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => push(context, FeedbackScreen(subject: context.loc(a.service))),
            child: Text(context.tr('Rate this experience', 'ಈ ಅನುಭವವನ್ನು ರೇಟ್ ಮಾಡಿ')),
          ),
          TextButton(
            onPressed: () => openRoute('home'),
            child: Text(context.tr('Back to home', 'ಮುಖಪುಟಕ್ಕೆ ಹಿಂತಿರುಗಿ')),
          ),
        ]),
      ),
    );
  }
}
