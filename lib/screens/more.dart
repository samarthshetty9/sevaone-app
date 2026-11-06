import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';
import 'locker.dart';
import 'services.dart';
import 'support.dart';

Widget _section(BuildContext c, String t) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Semantics(
          header: true, child: Text(t, style: c.tt.titleLarge?.copyWith(fontSize: 18))),
    );

Widget _tipRow(BuildContext c, IconData i, String title, String body) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SevaCard(
        child: Row(children: [
          IconBadge(i, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(body, style: TextStyle(fontSize: 13, color: c.cs.onSurfaceVariant)),
            ]),
          ),
        ]),
      ),
    );

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
      appBar: const SevaBar(title: Text('DIGIPIN')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            height: 210,
            child: Stack(fit: StackFit.expand, children: [
              CustomPaint(painter: _GridMap(dark: context.cs.brightness == Brightness.dark)),
              const Center(child: Icon(Icons.location_on, color: Seva.red, size: 46)),
              Positioned(
                left: 12,
                bottom: 12,
                child: Pill(context.tr('Malleshwaram, Bengaluru', 'ಮಲ್ಲೇಶ್ವರಂ, ಬೆಂಗಳೂರು'),
                    color: Seva.blueDark, icon: Icons.my_location),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 12),
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
          GlowPanel(
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(context.tr('Your DIGIPIN', 'ನಿಮ್ಮ ಡಿಜಿಪಿನ್'),
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 2),
                  SelectableText('4T3-M8K-P2L2',
                      style: context.tt.headlineMedium?.copyWith(color: Colors.white, fontSize: 25)),
                ]),
              ),
              IconButton.filled(
                tooltip: context.tr('Copy', 'ನಕಲಿಸಿ'),
                style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Seva.blueDark),
                onPressed: () => toast(tx('DIGIPIN copied', 'ಡಿಜಿಪಿನ್ ನಕಲಿಸಲಾಗಿದೆ')),
                icon: const Icon(Icons.copy),
              ),
            ]),
          ),
        _section(context, context.tr('Use it for', 'ಇದನ್ನು ಇದಕ್ಕೆ ಬಳಸಿ')),
        _tipRow(context, Icons.local_shipping, context.tr('Deliveries', 'ವಿತರಣೆಗಳು'),
            context.tr('Reach homes without a clear street address', 'ಸ್ಪಷ್ಟ ವಿಳಾಸ ಇಲ್ಲದ ಮನೆಗಳನ್ನು ತಲುಪಿ')),
        _tipRow(context, Icons.emergency, context.tr('Emergencies', 'ತುರ್ತು ಸಂದರ್ಭಗಳು'),
            context.tr('Tell an ambulance exactly where you are', 'ಆಂಬ್ಯುಲೆನ್ಸ್‌ಗೆ ನಿಖರ ಸ್ಥಳ ತಿಳಿಸಿ')),
        _tipRow(context, Icons.description, context.tr('Applications', 'ಅರ್ಜಿಗಳು'),
            context.tr('Give an exact location on government forms', 'ಸರ್ಕಾರಿ ಅರ್ಜಿಗಳಲ್ಲಿ ನಿಖರ ಸ್ಥಳ ನೀಡಿ')),
      ]),
    );
  }
}

class _GridMap extends CustomPainter {
  final bool dark;
  _GridMap({required this.dark});

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = dark ? const Color(0xFF1B1D3A) : const Color(0xFFE9EFE6));
    final road = Paint()
      ..color = dark ? const Color(0xFF34375F) : Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, s.height * .7), Offset(s.width, s.height * .3), road);
    canvas.drawLine(Offset(s.width * .3, 0), Offset(s.width * .45, s.height), road);
    canvas.drawCircle(Offset(s.width * .82, s.height * .78), 42,
        Paint()..color = dark ? const Color(0xFF213B36) : const Color(0xFFCDE5C6));
    final grid = Paint()
      ..color = Seva.blue.withValues(alpha: .28)
      ..strokeWidth = 1;
    for (var x = 0.0; x < s.width; x += s.width / 8) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), grid);
    }
    for (var y = 0.0; y < s.height; y += s.height / 5) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), grid);
    }
    final cellW = s.width / 8;
    final cellH = s.height / 5;
    canvas.drawRect(Rect.fromLTWH(cellW * 4 - cellW, cellH * 2, cellW * 2, cellH),
        Paint()..color = Seva.blue.withValues(alpha: .2));
  }

  @override
  bool shouldRepaint(_GridMap o) => o.dark != dark;
}

class _Call {
  final IconData icon;
  final String name;
  final String number;
  final Color color;
  const _Call(this.icon, this.name, this.number, this.color);
}

Widget _callTile(BuildContext context, _Call c) {
  return SevaCard(
    semanticLabel: tx('${c.name}, call ${c.number}', '${c.name}, ${c.number} ಗೆ ಕರೆ'),
    padding: const EdgeInsets.all(12),
    onTap: () => dial(c.number),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        IconBadge(c.icon, color: c.color, size: 40),
        const Spacer(),
        Icon(Icons.call, color: context.cs.primary, size: 20),
      ]),
      const SizedBox(height: 10),
      Text(c.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
      Text(c.number,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
    ]),
  );
}

Widget _callGrid(List<Widget> items) => LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 10) / 2;
      return Wrap(spacing: 10, runSpacing: 10, children: [
        for (final i in items) SizedBox(width: w, child: i),
      ]);
    });

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Emergency', 'ತುರ್ತು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          colors: const [Color(0xFF9E1B2C), Color(0xFFD73240)],
          onTap: () => dial('112'),
          child: Row(children: [
            const IconArt(Icons.sos, size: 84),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('Call 112 now', 'ಈಗ 112ಗೆ ಕರೆ ಮಾಡಿ'),
                    style: context.tt.headlineSmall?.copyWith(color: Colors.white)),
                const SizedBox(height: 2),
                Text(context.tr('Police, fire and ambulance in one number',
                    'ಪೊಲೀಸ್, ಅಗ್ನಿಶಾಮಕ ಮತ್ತು ಆಂಬ್ಯುಲೆನ್ಸ್ ಒಂದೇ ಸಂಖ್ಯೆಯಲ್ಲಿ'),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
          ]),
        ),
        _section(context, context.tr('Direct numbers', 'ನೇರ ಸಂಖ್ಯೆಗಳು')),
        _callGrid([
          _callTile(context, _Call(Icons.local_hospital, context.tr('Ambulance', 'ಆಂಬ್ಯುಲೆನ್ಸ್'), '108', Seva.red)),
          _callTile(context, _Call(Icons.local_fire_department, context.tr('Fire', 'ಅಗ್ನಿಶಾಮಕ'), '101', Seva.saffron)),
          _callTile(context, _Call(Icons.woman, context.tr('Women', 'ಮಹಿಳೆಯರು'), '181', Seva.tones[3])),
          _callTile(context, _Call(Icons.child_care, context.tr('Children', 'ಮಕ್ಕಳು'), '1098', Seva.tones[5])),
        ]),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => toast(tx('Location shared with your family', 'ಕುಟುಂಬದೊಂದಿಗೆ ಸ್ಥಳ ಹಂಚಲಾಗಿದೆ')),
          icon: const Icon(Icons.share_location),
          label: Text(context.tr('Share my location with family', 'ಕುಟುಂಬದೊಂದಿಗೆ ನನ್ನ ಸ್ಥಳ ಹಂಚಿಕೊಳ್ಳಿ')),
        ),
      ]),
    );
  }
}

class HelplinesScreen extends StatelessWidget {
  const HelplinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Seva.tones;
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Helpline numbers', 'ಸಹಾಯವಾಣಿ ಸಂಖ್ಯೆಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          onTap: () => dial('1902'),
          child: Row(children: [
            const IconArt(Icons.support_agent, size: 74),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('SevaOne helpline', 'ಸೇವಾಒನ್ ಸಹಾಯವಾಣಿ'),
                    style: const TextStyle(color: Colors.white70)),
                Text('1902', style: context.tt.headlineMedium?.copyWith(color: Colors.white)),
                Text(context.tr('Kannada and English, 24x7', 'ಕನ್ನಡ ಮತ್ತು ಇಂಗ್ಲಿಷ್, 24x7'),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
          ]),
        ),
        _section(context, context.tr('Find the right help', 'ಸರಿಯಾದ ಸಹಾಯ ಹುಡುಕಿ')),
        _callGrid([
          _callTile(context, _Call(Icons.agriculture, context.tr('Farmers', 'ರೈತರು'), '1800-180-1551', t[7])),
          _callTile(context, _Call(Icons.elderly, context.tr('Senior citizens', 'ಹಿರಿಯ ನಾಗರಿಕರು'), '14567', t[4])),
          _callTile(context, _Call(Icons.family_restroom, context.tr('Women and child', 'ಮಹಿಳೆ ಮತ್ತು ಮಕ್ಕಳು'), '181', t[3])),
          _callTile(context, _Call(Icons.local_hospital, context.tr('Health', 'ಆರೋಗ್ಯ'), '104', t[1])),
          _callTile(context, _Call(Icons.local_police, context.tr('Police', 'ಪೊಲೀಸ್'), '112', t[0])),
          _callTile(context, _Call(Icons.train, context.tr('Railways', 'ರೈಲ್ವೆ'), '139', t[5])),
          _callTile(context, _Call(Icons.security, context.tr('Cyber crime', 'ಸೈಬರ್ ಅಪರಾಧ'), '1930', t[2])),
          _callTile(context, _Call(Icons.gavel, context.tr('Consumer', 'ಗ್ರಾಹಕ'), '1915', t[6])),
        ]),
      ]),
    );
  }
}

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String field = 'all';
  final saved = <String>{};

  @override
  Widget build(BuildContext context) {
    context.watchApp;
    final fields = {
      'all': context.tr('All', 'ಎಲ್ಲಾ'),
      'admin': context.tr('Administration', 'ಆಡಳಿತ'),
      'engineering': context.tr('Engineering', 'ಇಂಜಿನಿಯರಿಂಗ್'),
      'health': context.tr('Health', 'ಆರೋಗ್ಯ'),
      'education': context.tr('Education', 'ಶಿಕ್ಷಣ'),
      'transport': context.tr('Transport', 'ಸಾರಿಗೆ'),
    };
    final list = jobs.where((j) => field == 'all' || j.field == field).toList();
    final total = jobs.fold<int>(0, (a, j) => a + j.openings);
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Job openings', 'ಉದ್ಯೋಗಾವಕಾಶಗಳು'))),
      body: ListView(padding: const EdgeInsets.only(bottom: 20), children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: GlowPanel(
            colors: const [Color(0xFF0B5D5A), Color(0xFF0E9F8E)],
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(money(total).replaceAll('₹', ''),
                      style: context.tt.headlineMedium?.copyWith(color: Colors.white)),
                  Text(context.tr('open posts across ${jobs.length} recruitments',
                      '${jobs.length} ನೇಮಕಾತಿಗಳಲ್ಲಿ ಖಾಲಿ ಹುದ್ದೆಗಳು'),
                      style: const TextStyle(color: Colors.white)),
                ]),
              ),
              const IconArt(Icons.work, size: 70),
            ]),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final e in fields.entries)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(e.value),
                    selected: field == e.key,
                    onSelected: (_) => setState(() => field = e.key),
                  ),
                ),
            ],
          ),
        ),
        for (final j in list)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
            child: SevaCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const IconBadge(Icons.work_outline, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(context.loc(j.title), style: context.tt.titleMedium),
                      Text(context.loc(j.dept),
                          style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                    ]),
                  ),
                  IconButton(
                    tooltip: context.tr('Save job', 'ಉದ್ಯೋಗ ಉಳಿಸಿ'),
                    onPressed: () => setState(() {
                      saved.contains(j.title.en) ? saved.remove(j.title.en) : saved.add(j.title.en);
                    }),
                    icon: Icon(saved.contains(j.title.en) ? Icons.bookmark : Icons.bookmark_border,
                        color: context.cs.primary),
                  ),
                ]),
                const SizedBox(height: 10),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  Pill(context.loc(j.pay), color: context.cs.secondary, icon: Icons.payments_outlined),
                  Pill(context.loc(j.qualification), color: context.cs.primary, icon: Icons.school_outlined),
                  Pill(context.loc(j.place), color: Seva.tones[5], icon: Icons.place_outlined),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: Text(
                      context.tr('${j.openings} posts · ${j.daysLeft} days left',
                          '${j.openings} ಹುದ್ದೆಗಳು · ${j.daysLeft} ದಿನ ಬಾಕಿ'),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: j.daysLeft < 15 ? context.cs.error : context.cs.onSurfaceVariant),
                    ),
                  ),
                  TextButton(
                    onPressed: () => toast(tx('Application opened', 'ಅರ್ಜಿ ತೆರೆಯಲಾಗಿದೆ')),
                    child: Text(context.tr('Apply', 'ಅರ್ಜಿ ಸಲ್ಲಿಸಿ')),
                  ),
                ]),
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
    final total = s.transactions.fold<int>(0, (a, t) => a + t.amount);
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Transaction history', 'ವಹಿವಾಟು ಇತಿಹಾಸ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('Paid through SevaOne', 'ಸೇವಾಒನ್ ಮೂಲಕ ಪಾವತಿ'),
                    style: const TextStyle(color: Colors.white70)),
                Text(money(total), style: context.tt.headlineMedium?.copyWith(color: Colors.white)),
                Text(context.tr('${s.transactions.length} payments', '${s.transactions.length} ಪಾವತಿಗಳು'),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
            const IconArt(Icons.receipt_long, size: 74),
          ]),
        ),
        const SizedBox(height: 14),
        for (final t in s.transactions)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              onTap: () => toast(tx('Receipt ${t.ref} saved', 'ರಸೀದಿ ${t.ref} ಉಳಿಸಲಾಗಿದೆ')),
              child: Row(children: [
                const IconBadge(Icons.check, color: Seva.greenDark, size: 40),
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
      appBar: SevaBar(title: Text(context.tr('Family profiles', 'ಕುಟುಂಬದ ಪ್ರೊಫೈಲ್‌ಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          colors: const [Color(0xFF7A3FC4), Color(0xFFAE55C9)],
          child: Row(children: [
            const IconArt(Icons.family_restroom, size: 72),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                context.tr('Apply and track for your whole family from one account.',
                    'ಒಂದೇ ಖಾತೆಯಿಂದ ಇಡೀ ಕುಟುಂಬಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ ಮತ್ತು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ.'),
                style: context.tt.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
          ]),
        ),
        _section(context, context.tr('Members (${s.family.length + 1})', 'ಸದಸ್ಯರು (${s.family.length + 1})')),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SevaCard(
            child: Row(children: [
              const IconBadge(Icons.person, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Text(context.loc(citizenName), style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              Pill(context.tr('You', 'ನೀವು'), color: context.cs.primary),
            ]),
          ),
        ),
        for (final m in s.family)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              child: Row(children: [
                IconBadge(m.relation == 'Child' ? Icons.child_care : Icons.person_outline, size: 42),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(rel[m.relation]!,
                        style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                  ]),
                ),
              ]),
            ),
          ),
        _section(context, context.tr('Add a member', 'ಸದಸ್ಯರನ್ನು ಸೇರಿಸಿ')),
        TextField(
          controller: c,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: context.tr('Full name', 'ಪೂರ್ಣ ಹೆಸರು')),
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
      appBar: SevaBar(title: Text(context.tr('My QR code', 'ನನ್ನ ಕ್ಯೂಆರ್ ಕೋಡ್'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          padding: const EdgeInsets.all(22),
          child: Column(children: [
            Text(context.loc(citizenName),
                style: context.tt.headlineSmall?.copyWith(color: Colors.white)),
            Text('${context.loc(citizenDistrict)} · $citizenMobile',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: const QrPlaceholder(seed: 'sevaone-citizen', size: 210),
            ),
            const SizedBox(height: 14),
            Text(context.tr('SevaOne ID: KA29-4821-7790', 'ಸೇವಾಒನ್ ಐಡಿ: KA29-4821-7790'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ]),
        ),
        _section(context, context.tr('Skip the form at the counter', 'ಕೌಂಟರ್‌ನಲ್ಲಿ ಫಾರ್ಮ್ ತುಂಬಬೇಡಿ')),
        _tipRow(context, Icons.storefront, context.tr('Show at any centre', 'ಯಾವುದೇ ಕೇಂದ್ರದಲ್ಲಿ ತೋರಿಸಿ'),
            context.tr('GramaOne and Karnataka One staff scan it to open your details',
                'ಗ್ರಾಮ ಒನ್ ಮತ್ತು ಕರ್ನಾಟಕ ಒನ್ ಸಿಬ್ಬಂದಿ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ ನಿಮ್ಮ ವಿವರ ತೆರೆಯುತ್ತಾರೆ')),
        _tipRow(context, Icons.shield, context.tr('Stays private', 'ಖಾಸಗಿಯಾಗಿರುತ್ತದೆ'),
            context.tr('Nothing is shared until you approve it on your phone',
                'ನಿಮ್ಮ ಫೋನ್‌ನಲ್ಲಿ ಒಪ್ಪುವವರೆಗೆ ಏನೂ ಹಂಚಿಕೊಳ್ಳುವುದಿಲ್ಲ')),
      ]),
    );
  }
}

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
    final items = <(IconData, L, L)>[
      (Icons.timeline, const L('Track my application', 'ನನ್ನ ಅರ್ಜಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ'),
          const L('Open the Track tab and choose your application.', 'ಟ್ರ್ಯಾಕ್ ವಿಭಾಗ ತೆರೆದು ಅರ್ಜಿ ಆಯ್ಕೆಮಾಡಿ.')),
      (Icons.volunteer_activism, const L('Find a scheme', 'ಯೋಜನೆ ಹುಡುಕಿ'),
          const L('Answer six questions in Scheme finder.', 'ಯೋಜನೆ ಶೋಧಕದಲ್ಲಿ ಆರು ಪ್ರಶ್ನೆಗಳಿಗೆ ಉತ್ತರಿಸಿ.')),
      (Icons.receipt_long, const L('Pay a bill', 'ಬಿಲ್ ಪಾವತಿಸಿ'),
          const L('Open Bills, choose one and pay.', 'ಬಿಲ್‌ಗಳನ್ನು ತೆರೆದು, ಆಯ್ಕೆಮಾಡಿ ಪಾವತಿಸಿ.')),
      (Icons.workspace_premium, const L('Apply for a certificate', 'ಪ್ರಮಾಣಪತ್ರಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'),
          const L('Open Services and choose a certificate.', 'ಸೇವೆಗಳನ್ನು ತೆರೆದು ಪ್ರಮಾಣಪತ್ರ ಆಯ್ಕೆಮಾಡಿ.')),
      (Icons.location_on, const L('Find a centre', 'ಕೇಂದ್ರ ಹುಡುಕಿ'),
          const L('Open Centres to see the nearest one.', 'ಹತ್ತಿರದ ಕೇಂದ್ರ ನೋಡಲು ಕೇಂದ್ರಗಳನ್ನು ತೆರೆಯಿರಿ.')),
      (Icons.video_call, const L('Talk to an interpreter', 'ವ್ಯಾಖ್ಯಾನಕಾರರ ಜೊತೆ ಮಾತನಾಡಿ'),
          const L('A sign language interpreter will join by video.', 'ಸಂಕೇತ ಭಾಷೆ ವ್ಯಾಖ್ಯಾನಕಾರರು ವೀಡಿಯೊ ಮೂಲಕ ಸೇರುತ್ತಾರೆ.')),
    ];
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Sign language chatbot', 'ಸಂಕೇತ ಭಾಷೆ ಚಾಟ್‌ಬಾಟ್'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          padding: const EdgeInsets.all(22),
          ringsAt: Alignment.center,
          child: Column(children: [
            AnimatedBuilder(
              animation: a,
              builder: (_, c) => Transform.rotate(angle: (a.value - 0.5) * 0.5, child: c),
              child: const Icon(Icons.sign_language, color: Colors.white, size: 92),
            ),
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(
                shown == null
                    ? context.tr('Choose what you need. Answers are signed and captioned.',
                        'ನಿಮಗೆ ಬೇಕಾದುದನ್ನು ಆಯ್ಕೆಮಾಡಿ. ಉತ್ತರಗಳು ಸಂಕೇತ ಮತ್ತು ಶೀರ್ಷಿಕೆಯೊಂದಿಗೆ ಬರುತ್ತವೆ.')
                    : context.loc(shown!),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        for (final (i, q, r) in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              onTap: () => play(r),
              child: Row(children: [
                IconBadge(i, size: 40),
                const SizedBox(width: 12),
                Expanded(child: Text(context.loc(q), style: const TextStyle(fontWeight: FontWeight.w600))),
                const Icon(Icons.chevron_right),
              ]),
            ),
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
    final speed = 18 + Random(run).nextInt(20);
    final delay = 30 + Random(run).nextInt(40);
    Widget stat(IconData i, String k, String v) => Expanded(
          child: Column(children: [
            IconBadge(i, size: 36),
            const SizedBox(height: 6),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(k, style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
          ]),
        );
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Mobile signal check', 'ಮೊಬೈಲ್ ಸಿಗ್ನಲ್ ಪರಿಶೀಲನೆ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          ringsAt: Alignment.center,
          padding: const EdgeInsets.all(22),
          child: Center(
            child: done
                ? ArcGauge(
                    value: speed / 50,
                    big: '$speed',
                    small: 'Mbps',
                    size: 200,
                    textColor: Colors.white,
                  )
                : SizedBox(
                    height: 144,
                    child: Center(
                      child: _Measuring(key: ValueKey(run), onDone: () => setState(() => done = true)),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SevaCard(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            stat(Icons.signal_cellular_alt, context.tr('Signal', 'ಸಿಗ್ನಲ್'),
                done ? context.tr('Strong', 'ಬಲವಾಗಿದೆ') : '…'),
            stat(Icons.speed, context.tr('Delay', 'ವಿಳಂಬ'), done ? '$delay ms' : '…'),
            stat(Icons.five_g, context.tr('Network', 'ನೆಟ್‌ವರ್ಕ್'), done ? '4G' : '…'),
          ]),
        ),
        _section(context, context.tr('What this means', 'ಇದರ ಅರ್ಥ')),
        _tipRow(context, Icons.check_circle, context.tr('Good for all services', 'ಎಲ್ಲಾ ಸೇವೆಗಳಿಗೆ ಉತ್ತಮ'),
            context.tr('Uploads, payments and video all work well here',
                'ಅಪ್‌ಲೋಡ್, ಪಾವತಿ ಮತ್ತು ವೀಡಿಯೊ ಇಲ್ಲಿ ಚೆನ್ನಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತವೆ')),
        _tipRow(context, Icons.sms, context.tr('Weak signal?', 'ಸಿಗ್ನಲ್ ದುರ್ಬಲವೇ?'),
            context.tr('Use SMS services, which work without internet',
                'ಇಂಟರ್ನೆಟ್ ಇಲ್ಲದೆ ಕೆಲಸ ಮಾಡುವ ಎಸ್‌ಎಂಎಸ್ ಸೇವೆಗಳನ್ನು ಬಳಸಿ')),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: done
                  ? () => setState(() {
                        run++;
                        done = false;
                      })
                  : null,
              child: Text(context.tr('Test again', 'ಮತ್ತೆ ಪರೀಕ್ಷಿಸಿ')),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton(
              onPressed: () => push(context, const FeedbackScreen(subject: 'Network coverage')),
              child: Text(context.tr('Report coverage', 'ಸಿಗ್ನಲ್ ವರದಿ ಮಾಡಿ')),
            ),
          ),
        ]),
      ]),
    );
  }
}

class _Measuring extends StatefulWidget {
  final VoidCallback onDone;
  const _Measuring({super.key, required this.onDone});

  @override
  State<_Measuring> createState() => _MeasuringState();
}

class _MeasuringState extends State<_Measuring> {
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer(const Duration(seconds: 2), widget.onDone);
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
        const CircularProgressIndicator(color: Colors.white),
        const SizedBox(height: 12),
        Text(context.tr('Testing your connection', 'ನಿಮ್ಮ ಸಂಪರ್ಕ ಪರೀಕ್ಷಿಸಲಾಗುತ್ತಿದೆ'),
            style: const TextStyle(color: Colors.white)),
      ]);
}

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
      appBar: SevaBar(title: Text(context.tr('Service directory', 'ಸೇವಾ ಡೈರೆಕ್ಟರಿ'))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: names.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) => SevaCard(
          onTap: () => push(context, ServiceListScreen(names[i], byDept[names[i]]!)),
          child: Row(children: [
            IconBadge(Icons.account_balance, color: Seva.tones[i % Seva.tones.length], size: 40),
            const SizedBox(width: 12),
            Expanded(child: Text(names[i], style: const TextStyle(fontWeight: FontWeight.w600))),
            Text('${byDept[names[i]]!.length}',
                style: TextStyle(color: context.cs.primary, fontWeight: FontWeight.w700)),
          ]),
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
      appBar: SevaBar(title: Text(title)),
      body: items.isEmpty
          ? EmptyState(icon: Icons.inbox_outlined, title: context.tr('Nothing here yet', 'ಇಲ್ಲಿ ಇನ್ನೂ ಏನೂ ಇಲ್ಲ'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => ServiceRow(items[i]),
            ),
    );
  }
}

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
      appBar: SevaBar(title: Text(context.tr('Authenticator', 'ದೃಢೀಕರಣ ಕೋಡ್'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          padding: const EdgeInsets.all(22),
          child: Column(children: [
            Text(context.tr('Your SevaOne code', 'ನಿಮ್ಮ ಸೇವಾಒನ್ ಕೋಡ್'),
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text('${code.substring(0, 3)} ${code.substring(3)}',
                style: context.tt.headlineMedium
                    ?.copyWith(color: Colors.white, fontSize: 42, letterSpacing: 2)),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: left / 30,
                minHeight: 6,
                color: Seva.gold,
                backgroundColor: Colors.white24,
              ),
            ),
            const SizedBox(height: 8),
            Text(context.tr('New code in $left seconds', '$left ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಹೊಸ ಕೋಡ್'),
                style: const TextStyle(color: Colors.white)),
          ]),
        ),
        _section(context, context.tr('How to use it', 'ಹೇಗೆ ಬಳಸುವುದು')),
        _tipRow(context, Icons.signal_wifi_off, context.tr('Works offline', 'ಆಫ್‌ಲೈನ್‌ನಲ್ಲೂ ಕೆಲಸ ಮಾಡುತ್ತದೆ'),
            context.tr('Sign in when SMS OTPs are delayed', 'ಎಸ್‌ಎಂಎಸ್ ಒಟಿಪಿ ತಡವಾದಾಗ ಸೈನ್ ಇನ್ ಮಾಡಿ')),
        _tipRow(context, Icons.lock, context.tr('Keep it private', 'ಖಾಸಗಿಯಾಗಿಡಿ'),
            context.tr('Government staff will never ask for this code',
                'ಸರ್ಕಾರಿ ಸಿಬ್ಬಂದಿ ಈ ಕೋಡ್ ಅನ್ನು ಎಂದಿಗೂ ಕೇಳುವುದಿಲ್ಲ')),
      ]),
    );
  }
}
