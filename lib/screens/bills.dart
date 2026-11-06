import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/models.dart';
import '../data/seed.dart';
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
      appBar: AppBar(title: Text(context.tr('Bills and payments', 'ಬಿಲ್‌ಗಳು ಮತ್ತು ಪಾವತಿಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SevaCard(
          color: context.cs.primary.withValues(alpha: 0.09),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('Total due', 'ಒಟ್ಟು ಬಾಕಿ'),
                    style: TextStyle(color: context.cs.onSurfaceVariant)),
                Text(money(total), style: context.tt.headlineMedium),
              ]),
            ),
            Text(context.tr('${due.length} bills', '${due.length} ಬಿಲ್‌ಗಳು')),
          ]),
        ),
        const SizedBox(height: 12),
        for (final b in due)
          Padding(padding: const EdgeInsets.only(bottom: 8), child: _BillRow(b)),
        if (due.isEmpty)
          EmptyState(
            icon: Icons.task_alt,
            title: context.tr('All paid up', 'ಎಲ್ಲಾ ಪಾವತಿಸಲಾಗಿದೆ'),
          ),
        OutlinedButton.icon(
          onPressed: () => push(context, const AddBillScreen()),
          icon: const Icon(Icons.add),
          label: Text(context.tr('Add a bill', 'ಬಿಲ್ ಸೇರಿಸಿ')),
        ),
        if (paid.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(context.tr('Paid', 'ಪಾವತಿಸಲಾಗಿದೆ'), style: context.tt.titleLarge),
          const SizedBox(height: 8),
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
    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Expanded(child: Text(k, style: TextStyle(color: context.cs.onSurfaceVariant))),
            Flexible(
              child: Text(v,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ]),
        );
    return Scaffold(
      appBar: AppBar(title: Text(context.loc(b.provider))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: IconBadge(billIcon(b.category), size: 62)),
        const SizedBox(height: 10),
        Center(child: Text(money(b.amount), style: context.tt.headlineMedium)),
        Center(
          child: Text(context.loc(b.label), style: TextStyle(color: context.cs.onSurfaceVariant)),
        ),
        const SizedBox(height: 16),
        SevaCard(
          child: Column(children: [
            row(context.tr('Consumer number', 'ಗ್ರಾಹಕ ಸಂಖ್ಯೆ'), b.consumerNo),
            row(context.tr('Due date', 'ಕೊನೆಯ ದಿನಾಂಕ'), dateStr(b.due)),
            if (b.paid) ...[
              row(context.tr('Status', 'ಸ್ಥಿತಿ'), context.tr('Paid', 'ಪಾವತಿಸಲಾಗಿದೆ')),
              row(context.tr('Receipt', 'ರಸೀದಿ'), b.receipt!),
            ],
          ]),
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
      appBar: AppBar(title: Text(context.tr('Add a bill', 'ಬಿಲ್ ಸೇರಿಸಿ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(context.tr('Choose provider', 'ಸೇವಾ ಪೂರೈಕೆದಾರರನ್ನು ಆಯ್ಕೆಮಾಡಿ'), style: context.tt.titleMedium),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final p in billProviders)
            ChoiceChip(
              avatar: Icon(billIcon(p.category), size: 16),
              label: Text(context.loc(p.name)),
              selected: identical(p, provider),
              onSelected: (_) => setState(() => provider = p),
            ),
        ]),
        const SizedBox(height: 18),
        TextField(
          controller: c,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: context.tr('Consumer number', 'ಗ್ರಾಹಕ ಸಂಖ್ಯೆ'),
            helperText: context.tr('Any number works in this demo', 'ಈ ಡೆಮೊದಲ್ಲಿ ಯಾವುದೇ ಸಂಖ್ಯೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ'),
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
      ('upi', Icons.qr_code_2, 'UPI'),
      ('card', Icons.credit_card, context.tr('Debit or credit card', 'ಡೆಬಿಟ್ ಅಥವಾ ಕ್ರೆಡಿಟ್ ಕಾರ್ಡ್')),
      ('net', Icons.account_balance_outlined, context.tr('Net banking', 'ನೆಟ್ ಬ್ಯಾಂಕಿಂಗ್')),
    ];
    return PopScope(
      canPop: stage != 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: stage == 0,
          title: Text(context.tr('Payment', 'ಪಾವತಿ')),
          actions: const [DemoChip(), SizedBox(width: 16)],
        ),
        body: ListView(padding: const EdgeInsets.all(16), children: switch (stage) {
          0 => [
              Center(child: Text(money(widget.amount), style: context.tt.headlineMedium)),
              Center(
                child: Text(widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.cs.onSurfaceVariant)),
              ),
              const SizedBox(height: 18),
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
              const SizedBox(height: 6),
              Text(
                context.tr('Demo checkout. No money moves and no card details are collected.',
                    'ಡೆಮೊ ಪಾವತಿ. ಯಾವುದೇ ಹಣ ವರ್ಗಾವಣೆಯಾಗುವುದಿಲ್ಲ ಮತ್ತು ಕಾರ್ಡ್ ವಿವರ ಸಂಗ್ರಹಿಸುವುದಿಲ್ಲ.'),
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
