import 'dart:async';

import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../router.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';
import 'ai_home.dart';
import 'bills.dart';
import 'extras.dart';
import 'locker.dart';
import 'services.dart';
import 'weather.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    if (s.aiMode) return const AiHome();
    final active = s.applications.where((a) => !a.done).toList();
    final due = s.bills.where((b) => !b.paid).toList()..sort((a, b) => a.due.compareTo(b.due));

    return ListView(padding: const EdgeInsets.only(bottom: 18), children: [
      const _Hero(),
      const SizedBox(height: 16),
      const _Promos(),
      SectionHeader(context.tr('Services for you', 'ನಿಮಗಾಗಿ ಸೇವೆಗಳು'),
          action: context.tr('View all', 'ಎಲ್ಲಾ ನೋಡಿ'), onAction: () => openRoute('services')),
      const _QuickGrid(),
      if (active.isNotEmpty || due.isNotEmpty) ...[
        SectionHeader(context.tr('Needs your attention', 'ನಿಮ್ಮ ಗಮನ ಬೇಕು')),
        if (due.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _DueBill(due.first),
          ),
        if (active.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _Progress(active.first),
          ),
      ],
      SectionHeader(context.tr('Life events', 'ಜೀವನದ ಘಟನೆಗಳು'),
          action: context.tr('View all', 'ಎಲ್ಲಾ ನೋಡಿ'), onAction: () => openRoute('life')),
      const _LifeEvents(),
      SectionHeader(context.tr('My documents', 'ನನ್ನ ದಾಖಲೆಗಳು'),
          action: context.tr('Open', 'ತೆರೆಯಿರಿ'), onAction: () => openRoute('documents')),
      const _Wallet(),
      SectionHeader(context.tr('Around you', 'ನಿಮ್ಮ ಸುತ್ತ')),
      const _AroundYou(),
      SectionHeader(context.tr('Useful tools', 'ಉಪಯುಕ್ತ ಸಾಧನಗಳು')),
      const _Tools(),
      SectionHeader(context.tr('Reach us your way', 'ನಿಮಗೆ ಬೇಕಾದಂತೆ ಸಂಪರ್ಕಿಸಿ')),
      const _Channels(),
      const SizedBox(height: 18),
      Center(
        child: Column(children: [
          Image.asset('assets/images/sevasindhu-logo.png', height: 40, excludeFromSemantics: true),
          const SizedBox(height: 6),
          Text(context.tr('Government of Karnataka', 'ಕರ್ನಾಟಕ ಸರ್ಕಾರ'),
              style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
        ]),
      ),
    ]);
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final top = MediaQuery.of(context).padding.top;
    final w = weatherByDistrict[s.weatherDistrict]!;
    final dist = districts.firstWhere((d) => d.en == s.weatherDistrict);

    return Stack(children: [
      Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 46,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            gradient: Seva.headerGradient,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: const Skyline(height: 118),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16, top + 10, 16, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Semantics(
              button: true,
              label: context.tr('Open profile', 'ಪ್ರೊಫೈಲ್ ತೆರೆಯಿರಿ'),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => openRoute('profile'),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Seva.gold,
                  child: Text(context.tr('AG', 'ಅ'),
                      style: const TextStyle(color: Seva.navy, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('Namaskara,', 'ನಮಸ್ಕಾರ,'),
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                Text(context.loc(citizenName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.tt.titleLarge?.copyWith(color: Colors.white)),
              ]),
            ),
            _RoundButton(
              tooltip: context.tr('Change language', 'ಭಾಷೆ ಬದಲಿಸಿ'),
              onTap: () => app.set(() => app.lang = app.lang == 'en' ? 'kn' : 'en'),
              child: Text(s.lang == 'en' ? 'ಕ' : 'A',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            const SizedBox(width: 8),
            _RoundButton(
              tooltip: context.tr('Notifications', 'ಅಧಿಸೂಚನೆಗಳು'),
              onTap: () => openRoute('notifications'),
              child: Badge(
                isLabelVisible: s.unread > 0,
                label: Text('${s.unread}'),
                child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
              ),
            ),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => openRoute('weather'),
                child: Row(children: [
                  Icon(weatherIcon(w.condition), color: Seva.gold, size: 18),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text('${w.temp}° ${context.loc(dist)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ]),
              ),
            ),
            const SizedBox(width: 8),
            const AiToggle(),
          ]),
          const SizedBox(height: 14),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 4,
            shadowColor: Colors.black38,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => openRoute('search'),
              child: Row(children: [
                const SizedBox(width: 14),
                const Icon(Icons.search, color: Seva.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.tr('Search services and schemes', 'ಸೇವೆಗಳು ಮತ್ತು ಯೋಜನೆಗಳನ್ನು ಹುಡುಕಿ'),
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
          const SizedBox(height: 14),
          const _Glance(),
        ]),
      ),
    ]);
  }
}

class _RoundButton extends StatelessWidget {
  final String tooltip;
  final VoidCallback onTap;
  final Widget child;
  const _RoundButton({required this.tooltip, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: .15),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: 44, height: 44, child: Center(child: child)),
        ),
      ),
    );
  }
}

/// The three numbers a citizen opens the app to check.
class _Glance extends StatelessWidget {
  const _Glance();

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final active = s.applications.where((a) => !a.done).length;
    final due = s.bills.where((b) => !b.paid).fold<int>(0, (a, b) => a + b.amount);
    final docs = s.digilockerLinked ? '${s.lockerDocs.length}' : '–';
    Widget cell(String v, String k, String route) => Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => openRoute(route),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(v,
                      maxLines: 1,
                      style:
                          context.tt.titleLarge?.copyWith(color: context.cs.primary, fontSize: 20)),
                ),
                Text(k,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
              ]),
            ),
          ),
        );
    Widget div() => Container(width: 1, height: 34, color: context.cs.outlineVariant);
    return SevaCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Row(children: [
        cell('$active', context.tr('Applications', 'ಅರ್ಜಿಗಳು'), 'track'),
        div(),
        cell(money(due), context.tr('Bills due', 'ಬಾಕಿ ಬಿಲ್'), 'bills'),
        div(),
        cell(docs, context.tr('Documents', 'ದಾಖಲೆಗಳು'), 'documents'),
      ]),
    );
  }
}

class _Promo {
  final String title, body, cta, route;
  final IconData icon;
  final List<Color> colors;
  const _Promo(this.title, this.body, this.cta, this.route, this.icon, this.colors);
}

class _Promos extends StatefulWidget {
  const _Promos();

  @override
  State<_Promos> createState() => _PromosState();
}

class _PromosState extends State<_Promos> {
  final c = PageController(viewportFraction: .92);
  int page = 0;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || app.reduceMotion || !c.hasClients) return;
      c.animateToPage((page + 1) % 4,
          duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _Promo(
          context.tr('Gruha Lakshmi', 'ಗೃಹ ಲಕ್ಷ್ಮಿ'),
          context.tr('₹2,000 every month for women heads of family',
              'ಕುಟುಂಬದ ಮಹಿಳಾ ಮುಖ್ಯಸ್ಥೆಗೆ ಪ್ರತಿ ತಿಂಗಳು ₹2,000'),
          context.tr('Check eligibility', 'ಅರ್ಹತೆ ಪರಿಶೀಲಿಸಿ'),
          'eligibility',
          Icons.volunteer_activism,
          const [Color(0xFFB8336A), Color(0xFFE8743B)]),
      _Promo(
          context.tr('Find your schemes', 'ನಿಮ್ಮ ಯೋಜನೆಗಳನ್ನು ಹುಡುಕಿ'),
          context.tr('Six quick questions, every benefit you qualify for',
              'ಆರು ಸಣ್ಣ ಪ್ರಶ್ನೆಗಳು, ನಿಮಗೆ ಅರ್ಹವಾದ ಎಲ್ಲಾ ಸೌಲಭ್ಯಗಳು'),
          context.tr('Start now', 'ಈಗ ಪ್ರಾರಂಭಿಸಿ'),
          'eligibility',
          Icons.auto_awesome,
          const [Color(0xFF0B6E69), Color(0xFF12B5A0)]),
      _Promo(
          context.tr('Documents in one place', 'ದಾಖಲೆಗಳು ಒಂದೇ ಕಡೆ'),
          context.tr('Link DigiLocker and stop uploading the same files',
              'ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್ ಮಾಡಿ, ಅದೇ ದಾಖಲೆಗಳನ್ನು ಮತ್ತೆ ಅಪ್‌ಲೋಡ್ ಮಾಡಬೇಡಿ'),
          context.tr('Open documents', 'ದಾಖಲೆಗಳನ್ನು ತೆರೆಯಿರಿ'),
          'documents',
          Icons.folder_special,
          const [Color(0xFF3B2F9E), Color(0xFF6C63E8)]),
      _Promo(
          context.tr('Pay every bill here', 'ಎಲ್ಲಾ ಬಿಲ್‌ಗಳನ್ನು ಇಲ್ಲೇ ಪಾವತಿಸಿ'),
          context.tr('Electricity, water and property tax in two taps',
              'ವಿದ್ಯುತ್, ನೀರು ಮತ್ತು ಆಸ್ತಿ ತೆರಿಗೆ ಎರಡು ಟ್ಯಾಪ್‌ಗಳಲ್ಲಿ'),
          context.tr('Pay bills', 'ಬಿಲ್ ಪಾವತಿಸಿ'),
          'bills',
          Icons.bolt,
          const [Color(0xFFB36A08), Color(0xFFE09A2B)]),
    ];
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    return Column(children: [
      SizedBox(
        height: 164 * scale,
        child: PageView.builder(
          controller: c,
          itemCount: items.length,
          onPageChanged: (i) => setState(() => page = i),
          itemBuilder: (_, i) {
            final p = items[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GlowPanel(
                colors: p.colors,
                onTap: () => openRoute(p.route),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.tt.titleLarge?.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(p.body,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 13.5)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(999)),
                        child: Text(p.cta,
                            maxLines: 1,
                            style: TextStyle(
                                color: p.colors.first,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5)),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  IconArt(p.icon, size: 88),
                ]),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      ExcludeSemantics(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 0; i < items.length; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == page ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == page ? context.cs.primary : context.cs.outlineVariant,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ]),
      ),
    ]);
  }
}

class _QuickGrid extends StatelessWidget {
  const _QuickGrid();

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, Color)>[
      (Icons.workspace_premium, context.tr('Certificates', 'ಪ್ರಮಾಣಪತ್ರಗಳು'), 'services', Seva.tones[0]),
      (Icons.receipt_long, context.tr('Pay bills', 'ಬಿಲ್ ಪಾವತಿ'), 'bills', Seva.tones[2]),
      (Icons.volunteer_activism, context.tr('Schemes', 'ಯೋಜನೆಗಳು'), 'schemes', Seva.tones[3]),
      (Icons.landscape, context.tr('Land records', 'ಭೂ ದಾಖಲೆ'), 'services', Seva.tones[7]),
      (Icons.document_scanner, context.tr('Scan', 'ಸ್ಕ್ಯಾನ್'), 'scanner', Seva.tones[5]),
      (Icons.verified, context.tr('Verify', 'ಪರಿಶೀಲಿಸಿ'), 'verify', Seva.tones[1]),
      (Icons.location_on, context.tr('Centres', 'ಕೇಂದ್ರಗಳು'), 'centres', Seva.tones[4]),
      (Icons.campaign, context.tr('Grievance', 'ಕುಂದುಕೊರತೆ'), 'grievance', Seva.tones[6]),
    ];
    return LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 32 - 36) / 4;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SevaCard(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 8),
          child: Wrap(alignment: WrapAlignment.spaceEvenly, runSpacing: 12, children: [
            for (final i in items)
              SizedBox(
                width: w,
                child: Semantics(
                  button: true,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => openRoute(i.$3),
                    child: Column(children: [
                      IconBadge(i.$1, color: i.$4, size: 52),
                      const SizedBox(height: 7),
                      Text(i.$2,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ),
          ]),
        ),
      );
    });
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
        IconBadge(billIcon(b.category), color: Seva.saffron, size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('${b.provider.en} bill', '${b.provider.kn} ಬಿಲ್'),
                style: context.tt.titleMedium),
            Text(context.tr('Due in $days days', '$days ದಿನಗಳಲ್ಲಿ ಪಾವತಿಸಬೇಕು'),
                style: TextStyle(
                    color: context.cs.error, fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(money(b.amount), style: context.tt.titleLarge),
          Text(context.tr('Pay now', 'ಈಗ ಪಾವತಿಸಿ'),
              style: TextStyle(
                  color: context.cs.primary, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ]),
    );
  }
}

class _Progress extends StatelessWidget {
  final Application a;
  const _Progress(this.a);

  @override
  Widget build(BuildContext context) {
    context.watchApp;
    return SevaCard(
      onTap: () => openRoute('application:${a.id}'),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const IconBadge(Icons.timeline, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(context.loc(a.service), style: context.tt.titleMedium),
              Text(context.loc(a.stages[a.current].title),
                  style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        ExcludeSemantics(
          child: Row(children: [
            for (var i = 0; i < a.stages.length; i++)
              Expanded(
                child: Container(
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= a.current
                        ? context.cs.primary
                        : context.cs.primary.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
          ]),
        ),
      ]),
    );
  }
}

class _LifeEvents extends StatelessWidget {
  const _LifeEvents();

  @override
  Widget build(BuildContext context) {
    const palettes = [
      [Color(0xFFC2304E), Color(0xFFE5674F)],
      [Color(0xFF7A3FC4), Color(0xFFAE55C9)],
      [Color(0xFF1570B5), Color(0xFF2F9FD0)],
      [Color(0xFF227A46), Color(0xFF4FA63A)],
      [Color(0xFFB36A08), Color(0xFFD89A1E)],
      [Color(0xFF0B7D70), Color(0xFF22A98F)],
      [Color(0xFF4340BE), Color(0xFF6E6BE0)],
    ];
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    return SizedBox(
      height: 132 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: lifeEvents.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final e = lifeEvents[i];
          return SizedBox(
            width: 138,
            child: GlowPanel(
              colors: palettes[i % palettes.length],
              radius: 18,
              padding: const EdgeInsets.all(12),
              onTap: () => push(context, LifeEventDetail(e)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(e.icon, color: Colors.white, size: 30),
                const Spacer(),
                Text(context.loc(e.title),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, height: 1.2)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _Wallet extends StatelessWidget {
  const _Wallet();

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    if (!s.digilockerLinked) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GlowPanel(
          onTap: () => openRoute('digilocker'),
          child: Row(children: [
            const IconArt(Icons.lock_open, size: 72),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr('Link DigiLocker', 'ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್ ಮಾಡಿ'),
                    style: context.tt.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 2),
                Text(context.tr('Aadhaar, PAN, licence and more, always with you',
                    'ಆಧಾರ್, ಪ್ಯಾನ್, ಪರವಾನಗಿ ಮತ್ತು ಇನ್ನಷ್ಟು, ಸದಾ ನಿಮ್ಮೊಂದಿಗೆ'),
                    style: const TextStyle(color: Colors.white, fontSize: 13.5)),
              ]),
            ),
          ]),
        ),
      );
    }
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    final docs = docTypes.where((d) => s.lockerDocs.contains(d.id)).toList();
    return SizedBox(
      height: 118 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: docs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final d = docs[i];
          return SizedBox(
            width: 196,
            child: GlowPanel(
              radius: 18,
              padding: const EdgeInsets.all(13),
              colors: i.isEven
                  ? const [Seva.navy, Seva.blueDark]
                  : const [Color(0xFF0B5D5A), Color(0xFF0E9F8E)],
              onTap: () => push(context, DocumentView(d)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(d.icon, color: Seva.gold, size: 24),
                const Spacer(),
                Text(context.loc(d.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                Text(d.number,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _AroundYou extends StatelessWidget {
  const _AroundYou();

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final w = weatherByDistrict[s.weatherDistrict]!;
    final band = aqiBand(w.aqi);
    final c = centres.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: SevaCard(
              onTap: () => openRoute('weather'),
              child: Column(children: [
                Text(context.tr('Air quality', 'ಗಾಳಿಯ ಗುಣಮಟ್ಟ'),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                ArcGauge(value: w.aqi / 300, big: '${w.aqi}', small: 'AQI', size: 112),
                Text(context.loc(band.$1),
                    style: TextStyle(color: band.$2, fontWeight: FontWeight.w700, fontSize: 13)),
              ]),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SevaCard(
              onTap: () => openRoute('centres'),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const IconBadge(Icons.storefront, size: 40),
                const SizedBox(height: 8),
                Text(context.tr('Nearest centre', 'ಹತ್ತಿರದ ಕೇಂದ್ರ'),
                    style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
                Text(context.loc(c.name),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(context.tr('${c.km} km away', '${c.km} ಕಿ.ಮೀ ದೂರ'),
                    style: TextStyle(
                        color: context.cs.primary, fontWeight: FontWeight.w700, fontSize: 13)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Tools extends StatelessWidget {
  const _Tools();

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, Color)>[
      (Icons.emergency, context.tr('Emergency', 'ತುರ್ತು'), 'emergency', Seva.red),
      (Icons.contact_phone, context.tr('Helplines', 'ಸಹಾಯವಾಣಿಗಳು'), 'helplines', Seva.tones[7]),
      (Icons.work, context.tr('Jobs', 'ಉದ್ಯೋಗಗಳು'), 'jobs', Seva.tones[5]),
      (Icons.calculate, context.tr('Calculators', 'ಕ್ಯಾಲ್ಕುಲೇಟರ್'), 'calculators', Seva.tones[4]),
      (Icons.pin_drop, 'DIGIPIN', 'digipin', Seva.tones[2]),
      (Icons.password, context.tr('Authenticator', 'ದೃಢೀಕರಣ ಕೋಡ್'), 'totp', Seva.tones[0]),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(builder: (context, c) {
        final w = (c.maxWidth - 20) / 3;
        return Wrap(spacing: 10, runSpacing: 10, children: [
          for (final i in items)
            SizedBox(
              width: w,
              child: SevaCard(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                onTap: () => openRoute(i.$3),
                child: Column(children: [
                  IconBadge(i.$1, color: i.$4, size: 40),
                  const SizedBox(height: 7),
                  Text(i.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
        ]);
      }),
    );
  }
}

class _Channels extends StatelessWidget {
  const _Channels();

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, String, Color)>[
      (Icons.graphic_eq, context.tr('Voice bot', 'ಧ್ವನಿ ಬಾಟ್'), context.tr('Talk to Seva', 'ಸೇವಾ ಜೊತೆ ಮಾತನಾಡಿ'), 'voice', Seva.tones[0]),
      (Icons.forum, 'WhatsApp', context.tr('Services on chat', 'ಚಾಟ್‌ನಲ್ಲಿ ಸೇವೆಗಳು'), 'whatsapp', Seva.tones[7]),
      (Icons.sms, 'SMS', context.tr('No internet needed', 'ಇಂಟರ್ನೆಟ್ ಬೇಕಿಲ್ಲ'), 'sms', Seva.tones[5]),
      (Icons.call, '1902', context.tr('Helpline, 24x7', 'ಸಹಾಯವಾಣಿ, 24x7'), 'help', Seva.tones[2]),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SevaCard(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(children: [
          for (final (n, i) in items.indexed) ...[
            if (n > 0) const Divider(indent: 66, height: 1),
            ListTile(
              leading: IconBadge(i.$1, color: i.$5, size: 38),
              title: Text(i.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(i.$3),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => openRoute(i.$4),
            ),
          ],
        ]),
      ),
    );
  }
}
