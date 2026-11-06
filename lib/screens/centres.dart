import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../widgets/common.dart';

/// Feature 19: GramaOne and Karnataka One locator, on a stylised painted map.
class CentresScreen extends StatefulWidget {
  const CentresScreen({super.key});

  @override
  State<CentresScreen> createState() => _CentresScreenState();
}

class _CentresScreenState extends State<CentresScreen> {
  String filter = 'all';
  String? selected;

  @override
  Widget build(BuildContext context) {
    final list = centres.where((c) => filter == 'all' || c.type == filter).toList();
    Widget chip(String id, String label) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: filter == id,
            onSelected: (_) => setState(() {
              filter = id;
              selected = null;
            }),
          ),
        );
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Find a centre', 'ಕೇಂದ್ರ ಹುಡುಕಿ'))),
      body: ListView(padding: EdgeInsets.zero, children: [
        ExcludeSemantics(
          child: LayoutBuilder(builder: (context, box) {
            const h = 240.0;
            return SizedBox(
              height: h,
              child: Stack(children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapPainter(dark: context.cs.brightness == Brightness.dark),
                  ),
                ),
                // Your location
                Positioned(
                  left: box.maxWidth * 0.5 - 9,
                  top: h * 0.46 - 9,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Seva.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                    ),
                  ),
                ),
                for (final c in list)
                  Positioned(
                    left: box.maxWidth * c.map.dx - 16,
                    top: h * c.map.dy - 30,
                    child: GestureDetector(
                      onTap: () => setState(() => selected = c.id),
                      child: Icon(Icons.location_on,
                          size: selected == c.id ? 40 : 32,
                          color: c.type == 'GramaOne' ? Seva.greenDark : Seva.saffron),
                    ),
                  ),
              ]),
            );
          }),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            children: [
              chip('all', context.tr('All', 'ಎಲ್ಲಾ')),
              chip('GramaOne', context.tr('GramaOne', 'ಗ್ರಾಮ ಒನ್')),
              chip('Karnataka One', context.tr('Karnataka One', 'ಕರ್ನಾಟಕ ಒನ್')),
            ],
          ),
        ),
        for (final c in selected == null ? list : list.where((x) => x.id == selected))
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
            child: _CentreRow(c),
          ),
        if (selected != null)
          TextButton(
            onPressed: () => setState(() => selected = null),
            child: Text(context.tr('Show all centres', 'ಎಲ್ಲಾ ಕೇಂದ್ರಗಳನ್ನು ತೋರಿಸಿ')),
          ),
        const SizedBox(height: 16),
      ]),
    );
  }
}

class _CentreRow extends StatelessWidget {
  final Centre c;
  const _CentreRow(this.c);

  @override
  Widget build(BuildContext context) {
    final crowd = [
      context.tr('Not busy', 'ಹೆಚ್ಚು ಜನರಿಲ್ಲ'),
      context.tr('Moderate', 'ಮಧ್ಯಮ'),
      context.tr('Busy', 'ಹೆಚ್ಚು ಜನರಿದ್ದಾರೆ'),
    ][c.crowd];
    return SevaCard(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _CentreSheet(c),
      ),
      child: Row(children: [
        IconBadge(Icons.location_on_outlined,
            color: c.type == 'GramaOne' ? Seva.greenDark : Seva.saffron),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.loc(c.name), style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${c.km} km · $crowd',
                style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
          ]),
        ),
        Icon(Icons.chevron_right, color: context.cs.onSurfaceVariant),
      ]),
    );
  }
}

class _CentreSheet extends StatefulWidget {
  final Centre c;
  const _CentreSheet(this.c);

  @override
  State<_CentreSheet> createState() => _CentreSheetState();
}

class _CentreSheetState extends State<_CentreSheet> {
  String? slot;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    final slots = ['10:00', '11:30', '14:00', '15:30'];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.loc(c.name), style: context.tt.titleLarge),
              const SizedBox(height: 4),
              Text(context.loc(c.address), style: TextStyle(color: context.cs.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text('${c.hours} · ${c.phone}',
                  style: TextStyle(color: context.cs.onSurfaceVariant)),
              const SizedBox(height: 14),
              Text(context.tr('Book a visit for tomorrow', 'ನಾಳೆಗೆ ಭೇಟಿ ಕಾಯ್ದಿರಿಸಿ'),
                  style: context.tt.titleMedium),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final t in slots)
                  ChoiceChip(
                    label: Text(t),
                    selected: slot == t,
                    onSelected: (_) => setState(() => slot = t),
                  ),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => toast(tx('Opening directions', 'ಮಾರ್ಗ ತೆರೆಯಲಾಗುತ್ತಿದೆ')),
                    icon: const Icon(Icons.directions_outlined),
                    label: Text(context.tr('Directions', 'ಮಾರ್ಗ')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: slot == null
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            toast(tx('Visit booked at $slot', '$slot ಕ್ಕೆ ಭೇಟಿ ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ'));
                          },
                    child: Text(context.tr('Book', 'ಕಾಯ್ದಿರಿಸಿ')),
                  ),
                ),
              ]),
            ]),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final bool dark;
  _MapPainter({required this.dark});

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s,
        Paint()..color = dark ? const Color(0xFF1B1D3A) : const Color(0xFFEFF1EA));
    final park = Paint()..color = dark ? const Color(0xFF213B36) : const Color(0xFFD5E8CF);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(s.width * .08, s.height * .55, s.width * .22, s.height * .3),
            const Radius.circular(20)),
        park);
    canvas.drawCircle(Offset(s.width * .78, s.height * .72), s.height * .15, park);
    final water = Paint()..color = dark ? const Color(0xFF23406A) : const Color(0xFFBFDDF2);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(s.width * .3, s.height * .12), width: s.width * .22, height: 34),
        water);
    final road = Paint()
      ..color = dark ? const Color(0xFF34375F) : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final minor = Paint()
      ..color = dark ? const Color(0xFF2B2E52) : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final p1 = Path()
      ..moveTo(0, s.height * .3)
      ..quadraticBezierTo(s.width * .4, s.height * .42, s.width, s.height * .34);
    final p2 = Path()
      ..moveTo(s.width * .55, 0)
      ..quadraticBezierTo(s.width * .46, s.height * .5, s.width * .62, s.height);
    final p3 = Path()
      ..moveTo(0, s.height * .84)
      ..quadraticBezierTo(s.width * .5, s.height * .6, s.width, s.height * .9);
    canvas
      ..drawPath(p1, road)
      ..drawPath(p2, road)
      ..drawPath(p3, road);
    for (var i = 1; i < 7; i++) {
      canvas.drawLine(Offset(s.width * i / 7, 0), Offset(s.width * i / 7 + 24, s.height), minor);
    }
    for (var i = 1; i < 5; i++) {
      canvas.drawLine(Offset(0, s.height * i / 5), Offset(s.width, s.height * i / 5 - 14), minor);
    }
  }

  @override
  bool shouldRepaint(_MapPainter o) => o.dark != dark;
}
