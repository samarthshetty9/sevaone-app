import 'dart:async';

import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../router.dart';
import '../widgets/common.dart';

/// Features 14, 16 plus IVR.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget tile(IconData i, String t, String sub, VoidCallback tap) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SevaCard(
            onTap: tap,
            child: Row(children: [
              IconBadge(i),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(sub, style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                ]),
              ),
              Icon(Icons.chevron_right, color: context.cs.onSurfaceVariant),
            ]),
          ),
        );
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Help', 'ಸಹಾಯ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        tile(Icons.call_outlined, context.tr('Call 1902', '1902ಗೆ ಕರೆ ಮಾಡಿ'),
            context.tr('Helpline with Kannada menu, 24x7', 'ಕನ್ನಡ ಮೆನು ಇರುವ ಸಹಾಯವಾಣಿ, 24x7'),
            () => push(context, const IvrScreen())),
        tile(Icons.chat_outlined, context.tr('Live chat', 'ಲೈವ್ ಚಾಟ್'),
            context.tr('Talk to an agent now', 'ಈಗ ಸಹಾಯಕರ ಜೊತೆ ಮಾತನಾಡಿ'), () => openRoute('chat')),
        tile(Icons.graphic_eq, context.tr('Voice bot', 'ಧ್ವನಿ ಬಾಟ್'),
            context.tr('Ask by speaking', 'ಮಾತನಾಡಿ ಕೇಳಿ'), () => openRoute('voice')),
        tile(Icons.sms_outlined, 'SMS', context.tr('No internet needed', 'ಇಂಟರ್ನೆಟ್ ಬೇಕಿಲ್ಲ'),
            () => openRoute('sms')),
        tile(Icons.report_problem_outlined, context.tr('Grievance', 'ಕುಂದುಕೊರತೆ'),
            context.tr('Filed through iPGRS', 'ಐಪಿಜಿಆರ್‌ಎಸ್ ಮೂಲಕ ಸಲ್ಲಿಕೆ'), () => openRoute('grievance')),
        tile(Icons.star_outline, context.tr('Give feedback', 'ಪ್ರತಿಕ್ರಿಯೆ ನೀಡಿ'),
            context.tr('Tell us how we did', 'ನಮ್ಮ ಸೇವೆ ಹೇಗಿತ್ತು ತಿಳಿಸಿ'), () => openRoute('feedback')),
        const SizedBox(height: 10),
        Semantics(
          header: true,
          child: Text(context.tr('Common questions', 'ಸಾಮಾನ್ಯ ಪ್ರಶ್ನೆಗಳು'), style: context.tt.titleLarge),
        ),
        const SizedBox(height: 4),
        for (final (q, a) in faqs)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 12),
            expandedAlignment: Alignment.centerLeft,
            title: Text(context.loc(q), style: const TextStyle(fontWeight: FontWeight.w600)),
            children: [Text(context.loc(a))],
          ),
      ]),
    );
  }
}

/// Simulated phone call with a keypad-driven IVR menu.
class IvrScreen extends StatefulWidget {
  const IvrScreen({super.key});

  @override
  State<IvrScreen> createState() => _IvrScreenState();
}

class _IvrScreenState extends State<IvrScreen> {
  int seconds = 0;
  Timer? t;
  String? spoken;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => seconds++));
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  void press(int k) {
    final a = app.applications.first;
    setState(() => spoken = switch (k) {
          1 => tx('Your ${a.service.en} is at: ${a.stages[a.current].title.en}.',
              'ನಿಮ್ಮ ${a.service.kn} ಈ ಹಂತದಲ್ಲಿದೆ: ${a.stages[a.current].title.kn}.'),
          2 => tx('Your nearest centre is ${centres.first.name.en}.',
              'ನಿಮ್ಮ ಹತ್ತಿರದ ಕೇಂದ್ರ ${centres.first.name.kn}.'),
          3 => tx('Your grievance is noted. An officer will call back.',
              'ನಿಮ್ಮ ಕುಂದುಕೊರತೆ ದಾಖಲಾಗಿದೆ. ಅಧಿಕಾರಿ ಮರಳಿ ಕರೆ ಮಾಡುತ್ತಾರೆ.'),
          _ => tx('Connecting you to an agent.', 'ಸಹಾಯಕರಿಗೆ ಸಂಪರ್ಕಿಸಲಾಗುತ್ತಿದೆ.'),
        });
  }

  @override
  Widget build(BuildContext context) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    final menu = [
      (1, context.tr('Application status', 'ಅರ್ಜಿ ಸ್ಥಿತಿ')),
      (2, context.tr('Nearest centre', 'ಹತ್ತಿರದ ಕೇಂದ್ರ')),
      (3, context.tr('Report a problem', 'ಸಮಸ್ಯೆ ವರದಿ ಮಾಡಿ')),
      (0, context.tr('Talk to an agent', 'ಸಹಾಯಕರ ಜೊತೆ ಮಾತನಾಡಿ')),
    ];
    return Scaffold(
      backgroundColor: Seva.navy,
      appBar: AppBar(
        backgroundColor: Seva.navy,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: const [DemoChip(onDark: true), SizedBox(width: 16)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(children: [
            Text('1902', style: context.tt.headlineMedium?.copyWith(color: Colors.white, fontSize: 40)),
            Text('$m:$sec', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 24),
            Semantics(
              liveRegion: true,
              child: Text(
                spoken ?? context.tr('Press a number on the keypad.', 'ಕೀಪ್ಯಾಡ್‌ನಲ್ಲಿ ಸಂಖ್ಯೆ ಒತ್ತಿರಿ.'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 17, height: 1.4),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(children: [
                for (final (k, label) in menu)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: const Color(0xFF2B2D52),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => press(k),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Text('$k',
                                  style: const TextStyle(
                                      color: Seva.navy, fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(label,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
              ]),
            ),
            IconButton.filled(
              tooltip: context.tr('End call', 'ಕರೆ ಮುಗಿಸಿ'),
              style: IconButton.styleFrom(
                  backgroundColor: Seva.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(66, 66)),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.call_end, size: 30),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Feature 14: iPGRS grievance.
class GrievanceScreen extends StatefulWidget {
  final String? prefill;
  const GrievanceScreen({super.key, this.prefill});

  @override
  State<GrievanceScreen> createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends State<GrievanceScreen> {
  late final subject = TextEditingController(
      text: widget.prefill == null ? '' : 'Regarding ${widget.prefill}');
  final details = TextEditingController();
  String dept = 'Revenue Department';
  Grievance? filed;

  @override
  void dispose() {
    subject.dispose();
    details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final depts = ['Revenue Department', 'Transport Department', 'Education Department', 'BESCOM', 'BWSSB'];
    final stages = [
      context.tr('Registered', 'ನೋಂದಾಯಿಸಲಾಗಿದೆ'),
      context.tr('Assigned', 'ನಿಯೋಜಿಸಲಾಗಿದೆ'),
      context.tr('In progress', 'ಪ್ರಗತಿಯಲ್ಲಿದೆ'),
      context.tr('Resolved', 'ಪರಿಹರಿಸಲಾಗಿದೆ'),
    ];
    final canSend = subject.text.trim().length > 3 && details.text.trim().length > 3;
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Grievance', 'ಕುಂದುಕೊರತೆ')), actions: const [
        Padding(padding: EdgeInsets.only(right: 16), child: Center(child: Text('iPGRS'))),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (filed != null) ...[
          SevaCard(
            color: context.cs.secondary.withValues(alpha: 0.1),
            child: Row(children: [
              Icon(Icons.check_circle, color: context.cs.secondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(context.tr('Registered as ${filed!.id}', '${filed!.id} ಆಗಿ ನೋಂದಾಯಿಸಲಾಗಿದೆ'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 12),
        ],
        Text(context.tr('Department', 'ಇಲಾಖೆ'), style: context.tt.titleMedium),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final d in depts)
            ChoiceChip(
                label: Text(d), selected: dept == d, onSelected: (_) => setState(() => dept = d)),
        ]),
        const SizedBox(height: 14),
        TextField(
          controller: subject,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: context.tr('Subject', 'ವಿಷಯ')),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: details,
          onChanged: (_) => setState(() {}),
          maxLines: 3,
          decoration: InputDecoration(labelText: context.tr('What happened?', 'ಏನಾಯಿತು?')),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: canSend
              ? () {
                  final g = app.addGrievance(dept, subject.text.trim(), details.text.trim());
                  subject.clear();
                  details.clear();
                  FocusScope.of(context).unfocus();
                  setState(() => filed = g);
                }
              : null,
          child: Text(context.tr('Submit grievance', 'ಕುಂದುಕೊರತೆ ಸಲ್ಲಿಸಿ')),
        ),
        const SizedBox(height: 20),
        Text(context.tr('My grievances', 'ನನ್ನ ಕುಂದುಕೊರತೆಗಳು'), style: context.tt.titleLarge),
        const SizedBox(height: 8),
        for (final g in s.grievances)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g.subject, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${g.id} · ${g.department}',
                    style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(value: (g.stage + 1) / 4, minHeight: 6),
                ),
                const SizedBox(height: 6),
                Text(stages[g.stage], style: const TextStyle(fontSize: 13)),
              ]),
            ),
          ),
      ]),
    );
  }
}

/// Feature 7: feedback collection.
class FeedbackScreen extends StatefulWidget {
  final String? subject;
  const FeedbackScreen({super.key, this.subject});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int stars = 0;
  final tags = <String>{};
  final c = TextEditingController();
  bool sent = false;

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      context.tr('Easy to use', 'ಬಳಸಲು ಸುಲಭ'),
      context.tr('Fast', 'ವೇಗ'),
      context.tr('Clear language', 'ಸ್ಪಷ್ಟ ಭಾಷೆ'),
      context.tr('Had errors', 'ದೋಷಗಳಿದ್ದವು'),
      context.tr('Too slow', 'ತುಂಬಾ ನಿಧಾನ'),
    ];
    final subject = widget.subject ?? context.tr('SevaOne app', 'ಸೇವಾಒನ್ ಆ್ಯಪ್');
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Feedback', 'ಪ್ರತಿಕ್ರಿಯೆ'))),
      body: ListView(
          padding: const EdgeInsets.all(20),
          children: sent
              ? [
                  const SizedBox(height: 40),
                  const Center(child: SuccessTick()),
                  const SizedBox(height: 16),
                  Text(context.tr('Thank you', 'ಧನ್ಯವಾದಗಳು'),
                      textAlign: TextAlign.center, style: context.tt.headlineSmall),
                ]
              : [
                  Text(context.tr('How was it?', 'ಹೇಗಿತ್ತು?'), style: context.tt.headlineSmall),
                  Text(subject, style: TextStyle(color: context.cs.onSurfaceVariant)),
                  const SizedBox(height: 14),
                  Row(children: [
                    for (var i = 1; i <= 5; i++)
                      IconButton(
                        tooltip: context.tr('$i out of 5', '5 ರಲ್ಲಿ $i'),
                        iconSize: 36,
                        onPressed: () => setState(() => stars = i),
                        icon: Icon(i <= stars ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Seva.gold),
                      ),
                  ]),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final o in options)
                      FilterChip(
                        label: Text(o),
                        selected: tags.contains(o),
                        onSelected: (v) =>
                            setState(() => v ? tags.add(o) : tags.remove(o)),
                      ),
                  ]),
                  const SizedBox(height: 14),
                  TextField(
                    controller: c,
                    maxLines: 3,
                    decoration: InputDecoration(
                        labelText: context.tr('Anything else? (optional)', 'ಬೇರೆ ಏನಾದರೂ? (ಐಚ್ಛಿಕ)')),
                  ),
                ]),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: sent
              ? () => Navigator.of(context).pop()
              : stars == 0
                  ? null
                  : () {
                      app.addFeedback(FeedbackEntry(
                          subject, stars, tags.toList(), c.text.trim(), DateTime.now()));
                      setState(() => sent = true);
                    },
          child: Text(sent ? context.tr('Done', 'ಮುಗಿಯಿತು') : context.tr('Send', 'ಕಳುಹಿಸಿ')),
        ),
      ),
    );
  }
}
