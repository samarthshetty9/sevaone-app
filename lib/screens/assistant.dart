import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../router.dart';
import '../widgets/common.dart';

class Reply {
  final L text;
  final String? route;
  final L? action;
  const Reply(this.text, {this.route, this.action});
}

/// Keyword "brain" shared by the voice bot and live chat.
Reply think(String input) {
  final q = input.toLowerCase();
  bool any(List<String> w) => w.any(q.contains);

  if (any(['bill', 'electric', 'bescom', 'water', 'ಬಿಲ್', 'ವಿದ್ಯುತ್', 'ನೀರು'])) {
    final due = app.bills.where((b) => !b.paid).toList();
    return Reply(
      due.isEmpty
          ? const L('You have no bills due right now.', 'ಸದ್ಯಕ್ಕೆ ನಿಮ್ಮ ಯಾವುದೇ ಬಿಲ್ ಬಾಕಿ ಇಲ್ಲ.')
          : L('You have ${due.length} bills due. The next is ${due.first.provider.en} for ${money(due.first.amount)}.',
              'ನಿಮ್ಮ ${due.length} ಬಿಲ್‌ಗಳು ಬಾಕಿ ಇವೆ. ಮುಂದಿನದು ${due.first.provider.kn} ${money(due.first.amount)}.'),
      route: 'bills',
      action: const L('Open bills', 'ಬಿಲ್‌ಗಳನ್ನು ತೆರೆಯಿರಿ'),
    );
  }
  if (any(['status', 'track', 'application', 'ಸ್ಥಿತಿ', 'ಅರ್ಜಿ', 'ಟ್ರ್ಯಾಕ್'])) {
    final a = app.applications.where((a) => !a.done).toList();
    return Reply(
      a.isEmpty
          ? const L('All your applications are complete.', 'ನಿಮ್ಮ ಎಲ್ಲಾ ಅರ್ಜಿಗಳು ಪೂರ್ಣಗೊಂಡಿವೆ.')
          : L('Your ${a.first.service.en} is at: ${a.first.stages[a.first.current].title.en}.',
              'ನಿಮ್ಮ ${a.first.service.kn} ಈ ಹಂತದಲ್ಲಿದೆ: ${a.first.stages[a.first.current].title.kn}.'),
      route: 'track',
      action: const L('Open tracker', 'ಟ್ರ್ಯಾಕರ್ ತೆರೆಯಿರಿ'),
    );
  }
  if (any(['income', 'certificate', 'ಆದಾಯ', 'ಪ್ರಮಾಣಪತ್ರ'])) {
    return const Reply(
      L('The Income Certificate costs ₹40 and takes up to 21 days. Your documents can fill in from DigiLocker.',
          'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರದ ಶುಲ್ಕ ₹40, 21 ದಿನಗಳವರೆಗೆ ಬೇಕಾಗುತ್ತದೆ. ದಾಖಲೆಗಳು ಡಿಜಿಲಾಕರ್‌ನಿಂದ ಭರ್ತಿಯಾಗಬಹುದು.'),
      route: 'services',
      action: L('See services', 'ಸೇವೆಗಳನ್ನು ನೋಡಿ'),
    );
  }
  if (any(['scheme', 'pension', 'eligible', 'scholarship', 'ಯೋಜನೆ', 'ಪಿಂಚಣಿ', 'ಅರ್ಹ'])) {
    return const Reply(
      L('I can find schemes that match you. It takes six quick questions.',
          'ನಿಮಗೆ ಹೊಂದುವ ಯೋಜನೆಗಳನ್ನು ಹುಡುಕಬಲ್ಲೆ. ಆರು ಸಣ್ಣ ಪ್ರಶ್ನೆಗಳು ಸಾಕು.'),
      route: 'eligibility',
      action: L('Find my schemes', 'ನನ್ನ ಯೋಜನೆಗಳನ್ನು ಹುಡುಕಿ'),
    );
  }
  if (any(['centre', 'center', 'grama', 'near', 'ಕೇಂದ್ರ', 'ಗ್ರಾಮ'])) {
    return Reply(
      L('The nearest centre is ${centres.first.name.en}, ${centres.first.km} km away.',
          'ಹತ್ತಿರದ ಕೇಂದ್ರ ${centres.first.name.kn}, ${centres.first.km} ಕಿ.ಮೀ ದೂರದಲ್ಲಿದೆ.'),
      route: 'centres',
      action: const L('Show on map', 'ನಕ್ಷೆಯಲ್ಲಿ ತೋರಿಸಿ'),
    );
  }
  if (any(['weather', 'rain', 'aqi', 'air', 'ಹವಾಮಾನ', 'ಮಳೆ', 'ಗಾಳಿ'])) {
    final w = weatherByDistrict[app.weatherDistrict]!;
    return Reply(
      L('It is ${w.temp} degrees now with AQI ${w.aqi}.', 'ಈಗ ${w.temp} ಡಿಗ್ರಿ, ಎಕ್ಯುಐ ${w.aqi}.'),
      route: 'weather',
      action: const L('See forecast', 'ಮುನ್ಸೂಚನೆ ನೋಡಿ'),
    );
  }
  if (any(['grievance', 'complaint', 'ಕುಂದುಕೊರತೆ', 'ದೂರು'])) {
    return const Reply(
      L('I can register your grievance with iPGRS.', 'ನಿಮ್ಮ ಕುಂದುಕೊರತೆಯನ್ನು ಐಪಿಜಿಆರ್‌ಎಸ್‌ನಲ್ಲಿ ದಾಖಲಿಸಬಲ್ಲೆ.'),
      route: 'grievance',
      action: L('File a grievance', 'ಕುಂದುಕೊರತೆ ಸಲ್ಲಿಸಿ'),
    );
  }
  if (any(['document', 'digilocker', 'aadhaar', 'pan', 'ದಾಖಲೆ', 'ಡಿಜಿಲಾಕರ್', 'ಆಧಾರ್'])) {
    return const Reply(
      L('Your documents live in the Documents tab, linked through DigiLocker.',
          'ನಿಮ್ಮ ದಾಖಲೆಗಳು ಡಿಜಿಲಾಕರ್ ಮೂಲಕ ದಾಖಲೆಗಳ ವಿಭಾಗದಲ್ಲಿವೆ.'),
      route: 'documents',
      action: L('Open documents', 'ದಾಖಲೆಗಳನ್ನು ತೆರೆಯಿರಿ'),
    );
  }
  return const Reply(L(
      'I can help with bills, application status, schemes, centres and weather. Which one do you need?',
      'ಬಿಲ್‌ಗಳು, ಅರ್ಜಿ ಸ್ಥಿತಿ, ಯೋಜನೆಗಳು, ಕೇಂದ್ರಗಳು ಮತ್ತು ಹವಾಮಾನದಲ್ಲಿ ಸಹಾಯ ಮಾಡಬಲ್ಲೆ. ನಿಮಗೆ ಯಾವುದು ಬೇಕು?'));
}

List<L> get _prompts => const [
      L('What is my application status?', 'ನನ್ನ ಅರ್ಜಿ ಸ್ಥಿತಿ ಏನು?'),
      L('Do I have any bills due?', 'ನನ್ನ ಬಿಲ್ ಬಾಕಿ ಇದೆಯೇ?'),
      L('Which schemes am I eligible for?', 'ನಾನು ಯಾವ ಯೋಜನೆಗಳಿಗೆ ಅರ್ಹ?'),
      L('Where is the nearest centre?', 'ಹತ್ತಿರದ ಕೇಂದ್ರ ಎಲ್ಲಿದೆ?'),
    ];

/// Animated bars standing in for live microphone input.
class Waveform extends StatefulWidget {
  final bool active;
  final Color color;
  const Waveform({super.key, required this.active, required this.color});

  @override
  State<Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<Waveform> with SingleTickerProviderStateMixin {
  late final AnimationController c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = context.watchApp.reduceMotion;
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: c,
        builder: (_, _) => Row(mainAxisSize: MainAxisSize.min, children: [
          for (var i = 0; i < 11; i++)
            Container(
              width: 5,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              height: widget.active && !still
                  ? 10 + 34 * (0.5 + 0.5 * sin(c.value * 2 * pi + i * 0.9)).abs()
                  : 8,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ]),
      ),
    );
  }
}

/// Feature 6: voice-based discovery. Picks a spoken phrase; returns it as text.
Future<String?> showVoiceSearch(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (_) => const _VoiceSheet(),
  );
}

class _VoiceSheet extends StatefulWidget {
  const _VoiceSheet();

  @override
  State<_VoiceSheet> createState() => _VoiceSheetState();
}

class _VoiceSheetState extends State<_VoiceSheet> {
  String heard = '';
  Timer? t;

  void say(String phrase) {
    t?.cancel();
    var n = 0;
    t = Timer.periodic(const Duration(milliseconds: 45), (x) {
      n++;
      if (n >= phrase.length) {
        x.cancel();
        setState(() => heard = phrase);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) Navigator.of(context).pop(phrase);
        });
      } else {
        setState(() => heard = phrase.substring(0, n));
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
    final phrases = [
      context.tr('Income certificate', 'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರ'),
      context.tr('Old age pension', 'ವೃದ್ಧಾಪ್ಯ ವೇತನ'),
      context.tr('Ration card', 'ಪಡಿತರ ಚೀಟಿ'),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(heard.isEmpty ? context.tr('Listening…', 'ಆಲಿಸಲಾಗುತ್ತಿದೆ…') : heard,
              textAlign: TextAlign.center, style: context.tt.titleLarge),
          const SizedBox(height: 18),
          SizedBox(height: 46, child: Waveform(active: true, color: context.cs.primary)),
          const SizedBox(height: 18),
          Text(context.tr('Demo: tap what you would say', 'ಡೆಮೊ: ನೀವು ಹೇಳುವುದನ್ನು ಟ್ಯಾಪ್ ಮಾಡಿ'),
              style: TextStyle(color: context.cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
            for (final p in phrases) ActionChip(label: Text(p), onPressed: () => say(p)),
          ]),
        ]),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool mine;
  final Reply? reply;
  _Msg(this.text, this.mine, {this.reply});
}

/// Feature 3: voice bot.
class VoiceBotScreen extends StatefulWidget {
  const VoiceBotScreen({super.key});

  @override
  State<VoiceBotScreen> createState() => _VoiceBotScreenState();
}

class _VoiceBotScreenState extends State<VoiceBotScreen> {
  String state = 'idle'; // idle | listening | thinking | speaking
  final msgs = <_Msg>[];
  final scroll = ScrollController();

  Future<void> ask(String phrase) async {
    setState(() => state = 'listening');
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() {
      msgs.add(_Msg(phrase, true));
      state = 'thinking';
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final r = think(phrase);
    setState(() {
      msgs.add(_Msg(app.l(r.text), false, reply: r));
      state = 'speaking';
    });
    _down();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => state = 'idle');
  }

  void _down() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scroll.hasClients) {
          scroll.animateTo(scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
        }
      });

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = switch (state) {
      'listening' => context.tr('Listening…', 'ಆಲಿಸಲಾಗುತ್ತಿದೆ…'),
      'thinking' => context.tr('Thinking…', 'ಯೋಚಿಸಲಾಗುತ್ತಿದೆ…'),
      'speaking' => context.tr('Speaking…', 'ಮಾತನಾಡಲಾಗುತ್ತಿದೆ…'),
      _ => context.tr('How can I help?', 'ನಾನು ಹೇಗೆ ಸಹಾಯ ಮಾಡಲಿ?'),
    };
    return Scaffold(
      backgroundColor: Seva.navy,
      appBar: AppBar(
        backgroundColor: Seva.navy,
        foregroundColor: Colors.white,
        titleTextStyle: context.tt.titleLarge?.copyWith(color: Colors.white, fontSize: 18),
        title: Text(context.tr('Seva voice bot', 'ಸೇವಾ ಧ್ವನಿ ಬಾಟ್')),
        actions: const [DemoChip(onDark: true), SizedBox(width: 16)],
      ),
      body: Column(children: [
        Expanded(
          child: ListView(controller: scroll, padding: const EdgeInsets.all(16), children: [
            if (msgs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  context.tr('Speak in Kannada or English. Ask about bills, schemes or your applications.',
                      'ಕನ್ನಡ ಅಥವಾ ಇಂಗ್ಲಿಷ್‌ನಲ್ಲಿ ಮಾತನಾಡಿ. ಬಿಲ್‌ಗಳು, ಯೋಜನೆಗಳು ಅಥವಾ ಅರ್ಜಿಗಳ ಬಗ್ಗೆ ಕೇಳಿ.'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            for (final m in msgs) ChatBubble(m.text, mine: m.mine, reply: m.reply, onDark: true),
          ]),
        ),
        Text(label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: Waveform(
            active: state == 'listening' || state == 'speaking',
            color: state == 'speaking' ? Seva.gold : Seva.green,
          ),
        ),
        const SizedBox(height: 12),
        SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              children: [
                for (final p in _prompts)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      avatar: const Icon(Icons.mic, size: 16),
                      label: Text(context.loc(p)),
                      onPressed: state == 'idle' ? () => ask(context.loc(p)) : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool mine;
  final Reply? reply;
  final bool onDark;
  const ChatBubble(this.text,
      {super.key, required this.mine, this.reply, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final bg = mine
        ? (onDark ? Seva.blue : context.cs.primary)
        : (onDark ? const Color(0xFF2B2D52) : context.cs.surfaceContainerHighest);
    final fg = mine || onDark ? (onDark ? Colors.white : context.cs.onPrimary) : context.cs.onSurface;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(text, style: TextStyle(color: fg, height: 1.35)),
          if (reply?.route != null) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: fg,
                side: BorderSide(color: fg.withValues(alpha: 0.5)),
                minimumSize: const Size(40, 40),
              ),
              onPressed: () => openRoute(reply!.route!),
              child: Text(context.loc(reply!.action!)),
            ),
          ],
        ]),
      ),
    );
  }
}

/// Feature 16: live chat with a simulated agent.
class LiveChatScreen extends StatefulWidget {
  final bool whatsapp;
  const LiveChatScreen({super.key, this.whatsapp = false});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final msgs = <_Msg>[];
  final c = TextEditingController();
  final scroll = ScrollController();
  bool connected = false;
  bool typing = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        connected = true;
        msgs.add(_Msg(
            tx('Namaskara, this is Kavya from SevaOne support. How can I help you?',
                'ನಮಸ್ಕಾರ, ನಾನು ಸೇವಾಒನ್ ಸಹಾಯ ಕೇಂದ್ರದಿಂದ ಕಾವ್ಯ. ನಾನು ಹೇಗೆ ಸಹಾಯ ಮಾಡಲಿ?'),
            false));
      });
    });
  }

  Future<void> send(String t) async {
    if (t.trim().isEmpty || !connected) return;
    c.clear();
    setState(() {
      msgs.add(_Msg(t.trim(), true));
      typing = true;
    });
    _down();
    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;
    final r = think(t);
    setState(() {
      typing = false;
      msgs.add(_Msg(app.l(r.text), false, reply: r));
    });
    _down();
  }

  void _down() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scroll.hasClients) {
          scroll.animateTo(scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
        }
      });

  @override
  void dispose() {
    c.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.whatsapp
              ? context.tr('SevaOne on WhatsApp', 'ವಾಟ್ಸಾಪ್‌ನಲ್ಲಿ ಸೇವಾಒನ್')
              : context.tr('Live chat', 'ಲೈವ್ ಚಾಟ್')),
          Text(
            connected
                ? (typing
                    ? context.tr('Kavya is typing…', 'ಕಾವ್ಯ ಟೈಪ್ ಮಾಡುತ್ತಿದ್ದಾರೆ…')
                    : context.tr('Kavya · Online', 'ಕಾವ್ಯ · ಆನ್‌ಲೈನ್'))
                : context.tr('Connecting you to an agent…', 'ಸಹಾಯಕರನ್ನು ಸಂಪರ್ಕಿಸಲಾಗುತ್ತಿದೆ…'),
            style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: context.cs.onSurfaceVariant),
          ),
        ]),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: Column(children: [
        Expanded(
          child: ListView(controller: scroll, padding: const EdgeInsets.all(16), children: [
            for (final m in msgs) ChatBubble(m.text, mine: m.mine, reply: m.reply),
          ]),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: c,
                  onSubmitted: send,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: context.tr('Type your message', 'ನಿಮ್ಮ ಸಂದೇಶ ಟೈಪ್ ಮಾಡಿ'),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                tooltip: context.tr('Send', 'ಕಳುಹಿಸಿ'),
                onPressed: () => send(c.text),
                icon: const Icon(Icons.send_rounded),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
