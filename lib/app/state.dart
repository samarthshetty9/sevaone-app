import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models.dart';
import '../data/seed.dart';

/// The whole "backend". A single in-memory store; nothing leaves the device.
/// Screens read it with `context.tr` / `context.watchApp` in build (which
/// subscribes them to changes) and use the global [app] in callbacks.
final app = AppState();
final navigatorKey = GlobalKey<NavigatorState>();

class AppState extends ChangeNotifier {
  // Session
  bool onboarded = false;
  bool loggedIn = false;

  // Language & accessibility (features 4, 12)
  String lang = 'en';
  double textScale = 1.0;
  bool highContrast = false;
  bool darkMode = false;
  bool reduceMotion = false;
  bool readAloud = false;
  bool biometric = false;
  bool aiMode = false;
  final Set<String> doneSteps = {};
  final List<Txn> transactions = [
    Txn(const L('BESCOM electricity bill', 'ಬೆಸ್ಕಾಂ ವಿದ್ಯುತ್ ಬಿಲ್'), 1096, 'RCP204418203',
        DateTime.now().subtract(const Duration(days: 8))),
    Txn(const L('BWSSB water bill', 'ಬಿಡಬ್ಲ್ಯುಎಸ್‌ಎಸ್‌ಬಿ ನೀರಿನ ಬಿಲ್'), 438, 'RCP204417761',
        DateTime.now().subtract(const Duration(days: 12))),
    Txn(const L('Residence Certificate fee', 'ವಾಸಸ್ಥಳ ಪ್ರಮಾಣಪತ್ರ ಶುಲ್ಕ'), 40, 'RCP204418817',
        DateTime.now().subtract(const Duration(days: 19))),
    Txn(const L('BESCOM electricity bill', 'ಬೆಸ್ಕಾಂ ವಿದ್ಯುತ್ ಬಿಲ್'), 982, 'RCP203911647',
        DateTime.now().subtract(const Duration(days: 38))),
    Txn(const L('BWSSB water bill', 'ಬಿಡಬ್ಲ್ಯುಎಸ್‌ಎಸ್‌ಬಿ ನೀರಿನ ಬಿಲ್'), 411, 'RCP203908125',
        DateTime.now().subtract(const Duration(days: 42))),
    Txn(const L('Land record (RTC) fee', 'ಭೂ ದಾಖಲೆ (ಪಹಣಿ) ಶುಲ್ಕ'), 15, 'RCP203522980',
        DateTime.now().subtract(const Duration(days: 61))),
  ];
  final List<FamilyMember> family = [
    FamilyMember('Mahesh Gowda', 'Spouse'),
    FamilyMember('Tara Gowda', 'Child'),
  ];

  // Data
  final CitizenProfile profile = CitizenProfile();
  bool digilockerLinked = false;
  final Set<String> lockerDocs = {};
  final List<ScannedDoc> scans = [];
  late List<Application> applications = seedApplications();
  late List<Bill> bills = seedBills();
  final List<Grievance> grievances = [
    Grievance('IPGRS-2026-55102', 'Revenue Department', 'Delay in RTC correction',
        'Correction was requested two months ago.',
        DateTime.now().subtract(const Duration(days: 12)),
        stage: 2),
  ];
  final List<FeedbackEntry> feedback = [];
  final Set<String> bookmarks = {};
  String weatherDistrict = 'Bengaluru Urban';

  // Notifications (feature 21)
  final List<AppNotification> notifications = [];
  AppNotification? banner;
  Timer? _bannerTimer;
  final Map<String, bool> pushPrefs = {
    'application': true,
    'bill': true,
    'scheme': true,
    'weather': true,
  };

  // Catalogue
  List<Service> catalogue = [];

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/data/catalog.json');
    final curated = {...services, ...schemes}.map((s) => s.name.en.toLowerCase()).toSet();
    catalogue = [
      for (final m in (jsonDecode(raw) as List).cast<Map<String, dynamic>>())
        if (!curated.contains((m['name'] as String).toLowerCase()))
          Service(
            code: m['code'] as String,
            name: L(m['name'] as String, m['name'] as String),
            dept: L(m['dept'] as String, m['dept'] as String),
            category: L(m['scheme'] == true ? 'Schemes' : 'Department services',
                m['scheme'] == true ? 'ಯೋಜನೆಗಳು' : 'ಇಲಾಖೆ ಸೇವೆಗಳು'),
            desc: L(
                (m['desc'] as String).isEmpty ? m['name'] as String : m['desc'] as String,
                (m['desc'] as String).isEmpty ? m['name'] as String : m['desc'] as String),
            isScheme: m['scheme'] == true,
            docs: const ['aadhaar'],
          ),
    ];
    _seedNotifications();
  }

  void _seedNotifications() {
    final now = DateTime.now();
    notifications.addAll([
      AppNotification(
          'n1',
          const L('Your application moved ahead', 'ನಿಮ್ಮ ಅರ್ಜಿ ಮುಂದುವರಿದಿದೆ'),
          const L('Income Certificate is with the Village Accountant.',
              'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರ ಗ್ರಾಮ ಲೆಕ್ಕಿಗರ ಬಳಿ ಇದೆ.'),
          now.subtract(const Duration(hours: 3)),
          'application'),
      AppNotification(
          'n2',
          const L('BESCOM bill due in 3 days', 'ಬೆಸ್ಕಾಂ ಬಿಲ್ 3 ದಿನಗಳಲ್ಲಿ ಪಾವತಿಸಬೇಕು'),
          const L('₹1,284 is due. Pay in two taps.', '₹1,284 ಬಾಕಿ ಇದೆ. ಎರಡು ಟ್ಯಾಪ್‌ಗಳಲ್ಲಿ ಪಾವತಿಸಿ.'),
          now.subtract(const Duration(hours: 9)),
          'bill'),
      AppNotification(
          'n3',
          const L('Rain likely this evening', 'ಇಂದು ಸಂಜೆ ಮಳೆ ಸಾಧ್ಯತೆ'),
          const L('Carry an umbrella if you are heading out in Bengaluru Urban.',
              'ಬೆಂಗಳೂರು ನಗರದಲ್ಲಿ ಹೊರಗೆ ಹೋಗುವಾಗ ಛತ್ರಿ ತೆಗೆದುಕೊಳ್ಳಿ.'),
          now.subtract(const Duration(days: 1, hours: 2)),
          'weather',
          route: 'weather',
          read: true),
      AppNotification(
          'n4',
          const L('Residence Certificate is ready', 'ವಾಸಸ್ಥಳ ಪ್ರಮಾಣಪತ್ರ ಸಿದ್ಧವಾಗಿದೆ'),
          const L('Download it from your applications.', 'ನಿಮ್ಮ ಅರ್ಜಿಗಳಿಂದ ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ.'),
          now.subtract(const Duration(days: 3)),
          'application',
          route: 'track',
          read: true),
      AppNotification(
          'n5',
          const L('New scheme: Yuva Nidhi', 'ಹೊಸ ಯೋಜನೆ: ಯುವ ನಿಧಿ'),
          const L('Monthly support for unemployed graduates.', 'ನಿರುದ್ಯೋಗಿ ಪದವೀಧರರಿಗೆ ಮಾಸಿಕ ನೆರವು.'),
          now.subtract(const Duration(days: 5)),
          'scheme',
          route: 'schemes',
          read: true),
    ]);
  }

  void set(VoidCallback f) {
    f();
    notifyListeners();
  }

  String tx(String en, String kn) => lang == 'kn' ? kn : en;
  String l(L v) => lang == 'kn' ? v.kn : v.en;

  void login() {
    loggedIn = true;
    notifyListeners();
    // Simulated server push, shortly after the user lands on Home.
    Future.delayed(const Duration(seconds: 6), () {
      if (!notifications.any((n) => n.id == 'welcome-scheme')) {
        push(AppNotification(
            'welcome-scheme',
            const L('A scheme may match you', 'ನಿಮಗೆ ಒಂದು ಯೋಜನೆ ಹೊಂದಬಹುದು'),
            const L('Gruha Lakshmi: check your eligibility in 30 seconds.',
                'ಗೃಹ ಲಕ್ಷ್ಮಿ: 30 ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಅರ್ಹತೆ ಪರಿಶೀಲಿಸಿ.'),
            DateTime.now(),
            'scheme',
            route: 'eligibility'));
      }
    });
  }

  void logout() => set(() => loggedIn = false);

  // ---- DigiLocker (features 1, 2, 13, 15)
  void linkDigilocker() {
    digilockerLinked = true;
    lockerDocs.addAll(docTypes.map((d) => d.id));
    notifyListeners();
  }

  void unlinkDigilocker() {
    digilockerLinked = false;
    lockerDocs.clear();
    notifyListeners();
  }

  // ---- Applications (feature 8)
  final _rand = Random();

  Application submitApplication(Service s) {
    final now = DateTime.now();
    final code = 100000 + _rand.nextInt(899999);
    final a = Application(
      id: 'KAR-${s.dept.en.substring(0, 3).toUpperCase()}-${now.year}-$code',
      service: s.name,
      dept: s.dept,
      source: s.source == 'Sakala' ? AppSource.sakala : AppSource.servicePlus,
      submitted: now,
      sakalaDays: s.sakalaDays,
      stages: revenueStages(now),
    );
    applications = [a, ...applications];
    notifyListeners();
    // Simulated department processing, so a demo shows live status pushes.
    _scheduleAdvance(a, const Duration(seconds: 14));
    return a;
  }

  void _scheduleAdvance(Application a, Duration d) {
    Future.delayed(d, () {
      if (!a.done && a.current < 2) {
        advance(a);
        _scheduleAdvance(a, const Duration(seconds: 22));
      }
    });
  }

  void advance(Application a) {
    if (a.done) return;
    a.current++;
    final stage = a.stages[a.current];
    push(AppNotification(
      'app-${a.id}-${a.current}',
      L('${a.service.en}: update', '${a.service.kn}: ಹೊಸ ಮಾಹಿತಿ'),
      L('Now at: ${stage.title.en}', 'ಈಗಿನ ಹಂತ: ${stage.title.kn}'),
      DateTime.now(),
      'application',
      route: 'application:${a.id}',
    ));
  }

  Application? findApplication(String id) {
    final q = id.trim().toUpperCase();
    for (final a in applications) {
      if (a.id == q) return a;
    }
    return lookupOnly[q];
  }

  // ---- Bills (feature 9)
  String payBill(Bill b) {
    final r = 'RCP${100000000 + _rand.nextInt(899999999)}';
    b
      ..paid = true
      ..paidOn = DateTime.now()
      ..receipt = r;
    notifyListeners();
    return r;
  }

  Bill addBill(BillProvider p, String consumerNo) {
    final b = Bill(
      id: 'b${DateTime.now().microsecondsSinceEpoch}',
      provider: p.name,
      category: p.category,
      consumerNo: consumerNo,
      label: p.name,
      amount: 180 + (consumerNo.hashCode.abs() % 2400),
      due: DateTime.now().add(Duration(days: 4 + consumerNo.length)),
    );
    bills = [b, ...bills];
    notifyListeners();
    return b;
  }

  // ---- Grievance & feedback (features 7, 14)
  Grievance addGrievance(String dept, String subject, String details) {
    final g = Grievance('IPGRS-${DateTime.now().year}-${10000 + _rand.nextInt(89999)}',
        dept, subject, details, DateTime.now());
    grievances.insert(0, g);
    notifyListeners();
    Future.delayed(const Duration(seconds: 12), () {
      g.stage = 1;
      push(AppNotification(
        'grv-${g.id}',
        const L('Grievance assigned', 'ಕುಂದುಕೊರತೆ ನಿಯೋಜಿಸಲಾಗಿದೆ'),
        L('${g.id} is with the department officer.', '${g.id} ಇಲಾಖೆ ಅಧಿಕಾರಿಯ ಬಳಿ ಇದೆ.'),
        DateTime.now(),
        'application',
        route: 'grievance',
      ));
    });
    return g;
  }

  void addFeedback(FeedbackEntry f) => set(() => feedback.insert(0, f));

  // ---- Scans (features 17, 18)
  void addScan(ScannedDoc d) => set(() => scans.insert(0, d));

  // ---- Notifications (feature 21)
  int get unread => notifications.where((n) => !n.read).length;

  void push(AppNotification n) {
    notifications.insert(0, n);
    final allowed = pushPrefs[n.kind] ?? true;
    if (allowed) {
      banner = n;
      _bannerTimer?.cancel();
      _bannerTimer = Timer(const Duration(seconds: 5), dismissBanner);
    }
    notifyListeners();
  }

  void dismissBanner() => set(() => banner = null);

  void markAllRead() => set(() {
        for (final n in notifications) {
          n.read = true;
        }
      });

  // ---- Recommendations (feature 11)
  List<Service> get recommendedSchemes =>
      schemes.where((s) => s.rule?.call(profile) ?? true).toList();

  List<Service> searchAll(String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return const [];
    bool hit(Service v) =>
        v.name.en.toLowerCase().contains(s) ||
        v.name.kn.contains(s) ||
        v.desc.en.toLowerCase().contains(s) ||
        v.dept.en.toLowerCase().contains(s) ||
        v.code.toLowerCase() == s;
    final curated = [...services, ...schemes].where(hit);
    return [...curated, ...catalogue.where(hit)];
  }

  void addTxn(String title, int amount) => set(() => transactions.insert(
      0,
      Txn(L(title, title), amount, 'RCP${100000000 + _rand.nextInt(899999999)}',
          DateTime.now())));

  /// Out of 10, as a simple "how much have you set up" measure.
  int get profileScore =>
      3 +
      (digilockerLinked ? 3 : 0) +
      (profile.completed ? 2 : 0) +
      (biometric ? 1 : 0) +
      (family.isNotEmpty ? 1 : 0);

  /// Back to first-launch state.
  void resetDemo() {
    onboarded = false;
    loggedIn = false;
    digilockerLinked = false;
    lockerDocs.clear();
    scans.clear();
    applications = seedApplications();
    bills = seedBills();
    feedback.clear();
    bookmarks.clear();
    doneSteps.clear();
    aiMode = false;
    biometric = false;
    notifications.clear();
    banner = null;
    profile.completed = false;
    _seedNotifications();
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);
}

extension AppContext on BuildContext {
  /// Subscribes this widget to store changes and returns the store.
  AppState get watchApp {
    dependOnInheritedWidgetOfExactType<AppScope>();
    return app;
  }

  /// Bilingual text; also subscribes the caller, so it rebuilds on any change.
  String tr(String en, String kn) => watchApp.tx(en, kn);
  String loc(L v) => watchApp.l(v);
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get tt => Theme.of(this).textTheme;
}

String tx(String en, String kn) => app.tx(en, kn);

String money(num v) {
  final s = v.toStringAsFixed(0);
  if (s.length <= 3) return '₹$s';
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '₹${parts.join(',')},$last3';
}

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
String dateStr(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String ago(DateTime d) {
  final m = DateTime.now().difference(d).inMinutes;
  if (m < 1) return tx('Just now', 'ಈಗಷ್ಟೇ');
  if (m < 60) return tx('$m min ago', '$m ನಿಮಿಷದ ಹಿಂದೆ');
  final h = m ~/ 60;
  if (h < 24) return tx('$h h ago', '$h ಗಂಟೆ ಹಿಂದೆ');
  return tx('${h ~/ 24} d ago', '${h ~/ 24} ದಿನದ ಹಿಂದೆ');
}
