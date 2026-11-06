import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sevaone_app/app/state.dart';
import 'package:sevaone_app/app/theme.dart';
import 'package:sevaone_app/data/seed.dart';
import 'package:sevaone_app/screens/ai_home.dart';
import 'package:sevaone_app/screens/assistant.dart';
import 'package:sevaone_app/screens/bills.dart';
import 'package:sevaone_app/screens/extras.dart';
import 'package:sevaone_app/screens/locker.dart';
import 'package:sevaone_app/screens/scanner.dart';
import 'package:sevaone_app/screens/services.dart';
import 'package:sevaone_app/screens/sms.dart';
import 'package:sevaone_app/screens/support.dart';

Widget host(Widget page) => AppScope(
      state: app,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: buildTheme(dark: false, highContrast: false),
        home: page,
      ),
    );

extension on WidgetTester {
  Future<void> go(Widget page) async {
    view.physicalSize = const Size(390, 844);
    view.devicePixelRatio = 1;
    await pumpWidget(host(page));
    await pump();
  }

  Future<void> tapText(String t) async {
    final f = find.text(t);
    await ensureVisible(f.first);
    await pump();
    await tap(f.first);
    await pump(const Duration(milliseconds: 400));
  }

  Future<void> wait(int s) async {
    for (var i = 0; i < s * 2; i++) {
      await pump(const Duration(milliseconds: 500));
    }
  }
}

void main() {
  setUpAll(() async => app.load());
  setUp(() => app.resetDemo());

  testWidgets('DigiLocker link fills every document type', (t) async {
    await t.go(const DigilockerLinkScreen());
    await t.tapText('Allow');
    await t.wait(4);
    expect(find.text('DigiLocker linked'), findsOneWidget);
    expect(app.lockerDocs.length, docTypes.length);
  });

  testWidgets('Apply: fetch docs, e-Sign, pay, submit, then status advances with a push',
      (t) async {
    app.linkDigilocker();
    final before = app.applications.length;
    await t.go(ServiceDetail(services.first));
    await t.tapText('Apply now');
    await t.pump(const Duration(milliseconds: 500));
    await t.tapText('Continue');
    await t.tapText('Fetch 3 documents');
    await t.wait(3);
    await t.tapText('Continue');
    await t.tapText('Sign with Aadhaar');
    await t.wait(3);
    await t.tapText('Continue');
    await t.tapText('Pay ₹40 and submit');
    await t.pump(const Duration(milliseconds: 500));
    await t.tapText('Pay ₹40');
    await t.wait(4);
    await t.tapText('Done');
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('Application submitted'), findsOneWidget);
    expect(app.applications.length, before + 1);
    expect(app.transactions.first.amount, 40);
    final a = app.applications.first;
    expect(a.current, 0);
    await t.wait(15);
    expect(a.current, 1);
    expect(app.banner, isNotNull);
    await t.wait(45);
  });

  testWidgets('Paying a bill marks it paid and logs a receipt', (t) async {
    final b = app.bills.first;
    await t.go(BillDetail(b));
    await t.tapText('Pay ₹1,284');
    await t.pump(const Duration(milliseconds: 500));
    await t.tapText('Pay ₹1,284');
    await t.wait(4);
    expect(b.paid, isTrue);
    expect(b.receipt, isNotNull);
    expect(app.transactions.first.amount, 1284);
  });

  testWidgets('Scan then OCR extracts fields', (t) async {
    await t.go(const ScannerScreen());
    await t.wait(2);
    await t.tap(find.bySemanticsLabel('Capture'));
    await t.pump(const Duration(milliseconds: 300));
    await t.tapText('Save');
    await t.pump(const Duration(milliseconds: 500));
    await t.tapText('Extract text (OCR)');
    await t.wait(4);
    expect(app.scans.first.ocr!['Card number'], 'KA-BPL-29-004417');
    expect(find.text('Extracted details'), findsOneWidget);
  });

  testWidgets('Situation search maps to its life event', (t) async {
    expect(matchLifeEvent('I had a baby')!.id, 'baby');
    expect(matchLifeEvent('ನನಗೆ ಮಗು ಜನಿಸಿದೆ')!.id, 'baby');
    expect(matchLifeEvent('we moved to Mysuru')!.id, 'moved');
    expect(matchLifeEvent('hello'), isNull);
    await t.go(const AskScreen());
    await t.enterText(find.byType(TextField), 'I had a baby');
    await t.pump();
    expect(find.text('I had a baby'), findsWidgets);
    await t.tapText('4 steps to follow');
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('Enrol the baby for Aadhaar'), findsOneWidget);
    await t.tap(find.byType(Checkbox).first);
    await t.pump();
    expect(find.text('1 of 4 done'), findsOneWidget);
  });

  testWidgets('Live chat and voice bot answer from real app state', (t) async {
    expect(app.l(think('Do I have any bills due?').text), contains('BESCOM'));
    expect(think('ನನ್ನ ಅರ್ಜಿ ಸ್ಥಿತಿ ಏನು?').route, 'track');
    await t.go(const VoiceBotScreen());
    await t.tapText('What is my application status?');
    await t.wait(5);
    expect(find.text('Open tracker'), findsOneWidget);
  });

  testWidgets('SMS commands respond', (t) async {
    await t.go(const SmsScreen());
    await t.enterText(find.byType(TextField), 'BILL');
    await t.tap(find.byIcon(Icons.send_rounded));
    await t.wait(2);
    expect(find.textContaining('BESCOM ₹1,284'), findsOneWidget);
  });

  testWidgets('Grievance registers with an iPGRS id', (t) async {
    final n = app.grievances.length;
    await t.go(const GrievanceScreen());
    await t.enterText(find.byType(TextField).at(0), 'Streetlight fault');
    await t.enterText(find.byType(TextField).at(1), 'Not working for a week');
    await t.pump();
    await t.tapText('Submit grievance');
    expect(app.grievances.length, n + 1);
    expect(app.grievances.first.id, startsWith('IPGRS-'));
    await t.wait(14);
    expect(app.grievances.first.stage, 1);
    await t.wait(6);
  });

  testWidgets('Add bill fetches an amount', (t) async {
    final n = app.bills.length;
    await t.go(const AddBillScreen());
    await t.enterText(find.byType(TextField), '12345678');
    await t.pump();
    await t.tapText('Fetch bill');
    await t.wait(2);
    expect(app.bills.length, n + 1);
    expect(app.bills.first.amount, greaterThan(0));
  });

  testWidgets('EMI calculator gives the correct figure', (t) async {
    await t.go(const CalculatorsScreen());
    // ₹5,00,000 at 9% over 5 years is ₹10,379 a month.
    expect(find.text('₹10,379'), findsOneWidget);
  });
}
