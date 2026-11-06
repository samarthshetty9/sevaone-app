import 'package:flutter/material.dart';

import 'app/state.dart';
import 'app/theme.dart';
import 'router.dart';
import 'screens/onboarding.dart';
import 'screens/shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await app.load();
  runApp(const SevaOneApp());
}

class SevaOneApp extends StatelessWidget {
  const SevaOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: app,
      child: ListenableBuilder(
        listenable: app,
        builder: (context, _) => MaterialApp(
          title: 'SevaOne',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: buildTheme(dark: false, highContrast: app.highContrast),
          darkTheme: buildTheme(dark: true, highContrast: app.highContrast),
          themeMode: app.darkMode ? ThemeMode.dark : ThemeMode.light,
          themeAnimationDuration:
              app.reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(
                textScaler: TextScaler.linear(app.textScale),
                disableAnimations: app.reduceMotion || mq.disableAnimations,
                boldText: app.highContrast || mq.boldText,
              ),
              child: Stack(fit: StackFit.expand, children: [child!, const PushBanner()]),
            );
          },
          home: const RootGate(),
        ),
      ),
    );
  }
}

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    if (!s.onboarded) return const LanguageScreen();
    if (!s.loggedIn) return const LoginScreen();
    return const Shell();
  }
}

/// Simulated push notification (feature 21): slides in over any screen.
class PushBanner extends StatelessWidget {
  const PushBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final n = context.watchApp.banner;
    final top = MediaQuery.of(context).padding.top + 8;
    return AnimatedPositioned(
      duration: app.reduceMotion ? Duration.zero : const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      top: n == null ? -180 : top,
      left: 10,
      right: 10,
      child: n == null
          ? const SizedBox.shrink()
          : Semantics(
              liveRegion: true,
              button: true,
              label: '${context.loc(n.title)}. ${context.loc(n.body)}',
              child: Dismissible(
                key: ValueKey(n.id),
                direction: DismissDirection.up,
                onDismissed: (_) => app.dismissBanner(),
                child: Material(
                  elevation: 10,
                  color: context.cs.surfaceContainerLow,
                  shadowColor: Colors.black45,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      app.dismissBanner();
                      n.read = true;
                      if (n.route != null) openRoute(n.route!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.asset('assets/images/sevasindhu-logo.png',
                              width: 38, height: 38, fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(context.loc(n.title),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(context.loc(n.body),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
