import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../widgets/common.dart';

class _Sample {
  final String id;
  final L title;
  final List<(String, String)> lines;
  final Map<String, String> fields;
  const _Sample(this.id, this.title, this.lines, this.fields);
}

const _samples = [
  _Sample('ration', L('Ration card', 'ಪಡಿತರ ಚೀಟಿ'), [
    ('GOVERNMENT OF KARNATAKA', 'h'),
    ('Ration Card (BPL)', 'b'),
    ('Card No: KA-BPL-29-004417', 'n'),
    ('Head: Ananya Gowda', 'n'),
    ('Members: 4', 'n'),
    ('Taluk: Bengaluru North', 'n'),
  ], {
    'Card number': 'KA-BPL-29-004417',
    'Card type': 'BPL',
    'Head of family': 'Ananya Gowda',
    'Members': '4',
    'Taluk': 'Bengaluru North',
  }),
  _Sample('bill', L('Electricity bill', 'ವಿದ್ಯುತ್ ಬಿಲ್'), [
    ('BESCOM', 'h'),
    ('Electricity Bill', 'b'),
    ('Account ID: 7342019865', 'n'),
    ('Units: 214', 'n'),
    ('Amount: Rs 1,284', 'n'),
    ('Due date: 09 Nov 2026', 'n'),
  ], {
    'Account ID': '7342019865',
    'Units': '214',
    'Amount': '₹1,284',
    'Due date': '09 Nov 2026',
  }),
  _Sample('income', L('Income certificate', 'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರ'), [
    ('REVENUE DEPARTMENT', 'h'),
    ('Income Certificate', 'b'),
    ('No: RD0041225000918', 'n'),
    ('Name: Ananya Gowda', 'n'),
    ('Annual income: Rs 1,80,000', 'n'),
    ('Valid till: Mar 2029', 'n'),
  ], {
    'Certificate number': 'RD0041225000918',
    'Name': 'Ananya Gowda',
    'Annual income': '₹1,80,000',
    'Valid till': 'Mar 2029',
  }),
];

_Sample _sample(String id) => _samples.firstWhere((s) => s.id == id);

/// Feature 17. No camera plugin: the viewfinder is painted, and the user picks
/// which sample paper is "on the table".
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin {
  late final AnimationController sweep =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
  String sampleId = 'ration';
  String filter = 'Auto';
  bool captured = false;
  bool detected = false;

  @override
  void initState() {
    super.initState();
    if (!app.reduceMotion) sweep.repeat(reverse: true);
    _detect();
  }

  void _detect() {
    detected = false;
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => detected = true);
    });
  }

  @override
  void dispose() {
    sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sample = _sample(sampleId);
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F1C),
      appBar: SevaBar(
        title: Text(captured
            ? context.tr('Review scan', 'ಸ್ಕ್ಯಾನ್ ಪರಿಶೀಲಿಸಿ')
            : context.tr('Scan document', 'ದಾಖಲೆ ಸ್ಕ್ಯಾನ್')),
      ),
      body: Column(children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: AspectRatio(
                aspectRatio: 0.72,
                child: Stack(fit: StackFit.expand, children: [
                  Semantics(
                    label: context.tr('Document in view: ${sample.title.en}',
                        'ದೃಶ್ಯದಲ್ಲಿರುವ ದಾಖಲೆ: ${sample.title.kn}'),
                    child: PaperView(sample: sampleId, filter: filter),
                  ),
                  if (!captured) ...[
                    AnimatedOpacity(
                      opacity: detected ? 1 : 0.25,
                      duration: const Duration(milliseconds: 300),
                      child: CustomPaint(painter: _Corners(detected ? Seva.green : Colors.white)),
                    ),
                    AnimatedBuilder(
                      animation: sweep,
                      builder: (_, _) => Align(
                        alignment: Alignment(0, sweep.value * 2 - 1),
                        child: Container(
                          height: 2,
                          color: Seva.green.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ]),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: const Color(0xFF17182C),
          child: SafeArea(
            top: false,
            child: captured ? _review(context) : _capture(context),
          ),
        ),
      ]),
    );
  }

  Widget _chip(String label, bool on, VoidCallback tap) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(label: Text(label), selected: on, onSelected: (_) => tap()),
      );

  Widget _capture(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(
        detected
            ? context.tr('Edges found. Hold steady.', 'ಅಂಚುಗಳು ಸಿಕ್ಕಿವೆ. ಸ್ಥಿರವಾಗಿ ಹಿಡಿಯಿರಿ.')
            : context.tr('Finding document edges…', 'ದಾಖಲೆ ಅಂಚುಗಳನ್ನು ಹುಡುಕಲಾಗುತ್ತಿದೆ…'),
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 42,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (final s in _samples)
            _chip(context.loc(s.title), sampleId == s.id, () {
              setState(() {
                sampleId = s.id;
                _detect();
              });
            }),
        ]),
      ),
      const SizedBox(height: 10),
      Semantics(
        button: true,
        label: context.tr('Capture', 'ಸೆರೆಹಿಡಿಯಿರಿ'),
        child: GestureDetector(
          onTap: detected ? () => setState(() => captured = true) : null,
          child: Container(
            width: 68,
            height: 68,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: detected ? Colors.white : Colors.white38),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _review(BuildContext context) {
    final filters = {
      'Auto': context.tr('Auto', 'ಸ್ವಯಂ'),
      'B&W': context.tr('Black and white', 'ಕಪ್ಪು ಬಿಳುಪು'),
      'Colour': context.tr('Colour', 'ಬಣ್ಣ'),
    };
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: 42,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (final e in filters.entries)
            _chip(e.value, filter == e.key, () => setState(() => filter = e.key)),
        ]),
      ),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)),
            onPressed: () => setState(() {
              captured = false;
              _detect();
            }),
            child: Text(context.tr('Retake', 'ಮತ್ತೆ ತೆಗೆಯಿರಿ')),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Seva.gold, foregroundColor: Seva.navy),
            onPressed: () {
              final d = ScannedDoc('s${DateTime.now().millisecondsSinceEpoch}',
                  _sample(sampleId).title, sampleId, filter, DateTime.now());
              app.addScan(d);
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => OcrScreen(d)));
            },
            child: Text(context.tr('Save', 'ಉಳಿಸಿ')),
          ),
        ),
      ]),
    ]);
  }
}

class _Corners extends CustomPainter {
  final Color c;
  _Corners(this.c);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    const l = 30.0;
    for (final (o, dx, dy) in [
      (Offset.zero, 1.0, 1.0),
      (Offset(s.width, 0), -1.0, 1.0),
      (Offset(0, s.height), 1.0, -1.0),
      (Offset(s.width, s.height), -1.0, -1.0),
    ]) {
      canvas.drawLine(o, o + Offset(l * dx, 0), p);
      canvas.drawLine(o, o + Offset(0, l * dy), p);
    }
  }

  @override
  bool shouldRepaint(_Corners o) => o.c != c;
}

class PaperView extends StatelessWidget {
  final String sample;
  final String filter;
  final int highlight;
  const PaperView({super.key, required this.sample, required this.filter, this.highlight = -1});

  @override
  Widget build(BuildContext context) {
    final s = _sample(sample);
    final bw = filter == 'B&W';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: filter == 'Colour' ? const Color(0xFFFFF8E6) : Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final (i, (t, kind)) in s.lines.indexed)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: EdgeInsets.only(bottom: kind == 'n' ? 8 : 6),
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            color: i <= highlight ? Seva.gold.withValues(alpha: 0.4) : Colors.transparent,
            child: Text(t,
                maxLines: 2,
                style: TextStyle(
                  color: bw ? Colors.black : const Color(0xFF1A1C37),
                  fontFamily: 'NotoSans',
                  fontSize: kind == 'h' ? 12 : (kind == 'b' ? 17 : 13),
                  fontWeight: kind == 'n' ? FontWeight.w600 : FontWeight.w700,
                  letterSpacing: kind == 'h' ? 1 : 0,
                )),
          ),
      ]),
    );
  }
}

/// Feature 18: simulated OCR with line-by-line progress and extracted fields.
class OcrScreen extends StatefulWidget {
  final ScannedDoc d;
  const OcrScreen(this.d, {super.key});

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  int line = -1;
  bool running = false;

  Future<void> run() async {
    setState(() => running = true);
    final n = _sample(widget.d.sample).lines.length;
    for (var i = 0; i < n; i++) {
      await Future.delayed(const Duration(milliseconds: 380));
      if (!mounted) return;
      setState(() => line = i);
    }
    app.set(() => widget.d.ocr = _sample(widget.d.sample).fields);
    if (mounted) setState(() => running = false);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    final fields = d.ocr;
    return Scaffold(
      appBar: SevaBar(title: Text(context.loc(d.title))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SizedBox(
          height: 250,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: const Color(0xFF17182C), borderRadius: BorderRadius.circular(14)),
            child: PaperView(sample: d.sample, filter: d.filter, highlight: fields != null ? 99 : line),
          ),
        ),
        const SizedBox(height: 14),
        if (fields == null)
          FilledButton.icon(
            onPressed: running ? null : run,
            icon: running
                ? const SizedBox(
                    width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.text_snippet_outlined),
            label: Text(running
                ? context.tr('Reading text…', 'ಪಠ್ಯ ಓದಲಾಗುತ್ತಿದೆ…')
                : context.tr('Extract text (OCR)', 'ಪಠ್ಯ ಪಡೆಯಿರಿ (ಒಸಿಆರ್)')),
          )
        else ...[
          Text(context.tr('Extracted details', 'ಪಡೆದ ವಿವರಗಳು'), style: context.tt.titleLarge),
          const SizedBox(height: 8),
          SevaCard(
            child: Column(children: [
              for (final e in fields.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(children: [
                    Expanded(
                        child: Text(e.key, style: TextStyle(color: context.cs.onSurfaceVariant))),
                    Flexible(
                      child: SelectableText(e.value,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),
            ]),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => toast(tx('Details saved for autofill',
                'ಸ್ವಯಂ ಭರ್ತಿಗಾಗಿ ವಿವರಗಳನ್ನು ಉಳಿಸಲಾಗಿದೆ')),
            child: Text(context.tr('Use for autofill', 'ಸ್ವಯಂ ಭರ್ತಿಗೆ ಬಳಸಿ')),
          ),
        ],
      ]),
    );
  }
}
