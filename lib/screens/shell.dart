import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../widgets/common.dart';
import 'ai_home.dart';
import 'home.dart';
import 'locker.dart';
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
          DocumentsScreen(),
          TrackScreen(),
        ]),
        bottomNavigationBar: const _Nav(),
      ),
    );
  }
}

/// Bottom bar with a raised centre button for the assistant.
class _Nav extends StatelessWidget {
  const _Nav();

  @override
  Widget build(BuildContext context) {
    final tab = shellTab.value;
    Widget item(int i, IconData off, IconData on, String label) {
      final sel = tab == i;
      final c = sel ? context.cs.primary : context.cs.onSurfaceVariant;
      return Expanded(
        child: Semantics(
          button: true,
          selected: sel,
          label: label,
          excludeSemantics: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => shellTab.value = i,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(sel ? on : off, color: c, size: 25),
                const SizedBox(height: 3),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11.5,
                        color: c,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
              ]),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [BoxShadow(color: Color(0x1F1A1C37), blurRadius: 22, offset: Offset(0, -6))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            item(0, Icons.home_outlined, Icons.home_rounded, context.tr('Home', 'ಮುಖಪುಟ')),
            item(1, Icons.grid_view_outlined, Icons.grid_view_rounded, context.tr('Services', 'ಸೇವೆಗಳು')),
            Expanded(
              child: Semantics(
                button: true,
                label: context.tr('Ask Seva assistant', 'ಸೇವಾ ಸಹಾಯಕರನ್ನು ಕೇಳಿ'),
                excludeSemantics: true,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => push(context, const AskScreen()),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(colors: [Seva.blue, Seva.blueDark]),
                        boxShadow: [
                          BoxShadow(
                              color: Seva.blue.withValues(alpha: .4),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome, color: Seva.gold, size: 24),
                    ),
                    const SizedBox(height: 2),
                    Text(context.tr('Ask Seva', 'ಸೇವಾ ಕೇಳಿ'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11.5,
                            color: context.cs.primary,
                            fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
            ),
            item(2, Icons.folder_outlined, Icons.folder_rounded, context.tr('Documents', 'ದಾಖಲೆಗಳು')),
            item(3, Icons.timeline_outlined, Icons.timeline_rounded, context.tr('Track', 'ಟ್ರ್ಯಾಕ್')),
          ]),
        ),
      ),
    );
  }
}
