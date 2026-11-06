import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/models.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';
import '../app/theme.dart';
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
    return Scaffold(
      appBar: SevaBar(
        automaticallyImplyLeading: false,
        title: Text(context.tr('Track applications', 'ಅರ್ಜಿಗಳನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ')),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('Track any application', 'ಯಾವುದೇ ಅರ್ಜಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ'),
                style: context.tt.titleLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 2),
            Text(
              context.tr('Service Plus, Sakala and counter tokens, all in one place.',
                  'ಸರ್ವಿಸ್ ಪ್ಲಸ್, ಸಕಾಲ ಮತ್ತು ಕೌಂಟರ್ ಟೋಕನ್‌ಗಳು ಒಂದೇ ಕಡೆ.'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: c,
              textCapitalization: TextCapitalization.characters,
              onSubmitted: (_) => lookup(),
              style: const TextStyle(color: Color(0xFF131524)),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: context.tr('Application or token number', 'ಅರ್ಜಿ ಅಥವಾ ಟೋಕನ್ ಸಂಖ್ಯೆ'),
                errorText: notFound
                    ? context.tr('Number not found. Check it and try again.',
                        'ಸಂಖ್ಯೆ ಸಿಗಲಿಲ್ಲ. ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.')
                    : null,
                errorStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  tooltip: context.tr('Track', 'ಟ್ರ್ಯಾಕ್'),
                  color: Seva.blue,
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: lookup,
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          for (final (v, k, tone) in [
            ('${s.applications.where((a) => !a.done).length}', context.tr('In progress', 'ಪ್ರಗತಿಯಲ್ಲಿದೆ'), 0),
            ('${s.applications.where((a) => a.done).length}', context.tr('Completed', 'ಪೂರ್ಣಗೊಂಡಿದೆ'), 7),
            ('${s.grievances.length}', context.tr('Grievances', 'ಕುಂದುಕೊರತೆಗಳು'), 6),
          ])
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: tone == 6 ? 0 : 8),
                child: SevaCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(v, style: context.tt.headlineSmall?.copyWith(color: Seva.tones[tone])),
                    Text(k,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
                  ]),
                ),
              ),
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
      appBar: SevaBar(title: Text(context.tr('Application status', 'ಅರ್ಜಿ ಸ್ಥಿತಿ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          child: Row(children: [
            SizedBox(
              width: 78,
              height: 78,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: a.progress,
                    strokeWidth: 7,
                    color: Seva.gold,
                    backgroundColor: Colors.white24,
                  ),
                ),
                Text('${(a.progress * 100).round()}%',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.loc(a.service),
                    style: context.tt.titleLarge?.copyWith(color: Colors.white)),
                SelectableText(a.id, style: const TextStyle(color: Colors.white, fontSize: 12.5)),
                const SizedBox(height: 4),
                Text(
                  a.done
                      ? context.tr('Completed', 'ಪೂರ್ಣಗೊಂಡಿದೆ')
                      : context.tr('Sakala deadline ${dateStr(deadline)}', 'ಸಕಾಲ ಗಡುವು ${dateStr(deadline)}'),
                  style: const TextStyle(color: Seva.gold, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),
        SevaCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('Application details', 'ಅರ್ಜಿ ವಿವರಗಳು'), style: context.tt.titleMedium),
            const SizedBox(height: 8),
            for (final (k, v) in [
              (context.tr('Department', 'ಇಲಾಖೆ'), context.loc(a.dept)),
              (context.tr('Applied on', 'ಅರ್ಜಿ ದಿನಾಂಕ'), dateStr(a.submitted)),
              (context.tr('Source', 'ಮೂಲ'), sourceName(a.source)),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  Expanded(child: Text(k, style: TextStyle(color: context.cs.onSurfaceVariant))),
                  Flexible(
                    child: Text(v,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        if (a.done) ...[
          FilledButton.icon(
            onPressed: () => toast(tx('Certificate saved', 'ಪ್ರಮಾಣಪತ್ರ ಉಳಿಸಲಾಗಿದೆ')),
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
