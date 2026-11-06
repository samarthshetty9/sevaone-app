import 'dart:math';

import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Vidhana Soudha, drawn as a silhouette. SevaOne's signature motif: it sits
/// behind every header, so the app reads as Karnataka's own at a glance.
class SkylinePainter extends CustomPainter {
  final Color color;
  const SkylinePainter({this.color = const Color(0x1FFFFFFF)});

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = color;
    final w = s.width;
    final h = s.height;
    final base = h;
    double y(double v) => base - v;

    // Plinth and long wings.
    canvas.drawRect(Rect.fromLTRB(0, y(8), w, base), p);
    canvas.drawRect(Rect.fromLTRB(w * .04, y(36), w * .96, y(8)), p);
    canvas.drawRect(Rect.fromLTRB(w * .02, y(40), w * .98, y(36)), p);

    // Colonnade: cut pale pillars out of the wings.
    final gap = Paint()
      ..color = Colors.black
      ..blendMode = BlendMode.dstOut;
    canvas.saveLayer(Offset.zero & s, Paint());
    canvas.drawRect(Rect.fromLTRB(w * .04, y(36), w * .96, y(8)), p);
    for (var x = w * .06; x < w * .94; x += 13) {
      canvas.drawRect(Rect.fromLTWH(x, y(32), 7, 22), gap);
    }
    canvas.restore();

    // Central block, portico and pediment.
    canvas.drawRect(Rect.fromLTRB(w * .34, y(66), w * .66, y(36)), p);
    final ped = Path()
      ..moveTo(w * .32, y(66))
      ..lineTo(w * .5, y(82))
      ..lineTo(w * .68, y(66))
      ..close();
    canvas.drawPath(ped, p);

    // Drum, main dome, finial.
    canvas.drawRect(Rect.fromCenter(center: Offset(w * .5, y(90)), width: 58, height: 18), p);
    final dome = Path()
      ..moveTo(w * .5 - 30, y(98))
      ..quadraticBezierTo(w * .5 - 28, y(136), w * .5, y(142))
      ..quadraticBezierTo(w * .5 + 28, y(136), w * .5 + 30, y(98))
      ..close();
    canvas.drawPath(dome, p);
    canvas.drawRect(Rect.fromCenter(center: Offset(w * .5, y(150)), width: 3, height: 18), p);
    canvas.drawCircle(Offset(w * .5, y(160)), 3.5, p);

    // Corner domes.
    for (final cx in [w * .14, w * .86]) {
      canvas.drawRect(Rect.fromCenter(center: Offset(cx, y(48)), width: 30, height: 16), p);
      final d = Path()
        ..moveTo(cx - 15, y(56))
        ..quadraticBezierTo(cx, y(82), cx + 15, y(56))
        ..close();
      canvas.drawPath(d, p);
      canvas.drawRect(Rect.fromCenter(center: Offset(cx, y(85)), width: 2, height: 10), p);
    }
  }

  @override
  bool shouldRepaint(SkylinePainter o) => o.color != color;
}

/// The skyline, sized to the width of its parent and pinned to the bottom edge.
class Skyline extends StatelessWidget {
  final double height;
  final Color color;
  const Skyline({super.key, this.height = 118, this.color = const Color(0x1FFFFFFF)});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
              width: 420, height: 170, child: CustomPaint(painter: SkylinePainter(color: color))),
        ),
      ),
    );
  }
}

/// Soft concentric rings used on hero panels and promo cards.
class RingsPainter extends CustomPainter {
  final Alignment at;
  final Color color;
  const RingsPainter({this.at = Alignment.topRight, this.color = const Color(0x0FFFFFFF)});

  @override
  void paint(Canvas canvas, Size s) {
    final c = at.alongSize(s);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;
    for (var r = 44.0; r < s.longestSide * 1.1; r += 46) {
      canvas.drawCircle(c, r, p);
    }
  }

  @override
  bool shouldRepaint(RingsPainter o) => false;
}

/// Gradient panel with decorative rings: the app's hero surface.
class GlowPanel extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final EdgeInsets padding;
  final double radius;
  final VoidCallback? onTap;
  final Alignment ringsAt;
  const GlowPanel({
    super.key,
    required this.child,
    this.colors = const [Seva.navy, Seva.blueDark, Seva.blue],
    this.padding = const EdgeInsets.all(18),
    this.radius = 22,
    this.onTap,
    this.ringsAt = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        ),
        child: InkWell(
          onTap: onTap,
          child: CustomPaint(
            painter: RingsPainter(at: ringsAt),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// Half-ring gauge for AQI and signal strength.
class ArcGauge extends StatelessWidget {
  final double value; // 0..1
  final String big;
  final String small;
  final double size;
  final List<Color> colors;
  final Color? textColor;
  const ArcGauge({
    super.key,
    required this.value,
    required this.big,
    required this.small,
    this.size = 150,
    this.colors = const [Seva.green, Color(0xFFB5C934), Seva.gold, Seva.saffron, Seva.red],
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: size,
      height: size * .72,
      child: CustomPaint(
        painter: _ArcPainter(value, colors, fg.withValues(alpha: .1)),
        child: Align(
          alignment: const Alignment(0, .55),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(big,
                style: TextStyle(
                    fontSize: size * .2, fontWeight: FontWeight.w700, color: fg, height: 1.1)),
            Text(small, style: TextStyle(fontSize: size * .085, color: fg.withValues(alpha: .75))),
          ]),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double v;
  final List<Color> colors;
  final Color track;
  _ArcPainter(this.v, this.colors, this.track);

  @override
  void paint(Canvas canvas, Size s) {
    final stroke = s.width * .09;
    final r = Rect.fromCircle(
        center: Offset(s.width / 2, s.width / 2), radius: s.width / 2 - stroke / 2);
    const start = pi * .85;
    const sweep = pi * 1.3;
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawArc(r, start, sweep, false, base);
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: colors,
        tileMode: TileMode.clamp,
      ).createShader(r);
    canvas.drawArc(r, start, sweep * v.clamp(0.02, 1.0), false, fill);
  }

  @override
  bool shouldRepaint(_ArcPainter o) => o.v != v;
}

/// Simple month-on-month bars, last one highlighted.
class MiniBars extends StatelessWidget {
  final List<int> values;
  final List<String> labels;
  final Color color;
  final double height;
  const MiniBars(
      {super.key,
      required this.values,
      required this.labels,
      required this.color,
      this.height = 96});

  @override
  Widget build(BuildContext context) {
    final maxV = values.reduce(max);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return ExcludeSemantics(
      child: SizedBox(
        height: height + 26,
        child: Row(children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: values[i] / maxV,
                        widthFactor: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: i == values.length - 1 ? color : color.withValues(alpha: .22),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(labels[i],
                      maxLines: 1,
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(fontSize: 11, color: muted)),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}

/// Large icon on layered circles, used as artwork on promos and empty headers.
class IconArt extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  const IconArt(this.icon, {super.key, this.size = 92, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: color.withValues(alpha: .13)),
        ),
        Container(
          width: size * .72,
          height: size * .72,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: color.withValues(alpha: .2)),
        ),
        Icon(icon, color: color, size: size * .42),
      ]),
    );
  }
}
