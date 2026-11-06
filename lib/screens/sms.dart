import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/seed.dart';
import '../widgets/common.dart';

/// Feature 5: SMS access. Shows what a citizen on a basic phone would see; the
/// short code is a placeholder (a real one needs DLT registration).
class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  static const shortCode = '56XXX';
  final c = TextEditingController();
  final scroll = ScrollController();
  final msgs = <(String, bool)>[];

  @override
  void initState() {
    super.initState();
    msgs.add((_help(), false));
  }

  String _help() => tx(
      'SEVAONE commands:\nSTATUS <number>\nBILL\nCENTRE\nSCHEME\nHELP',
      'ಸೇವಾಒನ್ ಆಜ್ಞೆಗಳು:\nSTATUS <ಸಂಖ್ಯೆ>\nBILL\nCENTRE\nSCHEME\nHELP');

  String answer(String input) {
    final parts = input.trim().split(RegExp(r'\s+'));
    final cmd = parts.first.toUpperCase();
    switch (cmd) {
      case 'STATUS':
        final id = parts.length > 1 ? parts[1] : app.applications.first.id;
        final a = app.findApplication(id);
        if (a == null) {
          return tx('No record for $id. Check the number.', '$id ಗೆ ದಾಖಲೆ ಇಲ್ಲ. ಸಂಖ್ಯೆ ಪರಿಶೀಲಿಸಿ.');
        }
        return '${a.id}: ${app.l(a.service)} - ${app.l(a.stages[a.current].title)}';
      case 'BILL':
        final due = app.bills.where((b) => !b.paid).toList();
        if (due.isEmpty) return tx('No bills due.', 'ಯಾವುದೇ ಬಿಲ್ ಬಾಕಿ ಇಲ್ಲ.');
        return due.map((b) => '${app.l(b.provider)} ${money(b.amount)}, ${dateStr(b.due)}').join('\n');
      case 'CENTRE':
        final n = centres.first;
        return '${app.l(n.name)}\n${app.l(n.address)}\n${n.hours}';
      case 'SCHEME':
        return tx('Reply with AGE and INCOME, or call 1902. Top match: ${schemes.first.name.en}.',
            'ವಯಸ್ಸು ಮತ್ತು ಆದಾಯ ಕಳುಹಿಸಿ, ಅಥವಾ 1902ಗೆ ಕರೆ ಮಾಡಿ. ಪ್ರಮುಖ ಯೋಜನೆ: ${schemes.first.name.kn}.');
      case 'HELP':
        return _help();
      default:
        return tx('Not understood. Send HELP for commands.', 'ಅರ್ಥವಾಗಲಿಲ್ಲ. ಆಜ್ಞೆಗಳಿಗಾಗಿ HELP ಕಳುಹಿಸಿ.');
    }
  }

  Future<void> send(String t) async {
    if (t.trim().isEmpty) return;
    c.clear();
    setState(() => msgs.add((t.trim(), true)));
    _down();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => msgs.add((answer(t), false)));
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
    final quick = ['STATUS KAR-REV-2026-104512', 'BILL', 'CENTRE', 'SCHEME', 'HELP'];
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(context.tr('SMS services', 'ಎಸ್‌ಎಂಎಸ್ ಸೇವೆಗಳು')),
          Text(context.tr('To $shortCode · works on any phone', '$shortCode ಗೆ · ಯಾವುದೇ ಫೋನ್‌ನಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ'),
              style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: context.cs.onSurfaceVariant)),
        ]),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            controller: scroll,
            padding: const EdgeInsets.all(16),
            itemCount: msgs.length,
            itemBuilder: (_, i) {
              final (t, mine) = msgs[i];
              return Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: mine ? context.cs.secondary : context.cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(t,
                      style: TextStyle(
                          color: mine ? context.cs.surface : context.cs.onSurface, height: 1.35)),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final q in quick)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(label: Text(q), onPressed: () => send(q)),
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: c,
                  onSubmitted: send,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: context.tr('Type a command', 'ಆಜ್ಞೆ ಟೈಪ್ ಮಾಡಿ'),
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
