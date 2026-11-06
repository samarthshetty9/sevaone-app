import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sevaone_app/app/state.dart';
import 'package:sevaone_app/app/theme.dart';
import 'package:sevaone_app/data/seed.dart';
import 'package:sevaone_app/router.dart';
import 'package:sevaone_app/screens/apply.dart';
import 'package:sevaone_app/screens/bills.dart';
import 'package:sevaone_app/screens/extras.dart';
import 'package:sevaone_app/screens/locker.dart';
import 'package:sevaone_app/screens/services.dart';
import 'package:sevaone_app/screens/shell.dart';
import 'package:sevaone_app/screens/track.dart';

const routes = [
  'bills', 'centres', 'eligibility', 'grievance', 'feedback', 'help', 'chat', 'voice', 'sms',
  'scanner', 'weather', 'notifications', 'accessibility', 'digilocker', 'verify',
  'search', 'life', 'calculators', 'digipin', 'emergency', 'helplines', 'jobs', 'transactions',
  'family', 'myqr', 'isl', 'signal', 'directory', 'whatsapp', 'totp', 'profile',
];

Widget host(Widget page, double scale) => AppScope(
      state: app,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: buildTheme(dark: app.darkMode, highContrast: false),
        builder: (c, child) => MediaQuery(
          data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: page,
      ),
    );

Future<void> open(WidgetTester t, Widget page, double scale) async {
  t.view.physicalSize = const Size(390, 844);
  t.view.devicePixelRatio = 1;
  await t.pumpWidget(host(page, scale));
  await t.pump(const Duration(seconds: 4));
  await t.pumpWidget(const SizedBox());
  await t.pump(const Duration(seconds: 8));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => app.load());

  for (final (lang, scale) in [('en', 1.0), ('kn', 1.0), ('en', 1.6), ('kn', 1.6)]) {
    group('$lang @ $scale', () {
      setUp(() {
        app.lang = lang;
      });

      for (final linked in [false, true]) {
        testWidgets('tabs, DigiLocker linked: $linked', (t) async {
          linked ? app.linkDigilocker() : app.unlinkDigilocker();
          await open(t, const Shell(), scale);
          for (var i = 1; i < 4; i++) {
            shellTab.value = i;
            await open(t, const Shell(), scale);
          }
          shellTab.value = 0;
        });
      }

      testWidgets('AI home', (t) async {
        app.aiMode = true;
        await open(t, const Shell(), scale);
        app.aiMode = false;
      });

      for (final r in routes) {
        testWidgets('route $r', (t) async => open(t, pageFor(r)!, scale));
      }

      testWidgets('detail pages', (t) async {
        for (final v in [...services, ...schemes]) {
          await open(t, ServiceDetail(v), scale);
          await open(t, ApplyFlow(v), scale);
        }
        for (final a in app.applications) {
          await open(t, ApplicationDetail(a), scale);
        }
        for (final b in app.bills) {
          await open(t, BillDetail(b), scale);
        }
        for (final d in docTypes) {
          await open(t, DocumentView(d), scale);
        }
        for (final e in lifeEvents) {
          await open(t, LifeEventDetail(e), scale);
        }
      });
    });
  }

  test('every route used by the feature map resolves', () {
    expect(routes.every((r) => pageFor(r) != null), isTrue);
  });

  test('money uses Indian digit grouping', () {
    expect(money(1284), '₹1,284');
    expect(money(180000), '₹1,80,000');
    expect(money(1000000), '₹10,00,000');
  });

  test('recommender respects the eligibility rules', () {
    final p = app.profile
      ..age = 34
      ..gender = 'female'
      ..bpl = true
      ..occupation = 'homemaker'
      ..disabled = false;
    final names = app.recommendedSchemes.map((s) => s.name.en);
    expect(names, contains('Gruha Lakshmi'));
    expect(names, isNot(contains('Old Age Pension')));
    p.age = 65;
    expect(app.recommendedSchemes.map((s) => s.name.en), contains('Old Age Pension'));
    p.age = 34;
  });

  test('tracking finds all three sources', () {
    for (final id in ['KAR-REV-2026-104512', 'SKL-GSC-2026-778120', 'tkn-8842-1190']) {
      expect(app.findApplication(id), isNotNull, reason: id);
    }
    expect(app.findApplication('NOPE'), isNull);
  });
}
