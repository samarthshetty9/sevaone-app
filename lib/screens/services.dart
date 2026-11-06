import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../router.dart';
import '../app/theme.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';
import 'apply.dart';
import 'assistant.dart';
import 'more.dart';
import 'shell.dart';

/// Feature 10: services and schemes are separate sections, and the catalogue
/// draws on more than Service Plus.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with SingleTickerProviderStateMixin {
  late final TabController tabs =
      TabController(length: 2, vsync: this, initialIndex: servicesTab.value);

  @override
  void initState() {
    super.initState();
    servicesTab.addListener(_sync);
    tabs.addListener(_record);
  }

  void _sync() {
    if (tabs.index != servicesTab.value) tabs.animateTo(servicesTab.value);
  }

  // Keeps servicesTab current after a swipe, so "open Schemes" always fires.
  void _record() => servicesTab.value = tabs.index;

  @override
  void dispose() {
    servicesTab.removeListener(_sync);
    tabs.removeListener(_record);
    tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SevaBar(
        automaticallyImplyLeading: false,
        title: Text(context.tr('Services and schemes', 'ಸೇವೆಗಳು ಮತ್ತು ಯೋಜನೆಗಳು')),
        actions: [
          IconButton(
            tooltip: context.tr('Search', 'ಹುಡುಕಿ'),
            onPressed: () => openRoute('search'),
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: TabBar(
            controller: tabs,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Seva.gold,
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            tabs: [
          Tab(text: context.tr('Services', 'ಸೇವೆಗಳು')),
          Tab(text: context.tr('Schemes', 'ಯೋಜನೆಗಳು')),
        ]),
      ),
      body: TabBarView(controller: tabs, children: const [_ServicesTab(), _SchemesTab()]),
    );
  }
}

class _Tile {
  final IconData icon;
  final String label;
  final VoidCallback tap;
  const _Tile(this.icon, this.label, this.tap);
}

class _ServicesTab extends StatefulWidget {
  const _ServicesTab();

  @override
  State<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<_ServicesTab> {
  String explore = 'popular';

  Service _by(String code) => [...services, ...schemes].firstWhere((v) => v.code == code);
  VoidCallback _open(String code) => () => push(context, ServiceDetail(_by(code)));

  Widget _group(String title, List<_Tile> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title),
      SizedBox(
        height: 104 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.5),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            for (final t in items)
              SizedBox(
                width: 88,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: t.tap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Column(children: [
                      IconBadge(t.icon, size: 50),
                      const SizedBox(height: 6),
                      Text(t.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                ),
              ),
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final curated = [...services, ...schemes];
    final lists = {
      'popular': ['SVC001', 'SVC030', 'SVC020', 'SCH5135'],
      'trending': ['SVC003', 'SCH8000', 'SVC040', 'SCH8300'],
      'new': ['SVC060', 'SCH8200', 'SVC050', 'SVC031'],
    };
    final cats = <String, (IconData, List<Service>)>{};
    for (final v in curated) {
      cats.putIfAbsent(context.loc(v.category), () => (v.icon, [])).$2.add(v);
    }
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      _group(context.tr('Certificates', 'ಪ್ರಮಾಣಪತ್ರಗಳು'), [
        _Tile(Icons.account_balance_wallet_outlined, context.tr('Income', 'ಆದಾಯ'), _open('SVC001')),
        _Tile(Icons.badge_outlined, context.tr('Caste', 'ಜಾತಿ'), _open('SVC002')),
        _Tile(Icons.home_outlined, context.tr('Residence', 'ವಾಸಸ್ಥಳ'), _open('SVC003')),
        _Tile(Icons.child_care_outlined, context.tr('Birth', 'ಜನನ'), _open('SVC010')),
        _Tile(Icons.favorite_border, context.tr('Marriage', 'ವಿವಾಹ'), _open('SVC011')),
      ]),
      _group(context.tr('Students', 'ವಿದ್ಯಾರ್ಥಿಗಳು'), [
        _Tile(Icons.menu_book_outlined, context.tr('Scholarship', 'ವಿದ್ಯಾರ್ಥಿವೇತನ'), _open('SCH7300')),
        _Tile(Icons.directions_bus_outlined, context.tr('Bus pass', 'ಬಸ್ ಪಾಸ್'), _open('SVC050')),
        _Tile(Icons.school_outlined, context.tr('Marks card', 'ಅಂಕಪಟ್ಟಿ'), () => openRoute('documents')),
      ]),
      _group(context.tr('Everyday', 'ದೈನಂದಿನ'), [
        _Tile(Icons.bolt_outlined, context.tr('Electricity', 'ವಿದ್ಯುತ್'), () => openRoute('bills')),
        _Tile(Icons.water_drop_outlined, context.tr('Water', 'ನೀರು'), () => openRoute('bills')),
        _Tile(Icons.rice_bowl_outlined, context.tr('Ration card', 'ಪಡಿತರ ಚೀಟಿ'), _open('SVC040')),
        _Tile(Icons.location_on_outlined, context.tr('Centres', 'ಕೇಂದ್ರಗಳು'), () => openRoute('centres')),
      ]),
      _group(context.tr('Farmers', 'ರೈತರು'), [
        _Tile(Icons.landscape_outlined, context.tr('Land record', 'ಭೂ ದಾಖಲೆ'), _open('SVC030')),
        _Tile(Icons.grass_outlined, context.tr('Raitha Siri', 'ರೈತ ಸಿರಿ'), _open('SCH8100')),
        _Tile(Icons.agriculture_outlined, context.tr('Vidyanidhi', 'ವಿದ್ಯಾನಿಧಿ'), _open('SCH7200')),
      ]),
      SectionHeader(context.tr('Explore', 'ಅನ್ವೇಷಿಸಿ')),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 8, children: [
          for (final (k, l) in [
            ('popular', context.tr('Popular', 'ಜನಪ್ರಿಯ')),
            ('trending', context.tr('Trending', 'ಟ್ರೆಂಡಿಂಗ್')),
            ('new', context.tr("What's new", 'ಹೊಸದು')),
          ])
            ChoiceChip(
                label: Text(l),
                selected: explore == k,
                onSelected: (_) => setState(() => explore = k)),
        ]),
      ),
      const SizedBox(height: 8),
      for (final c in lists[explore]!)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
          child: ServiceRow(_by(c)),
        ),
      SectionHeader(context.tr('Categories', 'ವರ್ಗಗಳು')),
      for (final e in cats.entries)
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: IconBadge(e.value.$1, size: 38),
          title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: Text('${e.value.$2.length}'),
          onTap: () => push(context, ServiceListScreen(e.key, e.value.$2)),
        ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: OutlinedButton.icon(
          onPressed: () => openRoute('directory'),
          icon: const Icon(Icons.menu_book_outlined),
          label: Text(context.tr('All ${s.catalogue.length + curated.length} services by department',
              'ಇಲಾಖೆವಾರು ಎಲ್ಲಾ ${s.catalogue.length + curated.length} ಸೇವೆಗಳು')),
        ),
      ),
    ]);
  }
}

class _SchemesTab extends StatefulWidget {
  const _SchemesTab();

  @override
  State<_SchemesTab> createState() => _SchemesTabState();
}

class _SchemesTabState extends State<_SchemesTab> {
  String by = 'category';

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final all = [...schemes, ...s.catalogue.where((v) => v.isScheme)];
    final recs = s.profile.completed ? s.recommendedSchemes : schemes.where((v) => v.featured).toList();
    final trending = schemes.take(4);
    final groups = <String, List<Service>>{};
    for (final v in all) {
      groups.putIfAbsent(context.loc(by == 'category' ? v.category : v.dept), () => []).add(v);
    }
    final saved = all.where((v) => s.bookmarks.contains(v.code)).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(0, 12, 0, 24), children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SevaCard(
          onTap: () => openRoute('eligibility'),
          color: context.cs.primary.withValues(alpha: 0.09),
          child: Row(children: [
            Icon(Icons.auto_awesome, color: context.cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.profile.completed
                    ? context.tr('${s.recommendedSchemes.length} schemes match your profile',
                        '${s.recommendedSchemes.length} ಯೋಜನೆಗಳು ನಿಮ್ಮ ಪ್ರೊಫೈಲ್‌ಗೆ ಹೊಂದುತ್ತವೆ')
                    : context.tr('Check which schemes you qualify for',
                        'ನೀವು ಯಾವ ಯೋಜನೆಗಳಿಗೆ ಅರ್ಹರು ಎಂದು ಪರಿಶೀಲಿಸಿ'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right),
          ]),
        ),
      ),
      SectionHeader(context.tr('Recommended for you', 'ನಿಮಗಾಗಿ ಶಿಫಾರಸು')),
      SizedBox(
        height: 136 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.5),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            for (final v in recs)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 220,
                  child: SevaCard(
                    onTap: () => push(context, ServiceDetail(v)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(context.loc(v.dept),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(context.loc(v.name),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.tt.titleMedium),
                      ),
                      if (v.benefit != null)
                        Text(context.loc(v.benefit!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: context.cs.secondary, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ),
          ],
        ),
      ),
      if (saved.isNotEmpty) ...[
        SectionHeader(context.tr('Saved', 'ಉಳಿಸಿದವು')),
        for (final v in saved)
          Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 6), child: ServiceRow(v)),
      ],
      SectionHeader(context.tr('Trending', 'ಟ್ರೆಂಡಿಂಗ್')),
      for (final v in trending)
        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 6), child: ServiceRow(v)),
      SectionHeader(context.tr('Explore all ${all.length} schemes', 'ಎಲ್ಲಾ ${all.length} ಯೋಜನೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ')),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 8, children: [
          ChoiceChip(
              label: Text(context.tr('By category', 'ವರ್ಗದ ಪ್ರಕಾರ')),
              selected: by == 'category',
              onSelected: (_) => setState(() => by = 'category')),
          ChoiceChip(
              label: Text(context.tr('By department', 'ಇಲಾಖೆಯ ಪ್ರಕಾರ')),
              selected: by == 'dept',
              onSelected: (_) => setState(() => by = 'dept')),
        ]),
      ),
      const SizedBox(height: 4),
      for (final e in groups.entries)
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(e.key),
          subtitle: Text(context.tr('${e.value.length} schemes', '${e.value.length} ಯೋಜನೆಗಳು')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(context, ServiceListScreen(e.key, e.value)),
        ),
    ]);
  }
}

class ServiceRow extends StatelessWidget {
  final Service v;
  const ServiceRow(this.v, {super.key});

  @override
  Widget build(BuildContext context) {
    return SevaCard(
      onTap: () => push(context, ServiceDetail(v)),
      child: Row(children: [
        IconBadge(v.icon, color: v.isScheme ? context.cs.secondary : null),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.loc(v.name), style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(
              v.benefit != null ? context.loc(v.benefit!) : context.loc(v.dept),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13,
                  color: v.benefit != null ? context.cs.secondary : context.cs.onSurfaceVariant,
                  fontWeight: v.benefit != null ? FontWeight.w600 : FontWeight.w400),
            ),
          ]),
        ),
        Icon(Icons.chevron_right, color: context.cs.onSurfaceVariant),
      ]),
    );
  }
}

class ServiceDetail extends StatelessWidget {
  final Service v;
  const ServiceDetail(this.v, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final saved = s.bookmarks.contains(v.code);
    final elig = v.rule?.call(s.profile);

    Widget fact(IconData i, String k, String val) => Expanded(
          child: Semantics(
            label: '$k: $val',
            excludeSemantics: true,
            child: Column(children: [
              Icon(i, color: context.cs.primary, size: 22),
              const SizedBox(height: 4),
              Text(val,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(k,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
            ]),
          ),
        );

    return Scaffold(
      appBar: SevaBar(
        title: Text(v.isScheme ? context.tr('Scheme', 'ಯೋಜನೆ') : context.tr('Service', 'ಸೇವೆ')),
        actions: [
          IconButton(
            tooltip: saved ? context.tr('Remove bookmark', 'ಬುಕ್‌ಮಾರ್ಕ್ ತೆಗೆಯಿರಿ') : context.tr('Bookmark', 'ಬುಕ್‌ಮಾರ್ಕ್'),
            icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => app.set(() {
              saved ? app.bookmarks.remove(v.code) : app.bookmarks.add(v.code);
            }),
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlowPanel(
          colors: v.isScheme
              ? const [Color(0xFF0B5D5A), Color(0xFF0E9F8E)]
              : const [Seva.navy, Seva.blueDark, Seva.blue],
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Semantics(
                    header: true,
                    child: Text(context.loc(v.name),
                        style: context.tt.headlineSmall?.copyWith(color: Colors.white)),
                  ),
                  const SizedBox(height: 2),
                  Text(context.loc(v.dept), style: const TextStyle(color: Colors.white)),
                ]),
              ),
              const SizedBox(width: 8),
              IconArt(v.icon, size: 68),
            ]),
            const SizedBox(height: 12),
            Text(context.loc(v.desc),
                style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.4)),
          ]),
        ),
        if (s.readAloud) ...[
          const SizedBox(height: 12),
          ReadAloudBar(text: '${context.loc(v.name)}. ${context.loc(v.desc)}'),
        ],
        const SizedBox(height: 12),
        SevaCard(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (v.isScheme && v.benefit != null)
              fact(Icons.card_giftcard, context.tr('Benefit', 'ಸೌಲಭ್ಯ'), context.loc(v.benefit!))
            else
              fact(Icons.currency_rupee, context.tr('Fee', 'ಶುಲ್ಕ'),
                  v.fee == 0 ? context.tr('Free', 'ಉಚಿತ') : money(v.fee)),
            fact(Icons.schedule, context.tr('Sakala time', 'ಸಕಾಲ ಸಮಯ'),
                context.tr('${v.sakalaDays} days', '${v.sakalaDays} ದಿನ')),
            fact(Icons.folder_outlined, context.tr('Documents', 'ದಾಖಲೆಗಳು'), '${v.docs.length}'),
          ]),
        ),
        const SizedBox(height: 12),
        if (v.ruleText != null) ...[
          const SizedBox(height: 12),
          SevaCard(
            color: (elig == true ? context.cs.secondary : context.cs.primary)
                .withValues(alpha: 0.09),
            child: Row(children: [
              Icon(elig == true ? Icons.check_circle : Icons.help_outline,
                  color: elig == true ? context.cs.secondary : context.cs.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(context.tr('Who can apply', 'ಯಾರು ಅರ್ಜಿ ಸಲ್ಲಿಸಬಹುದು'),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(context.loc(v.ruleText!)),
                ]),
              ),
            ]),
          ),
        ],
        SectionTitle(context.tr('Documents needed', 'ಅಗತ್ಯ ದಾಖಲೆಗಳು')),
        const SizedBox(height: 6),
        SevaCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: [
            for (final id in v.docs)
              ListTile(
                leading: IconBadge(docById(id).icon, size: 36),
                title: Text(context.loc(docById(id).name),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: s.lockerDocs.contains(id)
                    ? Pill(context.tr('Ready', 'ಸಿದ್ಧ'),
                        color: context.cs.secondary, icon: Icons.check)
                    : null,
              ),
          ]),
        ),
        SectionTitle(context.tr('How it works', 'ಇದು ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ')),
        for (final (i, t) in [
          context.tr('Confirm your details', 'ನಿಮ್ಮ ವಿವರಗಳನ್ನು ದೃಢೀಕರಿಸಿ'),
          context.tr('Documents fill in from DigiLocker', 'ದಾಖಲೆಗಳು ಡಿಜಿಲಾಕರ್‌ನಿಂದ ಭರ್ತಿಯಾಗುತ್ತವೆ'),
          context.tr('Sign with Aadhaar e-Sign', 'ಆಧಾರ್ ಇ-ಸೈನ್ ಮೂಲಕ ಸಹಿ ಮಾಡಿ'),
          context.tr('Pay and follow live status', 'ಪಾವತಿಸಿ ಮತ್ತು ನೇರ ಸ್ಥಿತಿ ನೋಡಿ'),
        ].indexed)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: context.cs.primary.withValues(alpha: 0.13),
                child: Text('${i + 1}',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700, color: context.cs.primary)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(t)),
            ]),
          ),
      ]),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: () => push(context, ApplyFlow(v)),
          child: Text(context.tr('Apply now', 'ಈಗ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ')),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Semantics(header: true, child: Text(text, style: context.tt.titleMedium)),
    );
  }
}

class SearchScreen extends StatefulWidget {
  final bool voice;
  const SearchScreen({super.key, this.voice = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final c = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.voice) WidgetsBinding.instance.addPostFrameCallback((_) => listen());
  }

  Future<void> listen() async {
    final heard = await showVoiceSearch(context);
    if (heard != null && mounted) setState(() => c.text = heard);
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final results = s.searchAll(c.text);
    final hints = [
      context.tr('Income', 'ಆದಾಯ'),
      context.tr('Pension', 'ಪಿಂಚಣಿ'),
      context.tr('Licence', 'ಪರವಾನಗಿ'),
      context.tr('Ration', 'ಪಡಿತರ'),
      context.tr('Scholarship', 'ವಿದ್ಯಾರ್ಥಿವೇತನ'),
    ];
    return Scaffold(
      appBar: SevaBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: TextField(
            controller: c,
            autofocus: !widget.voice,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              isDense: true,
              hintText: context.tr('Search all services', 'ಎಲ್ಲಾ ಸೇವೆಗಳನ್ನು ಹುಡುಕಿ'),
              suffixIcon: IconButton(
                tooltip: context.tr('Search by voice', 'ಧ್ವನಿಯ ಮೂಲಕ ಹುಡುಕಿ'),
                icon: const Icon(Icons.mic_none_rounded),
                onPressed: listen,
              ),
            ),
          ),
        ),
      ),
      body: c.text.trim().isEmpty
          ? ListView(padding: const EdgeInsets.all(16), children: [
              Text(context.tr('Try', 'ಪ್ರಯತ್ನಿಸಿ'),
                  style: TextStyle(color: context.cs.onSurfaceVariant)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final h in hints)
                  ActionChip(
                      label: Text(h), onPressed: () => setState(() => c.text = h)),
              ]),
              SectionTitle(context.tr('Most searched services', 'ಹೆಚ್ಚು ಹುಡುಕಿದ ಸೇವೆಗಳು')),
              const SizedBox(height: 6),
              for (final v in services.where((v) => v.featured).take(3))
                Padding(padding: const EdgeInsets.only(bottom: 6), child: ServiceRow(v)),
              SectionTitle(context.tr('Most searched schemes', 'ಹೆಚ್ಚು ಹುಡುಕಿದ ಯೋಜನೆಗಳು')),
              const SizedBox(height: 6),
              for (final v in schemes.where((v) => v.featured).take(3))
                Padding(padding: const EdgeInsets.only(bottom: 6), child: ServiceRow(v)),
            ])
          : results.isEmpty
              ? EmptyState(
                  icon: Icons.search_off,
                  title: context.tr('Nothing found', 'ಏನೂ ಸಿಗಲಿಲ್ಲ'),
                  body: context.tr('Try a simpler word, or ask the voice bot.',
                      'ಸರಳ ಪದ ಪ್ರಯತ್ನಿಸಿ, ಅಥವಾ ಧ್ವನಿ ಬಾಟ್ ಅನ್ನು ಕೇಳಿ.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (_, i) => ServiceRow(results[i]),
                ),
    );
  }
}
