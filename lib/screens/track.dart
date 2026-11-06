import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/models.dart';
import '../widgets/common.dart';
import 'support.dart';

/// Feature 8: tracking across Service Plus, Sakala and token-based applications.
class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final c = TextEditingController();
  bool notFound = false;

  void lookup([String? id]) {
    final q = id ?? c.text;
    final a = app.findApplication(q);
    if (a == null) {
      setState(() => notFound = true);
    } else {
      setState(() => notFound = false);
      push(context, ApplicationDetail(a));
    }
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final samples = ['KAR-REV-2026-104512', 'SKL-GSC-2026-778120', 'TKN-8842-1190'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.tr('Track applications', 'ಅರ್ಜಿಗಳನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ')),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(
          context.tr('Works for Service Plus, Sakala and counter tokens.',
              'ಸರ್ವಿಸ್ ಪ್ಲಸ್, ಸಕಾಲ ಮತ್ತು ಕೌಂಟರ್ ಟೋಕನ್‌ಗಳಿಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ.'),
          style: TextStyle(color: context.cs.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: c,
          textCapitalization: TextCapitalization.characters,
          onSubmitted: (_) => lookup(),
          decoration: InputDecoration(
            labelText: context.tr('Application or token number', 'ಅರ್ಜಿ ಅಥವಾ ಟೋಕನ್ ಸಂಖ್ಯೆ'),
            errorText: notFound
                ? context.tr('Number not found. Try a sample below.',
                    'ಸಂಖ್ಯೆ ಸಿಗಲಿಲ್ಲ. ಕೆಳಗಿನ ಮಾದರಿ ಪ್ರಯತ್ನಿಸಿ.')
                : null,
            suffixIcon: IconButton(
              tooltip: context.tr('Track', 'ಟ್ರ್ಯಾಕ್'),
              icon: const Icon(Icons.arrow_forward),
              onPressed: lookup,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final id in samples)
            ActionChip(
              label: Text(id, style: const TextStyle(fontSize: 12)),
              onPressed: () {
                c.text = id;
                lookup(id);
              },
            ),
        ]),
        const SizedBox(height: 18),
        Semantics(
          header: true,
          child: Text(context.tr('My applications', 'ನನ್ನ ಅರ್ಜಿಗಳು'), style: context.tt.titleLarge),
        ),
        const SizedBox(height: 8),
        for (final a in s.applications)
          Padding(padding: const EdgeInsets.only(bottom: 10), child: ApplicationCard(a)),
      ]),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final Application a;
  const ApplicationCard(this.a, {super.key});

  @override
  Widget build(BuildContext context) {
    context.watchApp;
    return SevaCard(
      onTap: () => push(context, ApplicationDetail(a)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(context.loc(a.service), style: context.tt.titleMedium)),
          const SizedBox(width: 8),
          StatusChip(a),
        ]),
        const SizedBox(height: 2),
        Text('${a.id} · ${sourceName(a.source)}',
            style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: a.progress,
            minHeight: 6,
            color: a.done ? context.cs.secondary : context.cs.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(context.loc(a.stages[a.current].title),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class ApplicationDetail extends StatelessWidget {
  final Application a;
  const ApplicationDetail(this.a, {super.key});

  @override
  Widget build(BuildContext context) {
    context.watchApp;
    final deadline = a.submitted.add(Duration(days: a.sakalaDays));
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Application status', 'ಅರ್ಜಿ ಸ್ಥಿತಿ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(context.loc(a.service), style: context.tt.headlineSmall),
        const SizedBox(height: 2),
        SelectableText(a.id, style: TextStyle(color: context.cs.onSurfaceVariant)),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          StatusChip(a),
          Pill(sourceName(a.source), color: context.cs.onSurfaceVariant),
          if (!a.done)
            Pill(
              context.tr('Due by ${dateStr(deadline)}', '${dateStr(deadline)} ಒಳಗೆ'),
              color: const Color(0xFFB57700),
              icon: Icons.schedule,
            ),
        ]),
        const SizedBox(height: 18),
        SevaCard(
          child: Column(children: [
            for (var i = 0; i < a.stages.length; i++)
              _Stage(
                stage: a.stages[i],
                state: i < a.current || a.done ? 2 : (i == a.current ? 1 : 0),
                last: i == a.stages.length - 1,
              ),
          ]),
        ),
        const SizedBox(height: 14),
        if (!a.done)
          OutlinedButton.icon(
            onPressed: () => app.advance(a),
            icon: const Icon(Icons.fast_forward_outlined),
            label: Text(context.tr('Simulate next step', 'ಮುಂದಿನ ಹಂತ ಅನುಕರಿಸಿ')),
          ),
        if (a.done) ...[
          FilledButton.icon(
            onPressed: () => toast(tx('Certificate saved (demo)', 'ಪ್ರಮಾಣಪತ್ರ ಉಳಿಸಲಾಗಿದೆ (ಡೆಮೊ)')),
            icon: const Icon(Icons.download_outlined),
            label: Text(context.tr('Download certificate', 'ಪ್ರಮಾಣಪತ್ರ ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => push(context, FeedbackScreen(subject: context.loc(a.service))),
            child: Text(context.tr('Rate this service', 'ಈ ಸೇವೆಯನ್ನು ರೇಟ್ ಮಾಡಿ')),
          ),
        ],
        TextButton(
          onPressed: () => push(context, GrievanceScreen(prefill: a.id)),
          child: Text(context.tr('Raise a grievance', 'ಕುಂದುಕೊರತೆ ಸಲ್ಲಿಸಿ')),
        ),
      ]),
    );
  }
}

class _Stage extends StatelessWidget {
  final TrackStage stage;
  final int state; // 0 upcoming, 1 current, 2 done
  final bool last;
  const _Stage({required this.stage, required this.state, required this.last});

  @override
  Widget build(BuildContext context) {
    final c = state == 2
        ? context.cs.secondary
        : state == 1
            ? context.cs.primary
            : context.cs.outlineVariant;
    final status = switch (state) {
      2 => context.tr('Done', 'ಪೂರ್ಣ'),
      1 => context.tr('Current step', 'ಪ್ರಸ್ತುತ ಹಂತ'),
      _ => context.tr('Upcoming', 'ಮುಂದಿನದು'),
    };
    return Semantics(
      label: '${context.loc(stage.title)}, $status',
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: 26,
            child: Column(children: [
              Icon(
                state == 2
                    ? Icons.check_circle
                    : state == 1
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                color: c,
                size: 22,
              ),
              if (!last) Expanded(child: Container(width: 2, color: c)),
            ]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.loc(stage.title),
                    style: TextStyle(
                        fontWeight: state == 1 ? FontWeight.w700 : FontWeight.w500,
                        color: state == 0 ? context.cs.onSurfaceVariant : context.cs.onSurface)),
                if (state > 0 && stage.note != null)
                  Text(context.loc(stage.note!),
                      style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                if (stage.at != null)
                  Text(dateStr(stage.at!),
                      style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
