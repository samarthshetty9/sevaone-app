import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

IconData billIcon(String c) => switch (c) {
      'electricity' => Icons.bolt_outlined,
      'water' => Icons.water_drop_outlined,
      'property' => Icons.home_work_outlined,
      _ => Icons.receipt_long_outlined,
    };

/// Feature 9: integrated utility payments.
class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final due = s.bills.where((b) => !b.paid).toList();
    final paid = s.bills.where((b) => b.paid).toList();
    final total = due.fold<int>(0, (a, b) => a + b.amount);
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Bills and payments', 'ಬಿಲ್‌ಗಳು ಮತ್ತು ಪಾವತಿಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          colors: const [Color(0xFFB8501F), Color(0xFFE8743B)],
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('Total due', 'ಒಟ್ಟು ಬಾಕಿ'),
                    style: const TextStyle(color: Colors.white70)),
                Text(money(total),
                    style: context.tt.headlineMedium?.copyWith(color: Colors.white, fontSize: 32)),
                Text(context.tr('${due.length} bills', '${due.length} ಬಿಲ್‌ಗಳು'),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
            const IconArt(Icons.receipt_long, size: 80),
          ]),
        ),
        const SizedBox(height: 14),
        Row(children: [
          for (final (i, label, cat) in [
            (Icons.bolt, context.tr('Electricity', 'ವಿದ್ಯುತ್'), 0),
            (Icons.water_drop, context.tr('Water', 'ನೀರು'), 1),
            (Icons.home_work, context.tr('Property', 'ಆಸ್ತಿ'), 2),
            (Icons.add, context.tr('Add new', 'ಹೊಸದು'), 3),
          ])
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => push(context, const AddBillScreen()),
                child: Column(children: [
                  IconBadge(i, size: 48, color: Seva.tones[cat * 2 + 1]),
                  const SizedBox(height: 6),
                  Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
        ]),
        const SizedBox(height: 18),
        if (due.isNotEmpty) ...[
          Text(context.tr('Upcoming', 'ಮುಂಬರುವವು'), style: context.tt.titleLarge?.copyWith(fontSize: 18)),
          const SizedBox(height: 10),
        ],
        for (final b in due)
          Padding(padding: const EdgeInsets.only(bottom: 8), child: _BillRow(b)),
        if (due.isEmpty)
          EmptyState(
            icon: Icons.task_alt,
            title: context.tr('All paid up', 'ಎಲ್ಲಾ ಪಾವತಿಸಲಾಗಿದೆ'),
          ),
        if (paid.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(context.tr('Paid', 'ಪಾವತಿಸಲಾಗಿದೆ'), style: context.tt.titleLarge?.copyWith(fontSize: 18)),
          const SizedBox(height: 10),
          for (final b in paid)
            Padding(padding: const EdgeInsets.only(bottom: 8), child: _BillRow(b)),
        ],
      ]),
    );
  }
}

class _BillRow extends StatelessWidget {
  final Bill b;
  const _BillRow(this.b);

  @override
  Widget build(BuildContext context) {
    return SevaCard(
      onTap: () => push(context, BillDetail(b)),
      child: Row(children: [
        IconBadge(billIcon(b.category)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.loc(b.provider), style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              b.paid
                  ? context.tr('Paid ${dateStr(b.paidOn!)}', '${dateStr(b.paidOn!)} ರಂದು ಪಾವತಿಸಲಾಗಿದೆ')
                  : context.tr('Due ${dateStr(b.due)}', '${dateStr(b.due)} ಒಳಗೆ ಪಾವತಿಸಿ'),
              style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant),
            ),
          ]),
        ),
        Text(money(b.amount), style: context.tt.titleMedium),
      ]),
    );
  }
}

class BillDetail extends StatelessWidget {
  final Bill b;
  const BillDetail(this.b, {super.key});

  @override
  Widget build(BuildContext context) {
    context.watchApp;
    const months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
    final seed = b.consumerNo.codeUnits.fold<int>(0, (a, c) => a + c);
    final history = [
      for (var i = 5; i > 0; i--) (b.amount * (0.72 + ((seed * i) % 38) / 100)).round(),
      b.amount,
    ];
    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [
            Expanded(child: Text(k, style: TextStyle(color: context.cs.onSurfaceVariant))),
            Flexible(
              child: Text(v,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ]),
        );
    final days = b.due.difference(DateTime.now()).inDays + 1;
    return Scaffold(
      appBar: SevaBar(title: Text(context.loc(b.provider))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.loc(b.label), style: const TextStyle(color: Colors.white70)),
                Text(money(b.amount),
                    style: context.tt.headlineMedium?.copyWith(color: Colors.white, fontSize: 32)),
                const SizedBox(height: 4),
                Pill(
                  b.paid
                      ? context.tr('Paid', 'ಪಾವತಿಸಲಾಗಿದೆ')
                      : context.tr('Due in $days days', '$days ದಿನಗಳಲ್ಲಿ ಪಾವತಿಸಬೇಕು'),
                  color: Colors.white,
                ),
              ]),
            ),
            IconArt(billIcon(b.category), size: 80),
          ]),
        ),
        const SizedBox(height: 12),
        SevaCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('Last 6 bills', 'ಕೊನೆಯ 6 ಬಿಲ್‌ಗಳು'), style: context.tt.titleMedium),
            const SizedBox(height: 10),
            MiniBars(values: history, labels: months, color: context.cs.primary),
          ]),
        ),
        const SizedBox(height: 12),
        SevaCard(
          child: Column(children: [
            row(context.tr('Consumer number', 'ಗ್ರಾಹಕ ಸಂಖ್ಯೆ'), b.consumerNo),
            row(context.tr('Bill date', 'ಬಿಲ್ ದಿನಾಂಕ'),
                dateStr(b.due.subtract(const Duration(days: 15)))),
            row(context.tr('Due date', 'ಕೊನೆಯ ದಿನಾಂಕ'), dateStr(b.due)),
            if (b.paid) row(context.tr('Receipt', 'ರಸೀದಿ'), b.receipt!),
          ]),
        ),
        const SizedBox(height: 12),
        SevaCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.tr('Remind me before the due date', 'ಕೊನೆಯ ದಿನಾಂಕಕ್ಕೆ ಮೊದಲು ನೆನಪಿಸಿ'),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            value: app.pushPrefs['bill']!,
            onChanged: (v) => app.set(() => app.pushPrefs['bill'] = v),
          ),
        ),
      ]),
      bottomNavigationBar: b.paid
          ? null
          : BottomAction(
              child: FilledButton(
                onPressed: () => push(
                  context,
                  PaymentScreen(
                    title: context.loc(b.provider),
                    amount: b.amount,
                    onPaid: () => app.payBill(b),
                  ),
                ),
                child: Text(context.tr('Pay ${money(b.amount)}', '${money(b.amount)} ಪಾವತಿಸಿ')),
              ),
            ),
    );
  }
}

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  BillProvider provider = billProviders.first;
  final c = TextEditingController();
  bool busy = false;

  Future<void> fetch() async {
    setState(() => busy = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final b = app.addBill(provider, c.text.trim());
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BillDetail(b)));
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Add a bill', 'ಬಿಲ್ ಸೇರಿಸಿ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        for (final (cat, title) in [
          ('electricity', context.tr('Electricity', 'ವಿದ್ಯುತ್')),
          ('water', context.tr('Water', 'ನೀರು')),
          ('property', context.tr('Property tax', 'ಆಸ್ತಿ ತೆರಿಗೆ')),
        ]) ...[
          Row(children: [
            IconBadge(billIcon(cat), size: 30),
            const SizedBox(width: 8),
            Text(title, style: context.tt.titleMedium),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final p in billProviders.where((p) => p.category == cat))
              ChoiceChip(
                label: Text(context.loc(p.name)),
                selected: identical(p, provider),
                onSelected: (_) => setState(() => provider = p),
              ),
          ]),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: c,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: context.tr('Consumer number', 'ಗ್ರಾಹಕ ಸಂಖ್ಯೆ'),
            helperText: context.tr('Shown on your latest bill', 'ನಿಮ್ಮ ಇತ್ತೀಚಿನ ಬಿಲ್‌ನಲ್ಲಿ ಇದೆ'),
          ),
        ),
      ]),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: c.text.trim().length >= 4 && !busy ? fetch : null,
          child: busy
              ? const SizedBox(
                  width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4))
              : Text(context.tr('Fetch bill', 'ಬಿಲ್ ಪಡೆಯಿರಿ')),
        ),
      ),
    );
  }
}

/// Shared simulated checkout. Pops with `true` when "paid". No real payment
/// method is asked for or accepted.
class PaymentScreen extends StatefulWidget {
  final String title;
  final int amount;
  final VoidCallback onPaid;
  const PaymentScreen(
      {super.key, required this.title, required this.amount, required this.onPaid});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String method = 'upi';
  int stage = 0; // 0 choose, 1 processing, 2 done

  @override
  Widget build(BuildContext context) {
    final methods = <(String, IconData, String)>[
      ('upi', Icons.qr_code_2, context.tr('UPI apps', 'ಯುಪಿಐ ಆ್ಯಪ್‌ಗಳು')),
      ('card', Icons.credit_card, context.tr('Debit or credit card', 'ಡೆಬಿಟ್ ಅಥವಾ ಕ್ರೆಡಿಟ್ ಕಾರ್ಡ್')),
      ('net', Icons.account_balance_outlined, context.tr('Net banking', 'ನೆಟ್ ಬ್ಯಾಂಕಿಂಗ್')),
    ];
    return PopScope(
      canPop: stage != 1,
      child: Scaffold(
        appBar: SevaBar(
          automaticallyImplyLeading: stage == 0,
          title: Text(context.tr('Payment', 'ಪಾವತಿ')),
        ),
        body: ListView(padding: const EdgeInsets.all(16), children: switch (stage) {
          0 => [
              GlowPanel(
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(context.tr('Paying', 'ಪಾವತಿ'), style: const TextStyle(color: Colors.white70)),
                      Text(money(widget.amount),
                          style: context.tt.headlineMedium?.copyWith(color: Colors.white, fontSize: 32)),
                      Text(widget.title, style: const TextStyle(color: Colors.white)),
                    ]),
                  ),
                  const IconArt(Icons.lock, size: 74),
                ]),
              ),
              const SizedBox(height: 18),
              Text(context.tr('Choose how to pay', 'ಪಾವತಿ ವಿಧಾನ ಆಯ್ಕೆಮಾಡಿ'),
                  style: context.tt.titleLarge?.copyWith(fontSize: 18)),
              const SizedBox(height: 10),
              for (final (id, icon, label) in methods)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SevaCard(
                    onTap: () => setState(() => method = id),
                    semanticLabel: label,
                    child: Row(children: [
                      IconBadge(icon, size: 38),
                      const SizedBox(width: 12),
                      Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
                      Icon(method == id ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: method == id ? context.cs.primary : context.cs.onSurfaceVariant),
                    ]),
                  ),
                ),
              const SizedBox(height: 8),
              SevaCard(
                child: Column(children: [
                  for (final (k, v) in [
                    (context.tr('Amount', 'ಮೊತ್ತ'), money(widget.amount)),
                    (context.tr('Convenience fee', 'ಅನುಕೂಲ ಶುಲ್ಕ'), context.tr('Free', 'ಉಚಿತ')),
                    (context.tr('You pay', 'ನೀವು ಪಾವತಿಸುವುದು'), money(widget.amount)),
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(children: [
                        Expanded(child: Text(k, style: TextStyle(color: context.cs.onSurfaceVariant))),
                        Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                    ),
                ]),
              ),
              const SizedBox(height: 12),
              Text(
                context.tr('Your receipt will be sent by SMS and saved in Transaction history.',
                    'ರಸೀದಿಯನ್ನು ಎಸ್‌ಎಂಎಸ್ ಮೂಲಕ ಕಳುಹಿಸಲಾಗುತ್ತದೆ ಮತ್ತು ವಹಿವಾಟು ಇತಿಹಾಸದಲ್ಲಿ ಉಳಿಸಲಾಗುತ್ತದೆ.'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant),
              ),
            ],
          1 => [
              const SizedBox(height: 30),
              SevaCard(
                child: SimSteps(
                  steps: [
                    context.tr('Contacting payment gateway', 'ಪಾವತಿ ಗೇಟ್‌ವೇ ಸಂಪರ್ಕಿಸಲಾಗುತ್ತಿದೆ'),
                    context.tr('Confirming payment', 'ಪಾವತಿ ದೃಢೀಕರಿಸಲಾಗುತ್ತಿದೆ'),
                    context.tr('Issuing receipt', 'ರಸೀದಿ ನೀಡಲಾಗುತ್ತಿದೆ'),
                  ],
                  onDone: () {
                    widget.onPaid();
                    app.addTxn(widget.title, widget.amount);
                    setState(() => stage = 2);
                  },
                ),
              ),
            ],
          _ => [
              const SizedBox(height: 40),
              const Center(child: SuccessTick()),
              const SizedBox(height: 16),
              Text(context.tr('Payment successful', 'ಪಾವತಿ ಯಶಸ್ವಿಯಾಗಿದೆ'),
                  textAlign: TextAlign.center, style: context.tt.headlineSmall),
              const SizedBox(height: 4),
              Text(money(widget.amount),
                  textAlign: TextAlign.center, style: context.tt.titleLarge),
            ],
        }),
        bottomNavigationBar: stage == 1
            ? null
            : BottomAction(
                child: FilledButton(
                  onPressed: () => stage == 0
                      ? setState(() => stage = 1)
                      : Navigator.of(context).pop(true),
                  child: Text(stage == 0
                      ? context.tr('Pay ${money(widget.amount)}', '${money(widget.amount)} ಪಾವತಿಸಿ')
                      : context.tr('Done', 'ಮುಗಿಯಿತು')),
                ),
              ),
      ),
    );
  }
}
