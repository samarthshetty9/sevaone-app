import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/seed.dart';
import '../app/theme.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';
import 'services.dart';

/// Feature 11: eligibility-based recommendation.
class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  int step = 0;
  bool results = app.profile.completed;

  void next() {
    if (step == 5) {
      app.set(() => app.profile.completed = true);
      setState(() => results = true);
    } else {
      setState(() => step++);
    }
  }

  Widget choices(List<(String, String)> items, String value, void Function(String) pick) {
    return Column(children: [
      for (final (k, label) in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SevaCard(
            color: value == k ? context.cs.primary.withValues(alpha: .1) : null,
            onTap: () => app.set(() => pick(k)),
            semanticLabel: label,
            child: Row(children: [
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15.5))),
              Icon(value == k ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: value == k ? context.cs.primary : context.cs.onSurfaceVariant),
            ]),
          ),
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final p = s.profile;
    if (results) return _results(context);

    final (title, body) = switch (step) {
      0 => (
          context.tr('How old are you?', 'ನಿಮ್ಮ ವಯಸ್ಸು ಎಷ್ಟು?'),
          Column(children: [
            Text('${p.age}', style: context.tt.headlineMedium?.copyWith(fontSize: 64, color: context.cs.primary)),
            Text(context.tr('years', 'ವರ್ಷಗಳು')),
            Slider(
              min: 14,
              max: 90,
              divisions: 76,
              label: '${p.age}',
              value: p.age.toDouble(),
              onChanged: (v) => app.set(() => p.age = v.round()),
            ),
          ]) as Widget
        ),
      1 => (
          context.tr('Your gender', 'ನಿಮ್ಮ ಲಿಂಗ'),
          choices([
            ('female', context.tr('Woman', 'ಮಹಿಳೆ')),
            ('male', context.tr('Man', 'ಪುರುಷ')),
            ('other', context.tr('Other', 'ಇತರೆ')),
          ], p.gender, (v) => p.gender = v)
        ),
      2 => (
          context.tr('What do you do?', 'ನೀವು ಏನು ಮಾಡುತ್ತೀರಿ?'),
          choices([
            ('student', context.tr('Student', 'ವಿದ್ಯಾರ್ಥಿ')),
            ('farmer', context.tr('Farmer', 'ರೈತ')),
            ('worker', context.tr('Worker', 'ಕಾರ್ಮಿಕ')),
            ('business', context.tr('Business', 'ವ್ಯಾಪಾರ')),
            ('homemaker', context.tr('Homemaker', 'ಗೃಹಿಣಿ')),
            ('unemployed', context.tr('Looking for work', 'ಉದ್ಯೋಗ ಹುಡುಕುತ್ತಿದ್ದೇನೆ')),
          ], p.occupation, (v) => p.occupation = v)
        ),
      3 => (
          context.tr('Yearly family income', 'ವಾರ್ಷಿಕ ಕುಟುಂಬ ಆದಾಯ'),
          Column(children: [
            Text(money(p.income), style: context.tt.headlineMedium?.copyWith(fontSize: 44, color: context.cs.primary)),
            Slider(
              min: 0,
              max: 1000000,
              divisions: 40,
              label: money(p.income),
              value: p.income.toDouble(),
              onChanged: (v) => app.set(() => p.income = v.round()),
            ),
          ]) as Widget
        ),
      4 => (
          context.tr('Your category', 'ನಿಮ್ಮ ವರ್ಗ'),
          choices([
            ('general', context.tr('General', 'ಸಾಮಾನ್ಯ')),
            ('obc', 'OBC'),
            ('sc', 'SC'),
            ('st', 'ST'),
            ('minority', context.tr('Minority', 'ಅಲ್ಪಸಂಖ್ಯಾತ')),
          ], p.category, (v) => p.category = v)
        ),
      _ => (
          context.tr('Do these apply to you?', 'ಇವು ನಿಮಗೆ ಅನ್ವಯಿಸುತ್ತವೆಯೇ?'),
          Column(children: [
            SwitchListTile(
              title: Text(context.tr('BPL ration card', 'ಬಿಪಿಎಲ್ ಪಡಿತರ ಚೀಟಿ')),
              value: p.bpl,
              onChanged: (v) => app.set(() => p.bpl = v),
            ),
            SwitchListTile(
              title: Text(context.tr('Person with disability', 'ವಿಕಲಚೇತನ ವ್ಯಕ್ತಿ')),
              value: p.disabled,
              onChanged: (v) => app.set(() => p.disabled = v),
            ),
          ]) as Widget
        ),
    };

    return Scaffold(
      appBar: SevaBar(
        title: Text(context.tr('Scheme finder', 'ಯೋಜನೆ ಶೋಧಕ')),
        leading: step > 0
            ? IconButton(
                tooltip: context.tr('Previous question', 'ಹಿಂದಿನ ಪ್ರಶ್ನೆ'),
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => step--),
              )
            : null,
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('Question ${step + 1} of 6', 'ಪ್ರಶ್ನೆ ${step + 1} / 6'),
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Semantics(
              header: true,
              child: Text(title, style: context.tt.headlineSmall?.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (step + 1) / 6,
                minHeight: 6,
                color: Seva.gold,
                backgroundColor: Colors.white24,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 18),
        body,
        const SizedBox(height: 14),
        SevaCard(
          color: context.cs.primary.withValues(alpha: .08),
          child: Row(children: [
            Icon(Icons.lock_outline, color: context.cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(context.tr('We only use your answers to match schemes.',
                  'ನಿಮ್ಮ ಉತ್ತರಗಳನ್ನು ಯೋಜನೆ ಹೊಂದಿಸಲು ಮಾತ್ರ ಬಳಸುತ್ತೇವೆ.')),
            ),
          ]),
        ),
      ]),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: next,
          child: Text(step == 5
              ? context.tr('Show my schemes', 'ನನ್ನ ಯೋಜನೆಗಳನ್ನು ತೋರಿಸಿ')
              : context.tr('Next', 'ಮುಂದೆ')),
        ),
      ),
    );
  }

  Widget _results(BuildContext context) {
    final s = context.watchApp;
    final match = s.recommendedSchemes;
    final others = schemes.where((v) => !match.contains(v)).toList();
    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Your matches', 'ನಿಮ್ಮ ಹೊಂದಾಣಿಕೆಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          colors: const [Color(0xFF0B5D5A), Color(0xFF0E9F8E)],
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('${match.length} schemes match you', '${match.length} ಯೋಜನೆಗಳು ನಿಮಗೆ ಹೊಂದುತ್ತವೆ'),
                    style: context.tt.headlineSmall?.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  context.tr('Based on your answers. The department makes the final decision.',
                      'ನಿಮ್ಮ ಉತ್ತರಗಳ ಆಧಾರದ ಮೇಲೆ. ಅಂತಿಮ ನಿರ್ಧಾರ ಇಲಾಖೆಯದು.'),
                  style: const TextStyle(color: Colors.white),
                ),
              ]),
            ),
            const IconArt(Icons.auto_awesome, size: 72),
          ]),
        ),
        const SizedBox(height: 12),
        if (match.isEmpty)
          EmptyState(
            icon: Icons.search_off,
            title: context.tr('No direct match yet', 'ಸದ್ಯಕ್ಕೆ ನೇರ ಹೊಂದಾಣಿಕೆ ಇಲ್ಲ'),
            body: context.tr('You can still browse all schemes below.',
                'ಕೆಳಗೆ ಎಲ್ಲಾ ಯೋಜನೆಗಳನ್ನು ನೋಡಬಹುದು.'),
          ),
        for (final v in match)
          Padding(padding: const EdgeInsets.only(bottom: 8), child: ServiceRow(v)),
        OutlinedButton(
          onPressed: () => setState(() {
            results = false;
            step = 0;
          }),
          child: Text(context.tr('Change my answers', 'ನನ್ನ ಉತ್ತರಗಳನ್ನು ಬದಲಿಸಿ')),
        ),
        if (others.isNotEmpty) ...[
          SectionTitle(context.tr('Other schemes', 'ಇತರ ಯೋಜನೆಗಳು')),
          const SizedBox(height: 6),
          for (final v in others)
            Padding(padding: const EdgeInsets.only(bottom: 8), child: ServiceRow(v)),
        ],
      ]),
    );
  }
}
