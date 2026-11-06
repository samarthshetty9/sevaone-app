import 'dart:math';

import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../widgets/common.dart';
import 'services.dart';

class EventStep {
  final L title;
  final String? code; // catalogue code, when the step is an in-app service
  const EventStep(this.title, [this.code]);
}

class LifeEvent {
  final String id;
  final L title;
  final L intro;
  final IconData icon;
  final List<EventStep> steps;
  final List<String> docs;
  final List<String> keywords;
  const LifeEvent(this.id, this.title, this.intro, this.icon, this.steps, this.docs, this.keywords);
}

const lifeEvents = [
  LifeEvent('baby', L('I had a baby', 'ನನಗೆ ಮಗು ಜನಿಸಿದೆ'),
      L('Register the birth and claim maternity support.', 'ಜನನ ನೋಂದಾಯಿಸಿ ಮತ್ತು ಹೆರಿಗೆ ನೆರವು ಪಡೆಯಿರಿ.'),
      Icons.child_friendly_outlined,
      [
        EventStep(L('Register the birth', 'ಜನನ ನೋಂದಾಯಿಸಿ'), 'SVC010'),
        EventStep(L('Get the birth certificate', 'ಜನನ ಪ್ರಮಾಣಪತ್ರ ಪಡೆಯಿರಿ'), 'SVC010'),
        EventStep(L('Enrol the baby for Aadhaar', 'ಮಗುವನ್ನು ಆಧಾರ್‌ಗೆ ನೋಂದಾಯಿಸಿ')),
        EventStep(L('Apply for maternity benefit', 'ಹೆರಿಗೆ ಸೌಲಭ್ಯಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'), 'SCH8200'),
      ],
      ['aadhaar'],
      ['baby', 'birth', 'born', 'pregnan', 'ಮಗು', 'ಜನನ']),
  LifeEvent('married', L('I got married', 'ನನಗೆ ಮದುವೆಯಾಗಿದೆ'),
      L('Register your marriage and update your records.', 'ವಿವಾಹ ನೋಂದಾಯಿಸಿ ಮತ್ತು ದಾಖಲೆಗಳನ್ನು ನವೀಕರಿಸಿ.'),
      Icons.favorite_border,
      [
        EventStep(L('Register the marriage', 'ವಿವಾಹ ನೋಂದಾಯಿಸಿ'), 'SVC011'),
        EventStep(L('Update your address', 'ನಿಮ್ಮ ವಿಳಾಸ ನವೀಕರಿಸಿ'), 'SVC003'),
        EventStep(L('Add your spouse to the ration card', 'ಪಡಿತರ ಚೀಟಿಗೆ ಸಂಗಾತಿಯನ್ನು ಸೇರಿಸಿ'), 'SVC040'),
      ],
      ['aadhaar', 'pan'],
      ['marri', 'wedding', 'spouse', 'ಮದುವೆ', 'ವಿವಾಹ']),
  LifeEvent('moved', L('I moved cities', 'ನಾನು ಊರು ಬದಲಿಸಿದೆ'),
      L('Update your address across services.', 'ಎಲ್ಲಾ ಸೇವೆಗಳಲ್ಲಿ ನಿಮ್ಮ ವಿಳಾಸ ನವೀಕರಿಸಿ.'),
      Icons.home_work_outlined,
      [
        EventStep(L('Get a residence certificate', 'ವಾಸಸ್ಥಳ ಪ್ರಮಾಣಪತ್ರ ಪಡೆಯಿರಿ'), 'SVC003'),
        EventStep(L('Transfer your ration card', 'ಪಡಿತರ ಚೀಟಿ ವರ್ಗಾಯಿಸಿ'), 'SVC040'),
        EventStep(L('Update your driving licence', 'ಚಾಲನಾ ಪರವಾನಗಿ ನವೀಕರಿಸಿ'), 'SVC021'),
      ],
      ['aadhaar', 'dl'],
      ['moved', 'move', 'shift', 'relocat', 'address', 'ಊರು', 'ವಿಳಾಸ']),
  LifeEvent('college', L('School or college admission', 'ಶಾಲೆ ಅಥವಾ ಕಾಲೇಜು ಪ್ರವೇಶ'),
      L('Get certificates, a bus pass and scholarships in order.',
          'ಪ್ರಮಾಣಪತ್ರಗಳು, ಬಸ್ ಪಾಸ್ ಮತ್ತು ವಿದ್ಯಾರ್ಥಿವೇತನ ಪಡೆಯಿರಿ.'),
      Icons.school_outlined,
      [
        EventStep(L('Get an income certificate', 'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರ ಪಡೆಯಿರಿ'), 'SVC001'),
        EventStep(L('Get a caste certificate', 'ಜಾತಿ ಪ್ರಮಾಣಪತ್ರ ಪಡೆಯಿರಿ'), 'SVC002'),
        EventStep(L('Apply for a student bus pass', 'ವಿದ್ಯಾರ್ಥಿ ಬಸ್ ಪಾಸ್‌ಗೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'), 'SVC050'),
        EventStep(L('Apply for a scholarship', 'ವಿದ್ಯಾರ್ಥಿವೇತನಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'), 'SCH7300'),
      ],
      ['aadhaar', 'marks'],
      ['school', 'college', 'admission', 'scholarship', 'ಶಾಲೆ', 'ಕಾಲೇಜು']),
  LifeEvent('business', L('I am starting a business', 'ನಾನು ವ್ಯಾಪಾರ ಆರಂಭಿಸುತ್ತಿದ್ದೇನೆ'),
      L('Get the licence you need to open.', 'ವ್ಯಾಪಾರ ಆರಂಭಿಸಲು ಅಗತ್ಯ ಪರವಾನಗಿ ಪಡೆಯಿರಿ.'),
      Icons.storefront_outlined,
      [
        EventStep(L('Get a trade licence', 'ವ್ಯಾಪಾರ ಪರವಾನಗಿ ಪಡೆಯಿರಿ'), 'SVC060'),
        EventStep(L('Get a residence certificate', 'ವಾಸಸ್ಥಳ ಪ್ರಮಾಣಪತ್ರ ಪಡೆಯಿರಿ'), 'SVC003'),
      ],
      ['aadhaar', 'pan'],
      ['business', 'shop', 'startup', 'ವ್ಯಾಪಾರ']),
  LifeEvent('retire', L('I am retiring', 'ನಾನು ನಿವೃತ್ತನಾಗುತ್ತಿದ್ದೇನೆ'),
      L('See pensions and health cover for seniors.', 'ಹಿರಿಯರಿಗೆ ಪಿಂಚಣಿ ಮತ್ತು ಆರೋಗ್ಯ ರಕ್ಷಣೆ ನೋಡಿ.'),
      Icons.elderly_outlined,
      [
        EventStep(L('Apply for old age pension', 'ವೃದ್ಧಾಪ್ಯ ವೇತನಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'), 'SCH410'),
        EventStep(L('Enrol for health cover', 'ಆರೋಗ್ಯ ರಕ್ಷಣೆಗೆ ನೋಂದಾಯಿಸಿ'), 'SCH8000'),
      ],
      ['aadhaar', 'income'],
      ['retire', 'senior', 'old age', 'pension', 'ನಿವೃತ್ತ', 'ಹಿರಿಯ']),
  LifeEvent('land', L('I am buying land', 'ನಾನು ಭೂಮಿ ಖರೀದಿಸುತ್ತಿದ್ದೇನೆ'),
      L('Check the land record before and after you buy.', 'ಖರೀದಿಗೆ ಮೊದಲು ಮತ್ತು ನಂತರ ಭೂ ದಾಖಲೆ ಪರಿಶೀಲಿಸಿ.'),
      Icons.landscape_outlined,
      [
        EventStep(L('Check the land record (RTC)', 'ಭೂ ದಾಖಲೆ (ಪಹಣಿ) ಪರಿಶೀಲಿಸಿ'), 'SVC030'),
        EventStep(L('Get the mutation extract', 'ಮ್ಯುಟೇಷನ್ ಪ್ರತಿ ಪಡೆಯಿರಿ'), 'SVC031'),
      ],
      ['aadhaar', 'pan'],
      ['land', 'property', 'site', 'ಭೂಮಿ', 'ಆಸ್ತಿ']),
];

LifeEvent? matchLifeEvent(String q) {
  final s = q.toLowerCase();
  for (final e in lifeEvents) {
    if (e.keywords.any(s.contains)) return e;
  }
  return null;
}

/// Inspired by UMANG's Life Events guidance.
class LifeEventsScreen extends StatelessWidget {
  const LifeEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Life events', 'ಜೀವನದ ಘಟನೆಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(
          context.tr('Tell us what is happening. We list everything you will need.',
              'ಏನು ನಡೆಯುತ್ತಿದೆ ಎಂದು ತಿಳಿಸಿ. ನಿಮಗೆ ಬೇಕಾದ ಎಲ್ಲವನ್ನೂ ಪಟ್ಟಿ ಮಾಡುತ್ತೇವೆ.'),
          style: TextStyle(color: context.cs.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        for (final e in lifeEvents)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              onTap: () => push(context, LifeEventDetail(e)),
              child: Row(children: [
                IconBadge(e.icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(context.loc(e.title), style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(context.loc(e.intro),
                        style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                  ]),
                ),
              ]),
            ),
          ),
      ]),
    );
  }
}

class LifeEventDetail extends StatelessWidget {
  final LifeEvent e;
  const LifeEventDetail(this.e, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final all = [...services, ...schemes];
    final done = e.steps.where((st) => s.doneSteps.contains('${e.id}:${st.title.en}')).length;
    return Scaffold(
      appBar: AppBar(title: Text(context.loc(e.title))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(context.loc(e.intro), style: const TextStyle(fontSize: 15.5)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: done / e.steps.length, minHeight: 6),
        ),
        const SizedBox(height: 6),
        Text(context.tr('$done of ${e.steps.length} done', '${e.steps.length} ರಲ್ಲಿ $done ಪೂರ್ಣ'),
            style: TextStyle(color: context.cs.onSurfaceVariant)),
        SectionTitle(context.tr('Your steps', 'ನಿಮ್ಮ ಹಂತಗಳು')),
        const SizedBox(height: 6),
        for (final st in e.steps)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
              onTap: st.code == null
                  ? null
                  : () => push(context, ServiceDetail(all.firstWhere((v) => v.code == st.code))),
              child: Row(children: [
                Checkbox(
                  value: s.doneSteps.contains('${e.id}:${st.title.en}'),
                  onChanged: (v) => app.set(() {
                    final k = '${e.id}:${st.title.en}';
                    v == true ? app.doneSteps.add(k) : app.doneSteps.remove(k);
                  }),
                ),
                Expanded(
                  child: Text(context.loc(st.title),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                if (st.code != null)
                  Icon(Icons.chevron_right, color: context.cs.onSurfaceVariant),
              ]),
            ),
          ),
        SectionTitle(context.tr('Keep these ready', 'ಇವುಗಳನ್ನು ಸಿದ್ಧವಾಗಿಡಿ')),
        for (final id in e.docs)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(docById(id).icon, color: context.cs.primary),
            title: Text(context.loc(docById(id).name)),
            trailing: s.lockerDocs.contains(id)
                ? Pill(context.tr('Ready', 'ಸಿದ್ಧ'), color: context.cs.secondary, icon: Icons.check)
                : null,
          ),
      ]),
    );
  }
}

/// Inspired by UMANG's EMI / EPF / PPF / FD calculators. These do real maths,
/// but the rates are illustrative defaults.
class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  String kind = 'emi';
  double amount = 500000;
  double rate = 9;
  double years = 5;

  (String, String, String) result() {
    final r = rate / 100;
    switch (kind) {
      case 'emi':
        final m = r / 12;
        final n = years * 12;
        final emi = amount * m * pow(1 + m, n) / (pow(1 + m, n) - 1);
        return (tx('Monthly EMI', 'ಮಾಸಿಕ ಇಎಂಐ'), money(emi), tx('Total interest ${money(emi * n - amount)}', 'ಒಟ್ಟು ಬಡ್ಡಿ ${money(emi * n - amount)}'));
      case 'fd':
        final v = amount * pow(1 + r / 4, 4 * years);
        return (tx('Maturity value', 'ಪಕ್ವತೆ ಮೊತ್ತ'), money(v), tx('Interest earned ${money(v - amount)}', 'ಗಳಿಸಿದ ಬಡ್ಡಿ ${money(v - amount)}'));
      default:
        // Yearly deposit, compounded annually (PPF style).
        final v = amount * ((pow(1 + r, years) - 1) / r) * (1 + r);
        final paid = amount * years;
        return (tx('Maturity value', 'ಪಕ್ವತೆ ಮೊತ್ತ'), money(v), tx('You put in ${money(paid)}', 'ನೀವು ಹಾಕಿದ್ದು ${money(paid)}'));
    }
  }

  void pick(String k) => setState(() {
        kind = k;
        final (a, r, y) = switch (k) {
          'emi' => (500000.0, 9.0, 5.0),
          'fd' => (100000.0, 7.0, 3.0),
          _ => (100000.0, 7.0, 15.0),
        };
        amount = a;
        rate = r;
        years = y;
      });

  @override
  Widget build(BuildContext context) {
    final res = result();
    final kinds = {
      'emi': context.tr('Loan EMI', 'ಸಾಲ ಇಎಂಐ'),
      'fd': context.tr('Fixed deposit', 'ಸ್ಥಿರ ಠೇವಣಿ'),
      'ppf': 'PPF',
    };
    Widget slider(String label, String value, double v, double min, double max, int div,
            void Function(double) set) =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(label)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ]),
          Slider(
            value: v,
            min: min,
            max: max,
            divisions: div,
            label: value,
            semanticFormatterCallback: (_) => value,
            onChanged: (x) => setState(() => set(x)),
          ),
        ]);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Calculators', 'ಕ್ಯಾಲ್ಕುಲೇಟರ್‌ಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Wrap(spacing: 8, children: [
          for (final e in kinds.entries)
            ChoiceChip(label: Text(e.value), selected: kind == e.key, onSelected: (_) => pick(e.key)),
        ]),
        const SizedBox(height: 14),
        SevaCard(
          color: context.cs.primary.withValues(alpha: 0.09),
          child: Column(children: [
            Text(res.$1, style: TextStyle(color: context.cs.onSurfaceVariant)),
            Text(res.$2, style: context.tt.headlineMedium),
            Text(res.$3),
          ]),
        ),
        const SizedBox(height: 16),
        slider(kind == 'emi' ? context.tr('Loan amount', 'ಸಾಲದ ಮೊತ್ತ') : context.tr('Amount', 'ಮೊತ್ತ'),
            money(amount), amount, 10000, 2000000, 199, (x) => amount = (x / 10000).round() * 10000),
        slider(context.tr('Interest rate', 'ಬಡ್ಡಿ ದರ'), '${rate.toStringAsFixed(1)}%', rate, 1, 15, 28,
            (x) => rate = x),
        slider(context.tr('Years', 'ವರ್ಷಗಳು'), '${years.round()}', years, 1, 30, 29, (x) => years = x.roundToDouble()),
        Text(
          context.tr('For estimates only. Rates are examples.', 'ಅಂದಾಜಿಗೆ ಮಾತ್ರ. ದರಗಳು ಉದಾಹರಣೆಗಳು.'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant),
        ),
      ]),
    );
  }
}
