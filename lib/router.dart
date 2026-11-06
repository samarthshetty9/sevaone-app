import 'package:flutter/material.dart';

import 'app/state.dart';
import 'screens/assistant.dart';
import 'screens/bills.dart';
import 'screens/centres.dart';
import 'screens/eligibility.dart';
import 'screens/extras.dart';
import 'screens/locker.dart';
import 'screens/more.dart';
import 'screens/notifications.dart';
import 'screens/profile.dart';
import 'screens/scanner.dart';
import 'screens/services.dart';
import 'screens/shell.dart';
import 'screens/sms.dart';
import 'screens/support.dart';
import 'screens/track.dart';
import 'screens/weather.dart';

/// String routes used by notifications, the assistant, SMS and the feature map.
Widget? pageFor(String route) {
  if (route.startsWith('application:')) {
    final a = app.findApplication(route.split(':')[1]);
    return a == null ? null : ApplicationDetail(a);
  }
  return switch (route) {
    'bills' => const BillsScreen(),
    'centres' => const CentresScreen(),
    'eligibility' => const EligibilityScreen(),
    'grievance' => const GrievanceScreen(),
    'feedback' => const FeedbackScreen(),
    'help' => const HelpScreen(),
    'chat' => const LiveChatScreen(),
    'voice' => const VoiceBotScreen(),
    'sms' => const SmsScreen(),
    'scanner' => const ScannerScreen(),
    'weather' => const WeatherScreen(),
    'notifications' => const NotificationsScreen(),
    'accessibility' => const AccessibilityScreen(),
    'digilocker' => const DigilockerLinkScreen(),
    'verify' => const VerifyHomeScreen(),
    'features' => const FeatureMapScreen(),
    'search' => const SearchScreen(),
    'life' => const LifeEventsScreen(),
    'calculators' => const CalculatorsScreen(),
    'digipin' => const DigipinScreen(),
    'emergency' => const EmergencyScreen(),
    'helplines' => const HelplinesScreen(),
    'jobs' => const JobsScreen(),
    'transactions' => const TransactionsScreen(),
    'family' => const FamilyScreen(),
    'myqr' => const MyQrScreen(),
    'isl' => const IslScreen(),
    'signal' => const SignalScreen(),
    'directory' => const DirectoryScreen(),
    'whatsapp' => const LiveChatScreen(whatsapp: true),
    'totp' => const TotpScreen(),
    _ => null,
  };
}

/// Tabs are switched in place; everything else is pushed.
void openRoute(String route) {
  final nav = navigatorKey.currentState;
  if (nav == null) return;
  const tabs = {'home': 0, 'services': 1, 'schemes': 1, 'track': 2, 'documents': 3, 'profile': 4};
  if (tabs.containsKey(route)) {
    nav.popUntil((r) => r.isFirst);
    shellTab.value = tabs[route]!;
    if (route == 'schemes') servicesTab.value = 1;
    if (route == 'services') servicesTab.value = 0;
    return;
  }
  final page = pageFor(route);
  if (page != null) nav.push(MaterialPageRoute(builder: (_) => page));
}
