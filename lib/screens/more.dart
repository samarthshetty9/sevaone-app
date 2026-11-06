import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../widgets/common.dart';
import 'locker.dart';
import 'services.dart';
import 'support.dart';

/// Feature set observed in the UMANG app, built for SevaOne and simulated.
class DigipinScreen extends StatefulWidget {
  const DigipinScreen({super.key});

  @override
  State<DigipinScreen> createState() => _DigipinScreenState();
}

class _DigipinScreenState extends State<DigipinScreen> {
  bool located = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIGIPIN'),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(
          context.tr('A short digital address for your exact location.',
              'ನಿಮ್ಮ ನಿಖರ ಸ್ಥಳಕ್ಕೆ ಒಂದು ಸಣ್ಣ ಡಿಜಿಟಲ್ ವಿಳಾಸ.'),
          style: TextStyle(color: context.cs.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        if (!located)
          SevaCard(
            child: SimSteps(
              steps: [
                context.tr('Finding your location', 'ನಿಮ್ಮ ಸ್ಥಳ ಹುಡುಕಲಾಗುತ್ತಿದೆ'),
                context.tr('Working out your code', 'ನಿಮ್ಮ ಕೋಡ್ ಸಿದ್ಧಪಡಿಸಲಾಗುತ್ತಿದೆ'),
              ],
              onDone: () => setState(() => located = true),
            ),
          )
        else
          SevaCard(
            child: Column(children: [
              Text(context.tr('Your DIGIPIN', 'ನಿಮ್ಮ ಡಿಜಿಪಿನ್'),
                  style: TextStyle(color: context.cs.onSurfaceVariant)),
              const SizedBox(height: 6),
              SelectableText('4T3-M8K-P2L2', style: context.tt.headlineMedium),
              const SizedBox(height: 4),
              Text(context.tr('Malleshwaram, Bengaluru', 'ಮಲ್ಲೇಶ್ವರಂ, ಬೆಂಗಳೂರು')),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => toast(tx('DIGIPIN copied (demo)', 'ಡಿಜಿಪಿನ್ ನಕಲಿಸಲಾಗಿದೆ (ಡೆಮೊ)')),
                icon: const Icon(Icons.copy),
                label: Text(context.tr('Copy', 'ನಕಲಿಸಿ')),
              ),
            ]),
          ),
      ]),
    );
  }
}

Widget _callRow(BuildContext context, IconData icon, String name, String number, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: SevaCard(
      semanticLabel: tx('$name, call $number', '$name, $number ಗೆ ಕರೆ'),
      onTap: () => toast(tx('Calling $number (demo, no call is placed)',
          '$number ಗೆ ಕರೆ (ಡೆಮೊ, ಕರೆ ಹೋಗುವುದಿಲ್ಲ)')),
      child: Row(children: [
        IconBadge(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(number, style: context.tt.titleMedium),
          ]),
        ),
        const SizedBox(width: 8),
        Icon(Icons.call_outlined, color: context.cs.primary),
      ]),
    ),
  );
}

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Emergency', 'ತುರ್ತು')),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _callRow(context, Icons.emergency_outlined, context.tr('All emergencies', 'ಎಲ್ಲಾ ತುರ್ತು'), '112', Seva.red),
        _callRow(context, Icons.local_hospital_outlined, context.tr('Ambulance', 'ಆಂಬ್ಯುಲೆನ್ಸ್'), '108', Seva.red),
        _callRow(context, Icons.local_fire_department_outlined, context.tr('Fire', 'ಅಗ್ನಿಶಾಮಕ'), '101', Seva.saffron),
        _callRow(context, Icons.woman_outlined, context.tr('Women helpline', 'ಮಹಿಳಾ ಸಹಾಯವಾಣಿ'), '181', Seva.blue),
        _callRow(context, Icons.child_care_outlined, context.tr('Child helpline', 'ಮಕ್ಕಳ ಸಹಾಯವಾಣಿ'), '1098', Seva.blue),
        const SizedBox(height: 10),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: Seva.red, foregroundColor: Colors.white),
          onPressed: () => toast(tx('Location shared with family (demo)',
              'ಕುಟುಂಬದೊಂದಿಗೆ ಸ್ಥಳ ಹಂಚಲಾಗಿದೆ (ಡೆಮೊ)')),
          icon: const Icon(Icons.share_location),
          label: Text(context.tr('Share my location', 'ನನ್ನ ಸ್ಥಳ ಹಂಚಿಕೊಳ್ಳಿ')),
        ),
      ]),
    );
  }
}

class HelplinesScreen extends StatelessWidget {
  const HelplinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.cs.primary;
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Helpline numbers', 'ಸಹಾಯವಾಣಿ ಸಂಖ್ಯೆಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _callRow(context, Icons.support_agent_outlined, context.tr('SevaOne', 'ಸೇವಾಒನ್'), '1902', c),
        _callRow(context, Icons.agriculture_outlined, context.tr('Farmers', 'ರೈತರು'), '1800-180-1551', c),
        _callRow(context, Icons.elderly_outlined, context.tr('Senior citizens', 'ಹಿರಿಯ ನಾಗರಿಕರು'), '14567', c),
        _callRow(context, Icons.family_restroom_outlined, context.tr('Women and child', 'ಮಹಿಳೆ ಮತ್ತು ಮಕ್ಕಳು'), '181', c),
        _callRow(context, Icons.local_hospital_outlined, context.tr('Health', 'ಆರೋಗ್ಯ'), '104', c),
        _callRow(context, Icons.local_police_outlined, context.tr('Police', 'ಪೊಲೀಸ್'), '112', c),
        _callRow(context, Icons.train_outlined, context.tr('Railways', 'ರೈಲ್ವೆ'), '139', c),
        _callRow(context, Icons.security_outlined, context.tr('Cyber crime', 'ಸೈಬರ್ ಅಪರಾಧ'), '1930', c),
      ]),
    );
  }
}

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = [
      (context.tr('Village Accountant', 'ಗ್ರಾಮ ಲೆಕ್ಕಿಗ'), context.tr('Revenue Department', 'ಕಂದಾಯ ಇಲಾಖೆ'), 42),
      (context.tr('Junior Engineer', 'ಕಿರಿಯ ಇಂಜಿನಿಯರ್'), 'BESCOM', 18),
      (context.tr('Staff Nurse', 'ಸ್ಟಾಫ್ ನರ್ಸ್'), context.tr('Health Department', 'ಆರೋಗ್ಯ ಇಲಾಖೆ'), 9),
      (context.tr('Bus Conductor', 'ಬಸ್ ನಿರ್ವಾಹಕ'), 'BMTC', 27),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Job openings', 'ಉದ್ಯೋಗಾವಕಾಶಗಳು')),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(context.tr('Sample listings for this demo.', 'ಈ ಡೆಮೊಗಾಗಿ ಮಾದರಿ ಪಟ್ಟಿಗಳು.'),
            style: TextStyle(color: context.cs.onSurfaceVariant)),
        const SizedBox(height: 10),
        for (final (t, d, days) in jobs)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              onTap: () => toast(tx('Saved to your jobs (demo)', 'ನಿಮ್ಮ ಉದ್ಯೋಗಗಳಿಗೆ ಉಳಿಸಲಾಗಿದೆ (ಡೆಮೊ)')),
              child: Row(children: [
                const IconBadge(Icons.work_outline),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(d, style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                  ]),
                ),
                Text(context.tr('$days days left', '$days ದಿನ ಬಾಕಿ'),
                    style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
              ]),
            ),
          ),
      ]),
    );
  }
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Transaction history', 'ವಹಿವಾಟು ಇತಿಹಾಸ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        for (final t in s.transactions)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              child: Row(children: [
                const IconBadge(Icons.receipt_long_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(context.loc(t.title), style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('${dateStr(t.at)} · ${t.ref}',
                        style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
                  ]),
                ),
                Text(money(t.amount), style: context.tt.titleMedium),
              ]),
            ),
          ),
      ]),
    );
  }
}

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final c = TextEditingController();
  String relation = 'Child';

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final rel = {
      'Spouse': context.tr('Spouse', 'ಸಂಗಾತಿ'),
      'Child': context.tr('Child', 'ಮಗು'),
      'Parent': context.tr('Parent', 'ಪೋಷಕರು'),
    };
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Family profiles', 'ಕುಟುಂಬದ ಪ್ರೊಫೈಲ್‌ಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(
          context.tr('Apply for services on behalf of your family.',
              'ನಿಮ್ಮ ಕುಟುಂಬದ ಪರವಾಗಿ ಸೇವೆಗಳಿಗೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ.'),
          style: TextStyle(color: context.cs.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        for (final m in s.family)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const IconBadge(Icons.person_outline, size: 38),
            title: Text(m.name),
            subtitle: Text(rel[m.relation]!),
          ),
        TextField(
          controller: c,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: context.tr('Family member name', 'ಕುಟುಂಬದ ಸದಸ್ಯರ ಹೆಸರು')),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: [
          for (final e in rel.entries)
            ChoiceChip(
              label: Text(e.value),
              selected: relation == e.key,
              onSelected: (_) => setState(() => relation = e.key),
            ),
        ]),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: c.text.trim().isEmpty
              ? null
              : () {
                  app.set(() => app.family.add(FamilyMember(c.text.trim(), relation)));
                  c.clear();
                  setState(() {});
                },
          child: Text(context.tr('Add member', 'ಸದಸ್ಯರನ್ನು ಸೇರಿಸಿ')),
        ),
      ]),
    );
  }
}

class MyQrScreen extends StatelessWidget {
  const MyQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('My QR code', 'ನನ್ನ ಕ್ಯೂಆರ್ ಕೋಡ್')),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const QrPlaceholder(seed: 'ananya-demo', size: 220),
          ),
        ),
        const SizedBox(height: 16),
        Text(context.loc(citizenName), textAlign: TextAlign.center, style: context.tt.titleLarge),
        const SizedBox(height: 4),
        Text(
          context.tr('Show this at a GramaOne or Karnataka One counter to skip the form.',
              'ಫಾರ್ಮ್ ಇಲ್ಲದೆ ಸೇವೆ ಪಡೆಯಲು ಇದನ್ನು ಗ್ರಾಮ ಒನ್ ಅಥವಾ ಕರ್ನಾಟಕ ಒನ್ ಕೌಂಟರ್‌ನಲ್ಲಿ ತೋರಿಸಿ.'),
          textAlign: TextAlign.center,
          style: TextStyle(color: context.cs.onSurfaceVariant),
        ),
      ]),
    );
  }
}

/// Simulated sign language chatbot: picks a phrase and "signs" a reply with a
/// looping hand animation. A real one needs recorded ISL video.
class IslScreen extends StatefulWidget {
  const IslScreen({super.key});

  @override
  State<IslScreen> createState() => _IslScreenState();
}

class _IslScreenState extends State<IslScreen> with SingleTickerProviderStateMixin {
  late final AnimationController a =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  L? shown;

  void play(L reply) {
    setState(() => shown = reply);
    if (!app.reduceMotion) {
      a
        ..reset()
        ..repeat(reverse: true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) a.stop();
      });
    }
  }

  @override
  void dispose() {
    a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <(L, L)>[
      (const L('Track my application', 'ನನ್ನ ಅರ್ಜಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ'),
          const L('Open the Track tab and choose your application.', 'ಟ್ರ್ಯಾಕ್ ವಿಭಾಗ ತೆರೆದು ಅರ್ಜಿ ಆಯ್ಕೆಮಾಡಿ.')),
      (const L('Find a scheme', 'ಯೋಜನೆ ಹುಡುಕಿ'),
          const L('Answer six questions in Scheme finder.', 'ಯೋಜನೆ ಶೋಧಕದಲ್ಲಿ ಆರು ಪ್ರಶ್ನೆಗಳಿಗೆ ಉತ್ತರಿಸಿ.')),
      (const L('Talk to an agent', 'ಸಹಾಯಕರ ಜೊತೆ ಮಾತನಾಡಿ'),
          const L('A sign language agent will join by video.', 'ಸಂಕೇತ ಭಾಷೆ ಸಹಾಯಕರು ವೀಡಿಯೊ ಮೂಲಕ ಸೇರುತ್ತಾರೆ.')),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Sign language chatbot', 'ಸಂಕೇತ ಭಾಷೆ ಚಾಟ್‌ಬಾಟ್')),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
              gradient: Seva.headerGradient, borderRadius: BorderRadius.circular(18)),
          child: Center(
            child: AnimatedBuilder(
              animation: a,
              builder: (_, c) => Transform.rotate(angle: (a.value - 0.5) * 0.5, child: c),
              child: const Icon(Icons.sign_language, color: Colors.white, size: 96),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SevaCard(
          child: Semantics(
            liveRegion: true,
            child: Text(
              shown == null
                  ? context.tr('Choose what you need. The answer is signed and captioned.',
                      'ನಿಮಗೆ ಬೇಕಾದುದನ್ನು ಆಯ್ಕೆಮಾಡಿ. ಉತ್ತರ ಸಂಕೇತ ಮತ್ತು ಶೀರ್ಷಿಕೆಯೊಂದಿಗೆ ಬರುತ್ತದೆ.')
                  : context.loc(shown!),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (final (q, r) in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(onPressed: () => play(r), child: Text(context.loc(q))),
          ),
      ]),
    );
  }
}

class SignalScreen extends StatefulWidget {
  const SignalScreen({super.key});

  @override
  State<SignalScreen> createState() => _SignalScreenState();
}

class _SignalScreenState extends State<SignalScreen> {
  int run = 0;
  bool done = false;

  @override
  Widget build(BuildContext context) {
    Widget stat(String k, String v) => Expanded(
          child: Column(children: [
            Text(v, style: context.tt.titleLarge),
            Text(k, style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
          ]),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Mobile signal check', 'ಮೊಬೈಲ್ ಸಿಗ್ನಲ್ ಪರಿಶೀಲನೆ')),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (!done)
          SevaCard(
            child: SimSteps(
              key: ValueKey(run),
              steps: [
                context.tr('Checking signal strength', 'ಸಿಗ್ನಲ್ ಶಕ್ತಿ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ'),
                context.tr('Testing speed', 'ವೇಗ ಪರೀಕ್ಷಿಸಲಾಗುತ್ತಿದೆ'),
                context.tr('Measuring delay', 'ವಿಳಂಬ ಅಳೆಯಲಾಗುತ್ತಿದೆ'),
              ],
              onDone: () => setState(() => done = true),
            ),
          )
        else ...[
          SevaCard(
            child: Row(children: [
              stat(context.tr('Signal', 'ಸಿಗ್ನಲ್'), context.tr('Good', 'ಉತ್ತಮ')),
              stat(context.tr('Download', 'ಡೌನ್‌ಲೋಡ್'), '${18 + Random(run).nextInt(20)} Mbps'),
              stat(context.tr('Delay', 'ವಿಳಂಬ'), '${30 + Random(run).nextInt(40)} ms'),
            ]),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => setState(() {
              run++;
              done = false;
            }),
            child: Text(context.tr('Test again', 'ಮತ್ತೆ ಪರೀಕ್ಷಿಸಿ')),
          ),
          TextButton(
            onPressed: () => push(context, const FeedbackScreen(subject: 'Network coverage')),
            child: Text(context.tr('Report poor coverage', 'ಕಳಪೆ ಸಿಗ್ನಲ್ ವರದಿ ಮಾಡಿ')),
          ),
        ],
      ]),
    );
  }
}

/// A to Z of departments, built from the catalogue.
class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final all = [...services, ...schemes, ...s.catalogue];
    final byDept = <String, List<Service>>{};
    for (final v in all) {
      byDept.putIfAbsent(context.loc(v.dept), () => []).add(v);
    }
    final names = byDept.keys.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Service directory', 'ಸೇವಾ ಡೈರೆಕ್ಟರಿ'))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: names.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) => ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(names[i]),
          trailing: Text('${byDept[names[i]]!.length}'),
          onTap: () => push(context, ServiceListScreen(names[i], byDept[names[i]]!)),
        ),
      ),
    );
  }
}

class ServiceListScreen extends StatelessWidget {
  final String title;
  final List<Service> items;
  const ServiceListScreen(this.title, this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: items.isEmpty
          ? EmptyState(icon: Icons.inbox_outlined, title: context.tr('Nothing here yet', 'ಇಲ್ಲಿ ಇನ್ನೂ ಏನೂ ಇಲ್ಲ'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (_, i) => ServiceRow(items[i]),
            ),
    );
  }
}

/// Simulated authenticator with a code that changes every 30 seconds.
class TotpScreen extends StatefulWidget {
  const TotpScreen({super.key});

  @override
  State<TotpScreen> createState() => _TotpScreenState();
}

class _TotpScreenState extends State<TotpScreen> {
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final left = 30 - now % 30;
    final code = (100000 + Random(now ~/ 30).nextInt(899999)).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Authenticator', 'ದೃಢೀಕರಣ ಕೋಡ್')),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        const SizedBox(height: 30),
        Text('${code.substring(0, 3)} ${code.substring(3)}',
            textAlign: TextAlign.center,
            style: context.tt.headlineMedium?.copyWith(fontSize: 44, letterSpacing: 2)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: left / 30, minHeight: 6),
        ),
        const SizedBox(height: 8),
        Text(context.tr('New code in $left seconds', '$left ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಹೊಸ ಕೋಡ್'),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.cs.onSurfaceVariant)),
      ]),
    );
  }
}
