// Renders every screen to PNG with the real fonts:
//   flutter test tool/capture_screens_test.dart --update-goldens
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sevaone_app/app/state.dart';
import 'package:sevaone_app/data/seed.dart';
import 'package:sevaone_app/main.dart';
import 'package:sevaone_app/router.dart';
import 'package:sevaone_app/screens/ai_home.dart';
import 'package:sevaone_app/screens/apply.dart';
import 'package:sevaone_app/screens/assistant.dart';
import 'package:sevaone_app/screens/bills.dart';
import 'package:sevaone_app/screens/extras.dart';
import 'package:sevaone_app/screens/locker.dart';
import 'package:sevaone_app/screens/scanner.dart';
import 'package:sevaone_app/screens/services.dart';
import 'package:sevaone_app/screens/shell.dart';
import 'package:sevaone_app/screens/support.dart';
import 'package:sevaone_app/screens/track.dart';
import 'package:sevaone_app/data/models.dart';

Future<void> loadFont(String family, List<String> paths) async {
  final l = FontLoader(family);
  for (final p in paths) {
    l.addFont(rootBundle.load(p));
  }
  await l.load();
}

class Shot {
  final String name;
  final String group;
  final String title;
  final Widget? page;
  final String? route;
  final int tab;
  final double h;
  final VoidCallback? setup;
  final Future<void> Function(WidgetTester)? act;
  final bool settle;
  Shot(this.group, this.name, this.title,
      {this.page, this.route, this.tab = 0, this.h = 844, this.setup, this.act, this.settle = false});
}

extension on WidgetTester {
  Future<void> tapT(String s) async {
    final f = find.text(s, skipOffstage: false);
    await ensureVisible(f.last);
    await pump();
    await tap(f.last, warnIfMissed: false);
    await pump(const Duration(milliseconds: 300));
    await pump(const Duration(milliseconds: 500));
  }

  Future<void> secs(int n) async {
    for (var i = 0; i < n * 2; i++) {
      await pump(const Duration(milliseconds: 500));
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await app.load();
    await loadFont('NotoSans', [for (final w in [400, 500, 600, 700]) 'assets/fonts/NotoSans-$w.ttf']);
    await loadFont('NotoKannada', ['assets/fonts/NotoKannada-400.ttf', 'assets/fonts/NotoKannada-600.ttf']);
    final root = Platform.environment['FLUTTER_ROOT']!;
    final icons = File('$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    final bytes = icons.readAsBytesSync();
    final loader = FontLoader('MaterialIcons')..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
  });

  void linked() => app.linkDigilocker();

  final shots = <Shot>[
    Shot('Getting started', 'language', 'Choose language', setup: () => app.onboarded = false),
    Shot('Getting started', 'login', 'Sign in', setup: () {
      app.onboarded = true;
      app.loggedIn = false;
    }),
    Shot('Home', 'home', 'Home (full page)', h: 2050),
    Shot('Home', 'ai', 'Seva AI home', setup: () => app.aiMode = true),
    Shot('Home', 'ask', 'Ask Seva', route: 'ask'),
    Shot('Home', 'notifications', 'Notifications', route: 'notifications'),
    Shot('Home', 'push', 'Push notification', setup: () {
      app.banner = AppNotification('p', const L('Income Certificate: update', ''),
          const L('Now at: Tahsildar approval', ''), DateTime.now(), 'application');
    }),
    Shot('Home', 'search', 'Search', route: 'search', h: 1100),
    Shot('Services', 'services', 'Services tab (full page)', tab: 1, h: 1900),
    Shot('Services', 'detail', 'Service detail', page: ServiceDetail(services.first), h: 1150, setup: linked),
    Shot('Services', 'apply1', 'Apply: your details', page: ApplyFlow(services.first)),
    Shot('Services', 'apply2', 'Apply: auto-fetched documents', page: ApplyFlow(services.first), setup: linked,
        act: (t) async {
      await t.tapT('Continue');
      await t.tapT('Fetch 3 documents');
      await t.secs(3);
    }),
    Shot('Services', 'apply3', 'Apply: Aadhaar e-Sign', page: ApplyFlow(services.first), setup: linked,
        act: (t) async {
      await t.tapT('Continue');
      await t.tapT('Fetch 3 documents');
      await t.secs(3);
      await t.tapT('Continue');
      await t.tapT('Sign with Aadhaar');
      await t.secs(3);
    }),
    Shot('Services', 'directory', 'Service directory', route: 'directory'),
    Shot('Schemes', 'schemes', 'Schemes tab (full page)', tab: 1, h: 2100, setup: () => servicesTab.value = 1),
    Shot('Schemes', 'scheme', 'Scheme detail', page: ServiceDetail(schemes.first), h: 1100),
    Shot('Schemes', 'finder', 'Scheme finder', route: 'eligibility', setup: () => app.profile.completed = false),
    Shot('Schemes', 'matches', 'Your matches', route: 'eligibility', h: 1200, setup: () => app.profile.completed = true),
    Shot('Schemes', 'life', 'Life events', route: 'life'),
    Shot('Schemes', 'lifeevent', 'Situation steps', page: LifeEventDetail(lifeEvents.first), h: 960),
    Shot('Track', 'track', 'Track tab', tab: 3, h: 980),
    Shot('Track', 'status', 'Application status', page: ApplicationDetail(app.applications.first)),
    Shot('Documents', 'docs0', 'Documents (not linked)', tab: 2, h: 1250, setup: () => app.unlinkDigilocker()),
    Shot('Documents', 'link', 'DigiLocker consent', route: 'digilocker', h: 1020),
    Shot('Documents', 'docs1', 'Documents (linked)', tab: 2, h: 1500, setup: linked),
    Shot('Documents', 'doc', 'Document view', page: DocumentView(docTypes[1])),
    Shot('Documents', 'verifyhome', 'Verify a document', route: 'verify'),
    Shot('Documents', 'verify', 'Verified result', page: VerifyScreen(docTypes[1]),
        act: (t) async => t.secs(3)),
    Shot('Documents', 'scan', 'Scanner', route: 'scanner', act: (t) async => t.secs(2)),
    Shot('Documents', 'ocr', 'OCR extracted text',
        page: OcrScreen(ScannedDoc('x', const L('Ration card', ''), 'ration', 'Auto', DateTime.now())),
        h: 920, act: (t) async {
      await t.tapT('Extract text (OCR)');
      await t.secs(3);
    }),
    Shot('Payments', 'bills', 'Bills and payments', route: 'bills'),
    Shot('Payments', 'bill', 'Bill detail', page: BillDetail(app.bills.first)),
    Shot('Payments', 'addbill', 'Add a bill', route: 'addbill'),
    Shot('Payments', 'pay', 'Checkout', page: PaymentScreen(title: 'BESCOM', amount: 1284, onPaid: () {})),
    Shot('Payments', 'tx', 'Transaction history', route: 'transactions'),
    Shot('Payments', 'calc', 'Calculators', route: 'calculators'),
    Shot('Help', 'help', 'Help', route: 'help', h: 980),
    Shot('Help', 'voice', 'Voice bot', page: const VoiceBotScreen(), act: (t) async {
      await t.tapT('What is my application status?');
      await t.secs(3);
    }),
    Shot('Help', 'chat', 'Live chat', route: 'chat', act: (t) async => t.secs(2)),
    Shot('Help', 'whatsapp', 'WhatsApp', route: 'whatsapp', act: (t) async => t.secs(2)),
    Shot('Help', 'sms', 'SMS', route: 'sms'),
    Shot('Help', 'ivr', '1902 phone menu', page: const IvrScreen()),
    Shot('Help', 'grievance', 'Grievance (iPGRS)', route: 'grievance', h: 1020),
    Shot('Help', 'feedback', 'Feedback', route: 'feedback'),
    Shot('Help', 'emergency', 'Emergency', route: 'emergency'),
    Shot('Help', 'helplines', 'Helplines', route: 'helplines', h: 960),
    Shot('Local info', 'centres', 'GramaOne / Karnataka One centres', route: 'centres', h: 1000),
    Shot('Local info', 'weather', 'Weather and AQI', route: 'weather', h: 1120),
    Shot('Local info', 'jobs', 'Job openings', route: 'jobs'),
    Shot('Local info', 'digipin', 'DIGIPIN', route: 'digipin', act: (t) async => t.secs(2)),
    Shot('Local info', 'totp', 'Authenticator', route: 'totp'),
    Shot('Local info', 'signal', 'Mobile signal check', route: 'signal', act: (t) async => t.secs(3)),
    Shot('Profile', 'profile', 'Profile (full page)', route: 'profile', h: 1420),
    Shot('Profile', 'family', 'Family profiles', route: 'family'),
    Shot('Profile', 'qr', 'My QR code', route: 'myqr'),
    Shot('Profile', 'isl', 'Sign language chatbot', route: 'isl'),
    Shot('Profile', 'a11y', 'Accessibility', route: 'accessibility', h: 960),
    Shot('Kannada and dark mode', 'kn_home', 'Home in Kannada', h: 2050, setup: () => app.lang = 'kn'),
    Shot('Kannada and dark mode', 'kn_ai', 'Seva AI in Kannada', setup: () {
      app.lang = 'kn';
      app.aiMode = true;
    }),
    Shot('Kannada and dark mode', 'kn_services', 'Services in Kannada', tab: 1, setup: () => app.lang = 'kn'),
    Shot('Kannada and dark mode', 'dark_home', 'Home in dark mode', setup: () => app.darkMode = true),
    Shot('Kannada and dark mode', 'dark_docs', 'Documents in dark mode', tab: 2, setup: () {
      app.darkMode = true;
      linked();
    }),
    Shot('Kannada and dark mode', 'contrast', 'High contrast', setup: () => app.highContrast = true),
  ];

  for (final s in shots) {
    testWidgets(s.name, (t) async {
      debugDisableShadows = false;
      app
        ..onboarded = true
        ..loggedIn = true
        ..lang = 'en'
        ..aiMode = false
        ..darkMode = false
        ..highContrast = false
        ..banner = null
        ..profile.completed = false;
      app.unlinkDigilocker();
      shellTab.value = s.tab;
      servicesTab.value = 0;
      s.setup?.call();
      t.view.physicalSize = Size(780, s.h * 2);
      t.view.devicePixelRatio = 2;
      await t.pumpWidget(const SevaOneApp());
      await t.pump();
      await t.runAsync(() async {
        await precacheImage(const AssetImage('assets/images/sevasindhu-logo.png'),
            t.element(find.byType(MaterialApp)));
      });
      await t.pump();
      final route = s.route;
      if (route == 'addbill') {
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => const AddBillScreen()));
      } else if (route == 'ask') {
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => const AskScreen()));
      } else if (route != null) {
        openRoute(route);
      } else if (s.page != null) {
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => s.page!));
      }
      await t.pump();
      await t.pump(const Duration(milliseconds: 600));
      if (s.tab == 1 && s.name == 'schemes') {
        await t.pump(const Duration(milliseconds: 600));
      }
      await s.act?.call(t);
      await t.pump(const Duration(milliseconds: 400));
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('../screenshots/${s.name}.png'));
      debugDisableShadows = true;
      await t.pumpWidget(const SizedBox());
      await t.pump(const Duration(seconds: 60));
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  tearDownAll(() {
    File('screenshots/index.tsv').writeAsStringSync(
        shots.map((s) => '${s.group}\t${s.name}\t${s.title}').join('\n'));
  });
}
