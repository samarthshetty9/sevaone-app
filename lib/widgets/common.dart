import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import 'art.dart';

class SevaCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? color;
  final String? semanticLabel;
  const SevaCard(
      {super.key,
      required this.child,
      this.onTap,
      this.padding = const EdgeInsets.all(14),
      this.color,
      this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    final dark = context.cs.brightness == Brightness.dark;
    final contrast = context.watchApp.highContrast;
    final card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: contrast ? Border.all(color: context.cs.outlineVariant, width: 1.5) : null,
        boxShadow: dark
            ? null
            : const [BoxShadow(color: Color(0x141A1C37), blurRadius: 20, offset: Offset(0, 6))],
      ),
      child: Material(
        color: color == null ? context.cs.surfaceContainerLow : Color.alphaBlend(color!, context.cs.surfaceContainerLow),
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    if (semanticLabel == null) return card;
    return Semantics(button: onTap != null, label: semanticLabel, child: card);
  }
}

/// Branded page header: indigo gradient with the Vidhana Soudha skyline.
class SevaBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double? titleSpacing;
  const SevaBar({
    super.key,
    this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.bottom,
    this.titleSpacing,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(72 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      backgroundColor: Seva.navy,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: title,
      titleSpacing: titleSpacing,
      titleTextStyle:
          context.tt.titleLarge?.copyWith(color: Colors.white, fontSize: 19),
      actions: actions,
      bottom: bottom,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: Seva.headerGradient),
        child: const Skyline(height: 96, color: Color(0x10FFFFFF)),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 8, 10),
      child: Row(children: [
        Expanded(
          child: Semantics(
              header: true,
              child: Text(title,
                  style: context.tt.titleLarge?.copyWith(fontSize: 18))),
        ),
        if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
      ]),
    );
  }
}

class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;
  const IconBadge(this.icon, {super.key, this.color, this.size = 42});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Seva.toneFor(icon);
    final hsl = HSLColor.fromColor(c);
    final deep = hsl.withLightness((hsl.lightness - .1).clamp(0.0, 1.0)).toColor();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c, deep]),
        borderRadius: BorderRadius.circular(size * .32),
        boxShadow: size >= 40
            ? [BoxShadow(color: c.withValues(alpha: .28), blurRadius: 10, offset: const Offset(0, 4))]
            : null,
      ),
      child: Icon(icon, color: Colors.white, size: size * .54),
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const Pill(this.text, {super.key, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 13, color: color), const SizedBox(width: 4)],
        Flexible(
          child: Text(text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: color)),
        ),
      ]),
    );
  }
}

/// Bottom-pinned primary action, kept above the home indicator.
class BottomAction extends StatelessWidget {
  final Widget child;
  const BottomAction({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: child),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final Widget? action;
  const EmptyState({super.key, required this.icon, required this.title, this.body, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        IconBadge(icon, size: 64),
        const SizedBox(height: 14),
        Text(title, textAlign: TextAlign.center, style: context.tt.titleMedium),
        if (body != null) ...[
          const SizedBox(height: 6),
          Text(body!,
              textAlign: TextAlign.center, style: TextStyle(color: context.cs.onSurfaceVariant)),
        ],
        if (action != null) ...[const SizedBox(height: 16), action!],
      ]),
    );
  }
}

/// Runs a labelled fake-network step, then calls [onDone].
class SimSteps extends StatefulWidget {
  final List<String> steps;
  final VoidCallback onDone;
  final Duration stepTime;
  const SimSteps(
      {super.key,
      required this.steps,
      required this.onDone,
      this.stepTime = const Duration(milliseconds: 750)});

  @override
  State<SimSteps> createState() => _SimStepsState();
}

class _SimStepsState extends State<SimSteps> {
  int i = 0;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(widget.stepTime, (timer) {
      if (i >= widget.steps.length - 1) {
        timer.cancel();
        widget.onDone();
      } else {
        setState(() => i++);
      }
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      for (var n = 0; n < widget.steps.length; n++)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [
            SizedBox(
              width: 24,
              height: 24,
              child: n < i
                  ? Icon(Icons.check_circle, color: context.cs.secondary, size: 22)
                  : n == i
                      ? const Padding(
                          padding: EdgeInsets.all(3),
                          child: CircularProgressIndicator(strokeWidth: 2.4))
                      : Icon(Icons.circle_outlined, color: context.cs.outlineVariant, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(widget.steps[n],
                  style: TextStyle(
                      fontWeight: n == i ? FontWeight.w600 : FontWeight.w400,
                      color: n > i ? context.cs.onSurfaceVariant : context.cs.onSurface)),
            ),
          ]),
        ),
    ]);
  }
}

class SuccessTick extends StatelessWidget {
  final double size;
  const SuccessTick({super.key, this.size = 76});

  @override
  Widget build(BuildContext context) {
    final still = context.watchApp.reduceMotion;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: still ? 1 : 0.4, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (_, v, c) => Transform.scale(scale: v, child: c),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: context.cs.secondary, shape: BoxShape.circle),
        child: Icon(Icons.check_rounded, color: context.cs.surface, size: size * 0.6),
      ),
    );
  }
}

void toast(String text) {
  final ctx = navigatorKey.currentContext;
  if (ctx == null) return;
  ScaffoldMessenger.of(ctx)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 2)));
}

Future<T?> push<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));

Color crowdColor(int c) => [Seva.greenDark, const Color(0xFFB57700), Seva.red][c];

class StatusChip extends StatelessWidget {
  final Application a;
  const StatusChip(this.a, {super.key});

  @override
  Widget build(BuildContext context) {
    return Pill(
      a.done ? context.tr('Completed', 'ಪೂರ್ಣಗೊಂಡಿದೆ') : context.tr('In progress', 'ಪ್ರಗತಿಯಲ್ಲಿದೆ'),
      color: a.done ? context.cs.secondary : context.cs.primary,
      icon: a.done ? Icons.check_circle : Icons.timelapse,
    );
  }
}

String sourceName(AppSource s) => switch (s) {
      AppSource.servicePlus => 'Service Plus',
      AppSource.sakala => 'Sakala',
      AppSource.token => tx('Token', 'ಟೋಕನ್'),
    };

/// Read aloud: steps through sentences. Screen readers work through Semantics.
class ReadAloudBar extends StatefulWidget {
  final String text;
  const ReadAloudBar({super.key, required this.text});

  @override
  State<ReadAloudBar> createState() => _ReadAloudBarState();
}

class _ReadAloudBarState extends State<ReadAloudBar> {
  Timer? t;
  int i = -1;
  late List<String> parts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    parts = widget.text.split(RegExp(r'(?<=[.!?])\s+'));
  }

  void toggle() {
    if (t != null) {
      t!.cancel();
      setState(() {
        t = null;
        i = -1;
      });
      return;
    }
    setState(() => i = 0);
    t = Timer.periodic(const Duration(milliseconds: 1800), (x) {
      if (i >= parts.length - 1) {
        x.cancel();
        setState(() {
          t = null;
          i = -1;
        });
      } else {
        setState(() => i++);
      }
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SevaCard(
      color: context.cs.primary.withValues(alpha: 0.08),
      child: Row(children: [
        IconButton.filledTonal(
          tooltip: context.tr('Read aloud', 'ಗಟ್ಟಿಯಾಗಿ ಓದಿ'),
          onPressed: toggle,
          icon: Icon(t == null ? Icons.volume_up_outlined : Icons.stop_rounded),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            i < 0 ? context.tr('Read this page aloud', 'ಈ ಪುಟವನ್ನು ಗಟ್ಟಿಯಾಗಿ ಓದಿ') : parts[i],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ]),
    );
  }
}


/// Places a real phone call through the device dialler.
Future<void> dial(String number) async {
  final uri = Uri(scheme: 'tel', path: number.replaceAll('-', ''));
  try {
    if (await launchUrl(uri)) return;
  } catch (_) {}
  toast(tx('Call $number from your phone', 'ನಿಮ್ಮ ಫೋನ್‌ನಿಂದ $number ಗೆ ಕರೆ ಮಾಡಿ'));
}
