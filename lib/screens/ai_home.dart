import 'dart:async';

import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../router.dart';
import '../widgets/common.dart';
import 'assistant.dart';
import 'extras.dart';
import 'services.dart';

/// On/off switch for the AI-led home (SevaOne's answer to UMANG's "Unified
/// Intelligence" mode).
class AiToggle extends StatelessWidget {
  const AiToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    return Semantics(
      toggled: s.aiMode,
      label: context.tr('Seva AI home', 'ಸೇವಾ ಎಐ ಮುಖಪುಟ'),
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => app.set(() => app.aiMode = !app.aiMode),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: s.aiMode ? 0.22 : 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.auto_awesome, color: Seva.gold, size: 15),
            const SizedBox(width: 5),
            const Flexible(
              child: Text('Seva AI',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
            ),
            const SizedBox(width: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 34,
              height: 20,
              padding: const EdgeInsets.all(2),
              alignment: s.aiMode ? Alignment.centerRight : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: s.aiMode ? Seva.gold : Colors.white30,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Container(
                width: 16,
                height: 16,
                decoration:
                    const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class AiHome extends StatefulWidget {
  const AiHome({super.key});

  @override
  State<AiHome> createState() => _AiHomeState();
}

class _AiHomeState extends State<AiHome> {
  int i = 0;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!app.reduceMotion && mounted) setState(() => i = (i + 1) % lifeEvents.length);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final top = MediaQuery.of(context).padding.top;
    final e = lifeEvents[i];
    return Container(
      decoration: const BoxDecoration(gradient: Seva.headerGradient),
      child: Stack(children: [
        ListView(padding: EdgeInsets.fromLTRB(18, top + 10, 18, 110), children: [
          Row(children: [
            Flexible(
              child: Text('SevaOne',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.tt.titleLarge?.copyWith(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            const DemoChip(onDark: true),
            const Spacer(),
            const AiToggle(),
          ]),
          const SizedBox(height: 22),
          Text(context.tr('Just tell us your situation', 'ನಿಮ್ಮ ಪರಿಸ್ಥಿತಿ ತಿಳಿಸಿ'),
              style: context.tt.headlineMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(context.tr('We will guide you step by step.', 'ನಾವು ಹಂತ ಹಂತವಾಗಿ ಮಾರ್ಗದರ್ಶನ ನೀಡುತ್ತೇವೆ.'),
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => push(context, LifeEventDetail(e)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(e.icon, color: Seva.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(context.loc(e.title),
                          style: context.tt.titleMedium?.copyWith(color: Seva.navy)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  for (final st in e.steps.take(4))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(children: [
                        const Icon(Icons.check_circle_outline, size: 17, color: Seva.greenDark),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(context.loc(st.title),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Seva.navy, fontSize: 14)),
                        ),
                      ]),
                    ),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(context.tr('Life events', 'ಜೀವನದ ಘಟನೆಗಳು'),
              style: context.tt.titleLarge?.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final ev in lifeEvents)
              ActionChip(
                avatar: Icon(ev.icon, size: 17),
                label: Text(context.loc(ev.title)),
                onPressed: () => push(context, LifeEventDetail(ev)),
              ),
          ]),
          const SizedBox(height: 18),
          if (s.profileScore < 10)
            ProfileMeter(onDark: true, score: s.profileScore),
        ]),
        Positioned(
          left: 14,
          right: 14,
          bottom: 12,
          child: Material(
            color: Colors.white,
            elevation: 6,
            borderRadius: BorderRadius.circular(999),
            child: Row(children: [
              IconButton(
                tooltip: context.tr('Speak to Seva', 'ಸೇವಾ ಜೊತೆ ಮಾತನಾಡಿ'),
                color: Seva.blue,
                onPressed: () => openRoute('voice'),
                icon: const Icon(Icons.mic_none_rounded),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => push(context, const AskScreen()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(context.tr('Ask me anything…', 'ಏನಾದರೂ ಕೇಳಿ…'),
                        style: const TextStyle(color: Color(0xFF5F6275), fontSize: 15.5)),
                  ),
                ),
              ),
              IconButton(
                tooltip: context.tr('Ask', 'ಕೇಳಿ'),
                color: Seva.blue,
                onPressed: () => push(context, const AskScreen()),
                icon: const Icon(Icons.search),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class ProfileMeter extends StatelessWidget {
  final bool onDark;
  final int score;
  const ProfileMeter({super.key, required this.score, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final fg = onDark ? Colors.white : context.cs.onSurface;
    return Material(
      color: onDark ? Colors.white.withValues(alpha: 0.12) : context.cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openRoute('family'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            SizedBox(
              width: 46,
              height: 46,
              child: Stack(alignment: Alignment.center, children: [
                CircularProgressIndicator(
                  value: score / 10,
                  strokeWidth: 5,
                  color: Seva.gold,
                  backgroundColor: fg.withValues(alpha: 0.15),
                ),
                Text('$score/10',
                    style: TextStyle(color: fg, fontSize: 11.5, fontWeight: FontWeight.w700)),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('Complete your profile', 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಪೂರ್ಣಗೊಳಿಸಿ'),
                    style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
                Text(context.tr('Better matches, faster forms', 'ಉತ್ತಮ ಹೊಂದಾಣಿಕೆ, ವೇಗದ ಅರ್ಜಿಗಳು'),
                    style: TextStyle(color: fg, fontSize: 13)),
              ]),
            ),
            Icon(Icons.chevron_right, color: fg),
          ]),
        ),
      ),
    );
  }
}

/// Free-text "tell us what is happening" entry. Matches a life event first,
/// then the assistant, then the catalogue.
class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final c = TextEditingController();

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watchApp;
    final q = c.text.trim();
    final event = q.isEmpty ? null : matchLifeEvent(q);
    final reply = q.isEmpty ? null : think(q);
    final results = q.isEmpty ? const [] : app.searchAll(q).take(5).toList();
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Ask Seva', 'ಸೇವಾ ಕೇಳಿ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(
          controller: c,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: context.tr('e.g. I had a baby', 'ಉದಾ. ನನಗೆ ಮಗು ಜನಿಸಿದೆ'),
            prefixIcon: const Icon(Icons.auto_awesome),
          ),
        ),
        const SizedBox(height: 12),
        if (event != null)
          SevaCard(
            onTap: () => push(context, LifeEventDetail(event)),
            child: Row(children: [
              IconBadge(event.icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(context.loc(event.title), style: context.tt.titleMedium),
                  Text(context.tr('${event.steps.length} steps to follow', '${event.steps.length} ಹಂತಗಳು')),
                ]),
              ),
              const Icon(Icons.chevron_right),
            ]),
          )
        else if (reply != null)
          ChatBubble(context.loc(reply.text), mine: false, reply: reply),
        if (results.isNotEmpty) ...[
          SectionTitle(context.tr('Related services', 'ಸಂಬಂಧಿತ ಸೇವೆಗಳು')),
          const SizedBox(height: 6),
          for (final v in results)
            Padding(padding: const EdgeInsets.only(bottom: 6), child: ServiceRow(v)),
        ],
        if (q.isEmpty) ...[
          Text(context.tr('Try', 'ಪ್ರಯತ್ನಿಸಿ'), style: TextStyle(color: context.cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final e in lifeEvents)
              ActionChip(
                label: Text(context.loc(e.title)),
                onPressed: () => setState(() => c.text = context.loc(e.title)),
              ),
          ]),
        ],
      ]),
    );
  }
}
