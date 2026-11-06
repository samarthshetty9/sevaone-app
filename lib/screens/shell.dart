import 'package:flutter/material.dart';

import '../app/state.dart';
import 'home.dart';
import 'locker.dart';
import 'profile.dart';
import 'services.dart';
import 'track.dart';

final shellTab = ValueNotifier<int>(0);
final servicesTab = ValueNotifier<int>(0);

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: shellTab,
      builder: (context, tab, _) => Scaffold(
        body: IndexedStack(index: tab, children: const [
          HomeScreen(),
          ServicesScreen(),
          TrackScreen(),
          DocumentsScreen(),
          ProfileScreen(),
        ]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) => shellTab.value = i,
          destinations: [
            NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: context.tr('Home', 'ಮುಖಪುಟ')),
            NavigationDestination(
                icon: const Icon(Icons.grid_view_outlined),
                selectedIcon: const Icon(Icons.grid_view_rounded),
                label: context.tr('Services', 'ಸೇವೆಗಳು')),
            NavigationDestination(
                icon: const Icon(Icons.timeline_outlined),
                selectedIcon: const Icon(Icons.timeline_rounded),
                label: context.tr('Track', 'ಟ್ರ್ಯಾಕ್')),
            NavigationDestination(
                icon: const Icon(Icons.folder_outlined),
                selectedIcon: const Icon(Icons.folder_rounded),
                label: context.tr('Documents', 'ದಾಖಲೆಗಳು')),
            NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person_rounded),
                label: context.tr('Profile', 'ಪ್ರೊಫೈಲ್')),
          ],
        ),
      ),
    );
  }
}
