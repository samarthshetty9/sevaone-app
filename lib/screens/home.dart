import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../router.dart';
import '../widgets/common.dart';
import 'ai_home.dart';
import 'bills.dart';
import 'services.dart';
import 'track.dart';
import 'weather.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    if (s.aiMode) return const AiHome();
    final due = s.bills.where((b) => !b.paid).toList()..sort((a, b) => a.due.compareTo(b.due));
    final active = s.applications.where((a) => !a.done).toList();

    return ListView(padding: EdgeInsets.zero, children: [
      const _Header(),
      const Padding(padding: EdgeInsets.fromLTRB(16, 14, 16, 0), child: _WeatherStrip()),
      if (due.isNotEmpty || active.isNotEmpty) ...[
        SectionHeader(context.tr('Needs your attention', 'ನಿಮ್ಮ ಗಮನ ಬೇಕು')),
        if (due.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _DueBill(due.first),
          ),
        for (final a in active.take(2))
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: ApplicationCard(a),
          ),
      ],
      SectionHeader(context.tr('Quick actions', 'ತ್ವರಿತ ಕ್ರಿಯೆಗಳು')),
      const _QuickGrid(),
      const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 0), child: _SchemeFinderCard()),
      if (s.profileScore < 10)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: ProfileMeter(score: s.profileScore),
        ),
      SectionHeader(context.tr('Useful tools', 'ಉಪಯುಕ್ತ ಸಾಧನಗಳು')),
      const _Tools(),
      SectionHeader(context.tr('Popular services', 'ಜನಪ್ರಿಯ ಸೇವೆಗಳು'),
          action: context.tr('See all', 'ಎಲ್ಲಾ ನೋಡಿ'), onAction: () => openRoute('services')),
      SizedBox(
        height: 148 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            for (final v in services.where((v) => v.featured))
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(width: 158, child: _ServiceTile(v)),
              ),
          ],
        ),
      ),
      SectionHeader(context.tr('Reach us your way', 'ನಿಮಗೆ ಬೇಕಾದಂತೆ ಸಂಪರ್ಕಿಸಿ')),
      const _Channels(),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 26),
        child: Center(
          child: Text(
            context.tr('Demo build. All data shown is simulated.',
                'ಡೆಮೊ ಆವೃತ್ತಿ. ತೋರಿಸಿದ ಎಲ್ಲಾ ಮಾಹಿತಿ ಅನುಕರಿತವಾಗಿದೆ.'),
            style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant),
          ),
        ),
      ),
    ]);
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, top + 8, 8, 18),
      decoration: const BoxDecoration(
        gradient: Seva.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Image.asset('assets/images/sevasindhu-logo.png',
                width: 30, height: 30, excludeFromSemantics: true),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(children: [
              Flexible(
                child: Text('SevaOne',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: context.tt.titleLarge?.copyWith(color: Colors.white)),
              ),
              const SizedBox(width: 8),
              const DemoChip(onDark: true),
            ]),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white, minimumSize: const Size(44, 44)),
            onPressed: () => app.set(() => app.lang = app.lang == 'en' ? 'kn' : 'en'),
            child: Semantics(
              label: context.tr('Switch to Kannada', 'ಇಂಗ್ಲಿಷ್‌ಗೆ ಬದಲಿಸಿ'),
              excludeSemantics: true,
              child: Text(s.lang == 'en' ? 'ಕನ್ನಡ' : 'English',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          IconButton(
            tooltip: context.tr('Notifications', 'ಅಧಿಸೂಚನೆಗಳು'),
            color: Colors.white,
            onPressed: () => openRoute('notifications'),
            icon: Badge(
              isLabelVisible: s.unread > 0,
              label: Text('${s.unread}'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(children: [
            Expanded(
              child: Text(
                context.tr('Namaskara, ${citizenName.en.split(' ').first}',
                    'ನಮಸ್ಕಾರ, ${citizenName.kn.split(' ').first}'),
                style: context.tt.headlineSmall?.copyWith(color: Colors.white),
              ),
            ),
            const AiToggle(),
          ]),
        ),
        const SizedBox(height: 2),
        Text(context.tr('What do you need today?', 'ಇಂದು ನಿಮಗೆ ಏನು ಬೇಕು?'),
            style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => openRoute('search'),
              child: Row(children: [
                const SizedBox(width: 14),
                const Icon(Icons.search, color: Seva.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.tr('Search or speak a service', 'ಸೇವೆಯನ್ನು ಹುಡುಕಿ ಅಥವಾ ಹೇಳಿ'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF5F6275)),
                  ),
                ),
                IconButton(
                  tooltip: context.tr('Search by voice', 'ಧ್ವನಿಯ ಮೂಲಕ ಹುಡುಕಿ'),
                  color: Seva.blue,
                  icon: const Icon(Icons.mic_none_rounded),
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const SearchScreen(voice: true))),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _WeatherStrip extends StatelessWidget {
  const _WeatherStrip();

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final w = weatherByDistrict[s.weatherDistrict]!;
    final band = aqiBand(w.aqi);
    final dist = districts.firstWhere((d) => d.en == s.weatherDistrict);
    return SevaCard(
      onTap: () => openRoute('weather'),
      semanticLabel: context.tr(
          '${dist.en}, ${w.temp} degrees, air quality ${w.aqi}, ${band.$1.en}',
          '${dist.kn}, ${w.temp} ಡಿಗ್ರಿ, ಗಾಳಿಯ ಗುಣಮಟ್ಟ ${w.aqi}, ${band.$1.kn}'),
      child: Row(children: [
        Icon(weatherIcon(w.condition), color: Seva.saffron, size: 30),
        const SizedBox(width: 10),
        Text('${w.temp}°', style: context.tt.headlineSmall),
        const SizedBox(width: 10),
        Expanded(
          child: Text(context.loc(dist),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.cs.onSurfaceVariant)),
        ),
        const SizedBox(width: 8),
        Pill('AQI ${w.aqi}', color: band.$2),
      ]),
    );
  }
}

class _DueBill extends StatelessWidget {
  final Bill b;
  const _DueBill(this.b);

  @override
  Widget build(BuildContext context) {
    final days = b.due.difference(DateTime.now()).inDays + 1;
    return SevaCard(
      onTap: () => push(context, BillDetail(b)),
      child: Row(children: [
        IconBadge(billIcon(b.category), color: Seva.saffron),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('${b.provider.en} bill', '${b.provider.kn} ಬಿಲ್'),
                style: context.tt.titleMedium),
            Text(context.tr('Due in $days days', '$days ದಿನಗಳಲ್ಲಿ ಪಾವತಿಸಬೇಕು'),
                style: TextStyle(color: context.cs.onSurfaceVariant, fontSize: 13)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(money(b.amount), style: context.tt.titleMedium),
          Text(context.tr('Pay now', 'ಈಗ ಪಾವತಿಸಿ'),
              style: TextStyle(
                  color: context.cs.primary, fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
      ]),
    );
  }
}

class _QuickGrid extends StatelessWidget {
  const _QuickGrid();

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, Color)>[
      (Icons.receipt_long_outlined, context.tr('Pay bills', 'ಬಿಲ್ ಪಾವತಿ'), 'bills', Seva.saffron),
      (Icons.volunteer_activism_outlined, context.tr('Schemes', 'ಯೋಜನೆಗಳು'), 'schemes', Seva.greenDark),
      (Icons.document_scanner_outlined, context.tr('Scan', 'ಸ್ಕ್ಯಾನ್'), 'scanner', Seva.blue),
      (Icons.verified_outlined, context.tr('Verify', 'ಪರಿಶೀಲಿಸಿ'), 'verify', Seva.blueDark),
      (Icons.location_on_outlined, context.tr('Centres', 'ಕೇಂದ್ರಗಳು'), 'centres', Seva.red),
      (Icons.report_problem_outlined, context.tr('Grievance', 'ಕುಂದುಕೊರತೆ'), 'grievance', const Color(0xFFB57700)),
      (Icons.event_note_outlined, context.tr('Life events', 'ಜೀವನದ ಘಟನೆಗಳು'), 'life', const Color(0xFF0E8FA8)),
      (Icons.calculate_outlined, context.tr('Calculators', 'ಕ್ಯಾಲ್ಕುಲೇಟರ್'), 'calculators', Seva.navy),
    ];
    return LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 32 - 24) / 4;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 8, runSpacing: 10, children: [
          for (final i in items)
            SizedBox(
              width: w,
              child: Semantics(
                button: true,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => openRoute(i.$3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(children: [
                      IconBadge(i.$1,
                          color: context.cs.brightness == Brightness.dark
                              ? context.cs.primary
                              : i.$4,
                          size: 50),
                      const SizedBox(height: 6),
                      Text(i.$2,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                ),
              ),
            ),
        ]),
      );
    });
  }
}

class _SchemeFinderCard extends StatelessWidget {
  const _SchemeFinderCard();

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final n = s.recommendedSchemes.length;
    return Material(
      color: Seva.navy,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openRoute('eligibility'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const Icon(Icons.auto_awesome, color: Seva.gold, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  s.profile.completed
                      ? context.tr('$n schemes match you', '$n ಯೋಜನೆಗಳು ನಿಮಗೆ ಹೊಂದುತ್ತವೆ')
                      : context.tr('Find schemes you qualify for', 'ನಿಮಗೆ ಅರ್ಹವಾದ ಯೋಜನೆಗಳನ್ನು ಹುಡುಕಿ'),
                  style: context.tt.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  context.tr('Answer 6 questions. No forms.', '6 ಪ್ರಶ್ನೆಗಳಿಗೆ ಉತ್ತರಿಸಿ. ಫಾರ್ಮ್ ಬೇಡ.'),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ]),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ]),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final Service v;
  const _ServiceTile(this.v);

  @override
  Widget build(BuildContext context) {
    return SevaCard(
      onTap: () => push(context, ServiceDetail(v)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IconBadge(v.icon, size: 38),
        const SizedBox(height: 8),
        Expanded(
          child: Text(context.loc(v.name),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Text(
          v.sakalaDays <= 1
              ? context.tr('Instant', 'ತಕ್ಷಣ')
              : context.tr('${v.sakalaDays} days', '${v.sakalaDays} ದಿನ'),
          style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant),
        ),
      ]),
    );
  }
}

class _Tools extends StatelessWidget {
  const _Tools();

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, Color)>[
      (Icons.emergency_outlined, context.tr('Emergency', 'ತುರ್ತು'), 'emergency', Seva.red),
      (Icons.contact_phone_outlined, context.tr('Helplines', 'ಸಹಾಯವಾಣಿಗಳು'), 'helplines', Seva.greenDark),
      (Icons.work_outline, context.tr('Jobs', 'ಉದ್ಯೋಗಗಳು'), 'jobs', Seva.blue),
      (Icons.pin_drop_outlined, 'DIGIPIN', 'digipin', Seva.saffron),
      (Icons.password_outlined, context.tr('Authenticator', 'ದೃಢೀಕರಣ ಕೋಡ್'), 'totp', Seva.blueDark),
    ];
    return SizedBox(
      height: 104 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.5),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final i in items)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 106,
                child: SevaCard(
                  padding: const EdgeInsets.all(10),
                  onTap: () => openRoute(i.$3),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    IconBadge(i.$1,
                        color: context.cs.brightness == Brightness.dark
                            ? context.cs.primary
                            : i.$4,
                        size: 34),
                    const Spacer(),
                    Text(i.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Channels extends StatelessWidget {
  const _Channels();

  @override
  Widget build(BuildContext context) {
    Widget tile(IconData i, String title, String sub, String route) => SevaCard(
          onTap: () => openRoute(route),
          child: Row(children: [
            IconBadge(i, size: 36),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(sub,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
              ]),
            ),
          ]),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: tile(Icons.graphic_eq, context.tr('Voice bot', 'ಧ್ವನಿ ಬಾಟ್'),
                  context.tr('Talk to Seva', 'ಸೇವಾ ಜೊತೆ ಮಾತನಾಡಿ'), 'voice')),
          const SizedBox(width: 10),
          Expanded(
              child: tile(Icons.chat_outlined, context.tr('Live chat', 'ಲೈವ್ ಚಾಟ್'),
                  context.tr('Reach an agent', 'ಸಹಾಯಕರನ್ನು ಸಂಪರ್ಕಿಸಿ'), 'chat')),
        ]),
        const SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: tile(Icons.sms_outlined, 'SMS',
                  context.tr('No internet needed', 'ಇಂಟರ್ನೆಟ್ ಬೇಕಿಲ್ಲ'), 'sms')),
          const SizedBox(width: 10),
          Expanded(
              child: tile(Icons.call_outlined, '1902',
                  context.tr('Helpline, 24x7', 'ಸಹಾಯವಾಣಿ, 24x7'), 'help')),
        ]),
        const SizedBox(height: 10),
        tile(Icons.forum_outlined, 'WhatsApp',
            context.tr('Get services on WhatsApp', 'ವಾಟ್ಸಾಪ್‌ನಲ್ಲಿ ಸೇವೆಗಳನ್ನು ಪಡೆಯಿರಿ'), 'whatsapp'),
      ]),
    );
  }
}
