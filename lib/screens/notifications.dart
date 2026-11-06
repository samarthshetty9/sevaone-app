import 'package:flutter/material.dart';

import '../app/state.dart';
import '../data/models.dart';
import '../router.dart';
import '../widgets/common.dart';

/// Feature 21: notification centre and per-topic preferences.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _icon(String k) => switch (k) {
        'application' => Icons.timeline,
        'bill' => Icons.receipt_long_outlined,
        'scheme' => Icons.auto_awesome,
        'weather' => Icons.cloud_outlined,
        _ => Icons.notifications_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Notifications', 'ಅಧಿಸೂಚನೆಗಳು')),
        actions: [
          if (s.unread > 0)
            IconButton(
              tooltip: context.tr('Mark all read', 'ಎಲ್ಲವನ್ನೂ ಓದಿದೆ'),
              onPressed: app.markAllRead,
              icon: const Icon(Icons.done_all),
            ),
          IconButton(
            tooltip: context.tr('Notification settings', 'ಅಧಿಸೂಚನೆ ಸೆಟ್ಟಿಂಗ್‌ಗಳು'),
            icon: const Icon(Icons.tune),
            onPressed: () => push(context, const _Prefs()),
          ),
        ],
      ),
      body: s.notifications.isEmpty
          ? EmptyState(
              icon: Icons.notifications_none,
              title: context.tr('Nothing new', 'ಹೊಸದೇನೂ ಇಲ್ಲ'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: s.notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final n = s.notifications[i];
                return SevaCard(
                  color: n.read ? null : context.cs.primary.withValues(alpha: 0.07),
                  onTap: () {
                    app.set(() => n.read = true);
                    if (n.route != null) openRoute(n.route!);
                  },
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    IconBadge(_icon(n.kind), size: 38),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(context.loc(n.title),
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(context.loc(n.body), style: const TextStyle(fontSize: 13.5)),
                        const SizedBox(height: 2),
                        Text(ago(n.at),
                            style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
                      ]),
                    ),
                  ]),
                );
              },
            ),
    );
  }
}

class _Prefs extends StatelessWidget {
  const _Prefs();

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final labels = {
      'application': context.tr('Application updates', 'ಅರ್ಜಿ ಮಾಹಿತಿ'),
      'bill': context.tr('Bill reminders', 'ಬಿಲ್ ಜ್ಞಾಪನೆಗಳು'),
      'scheme': context.tr('New schemes', 'ಹೊಸ ಯೋಜನೆಗಳು'),
      'weather': context.tr('Weather and air alerts', 'ಹವಾಮಾನ ಮತ್ತು ಗಾಳಿ ಎಚ್ಚರಿಕೆಗಳು'),
    };
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Notification settings', 'ಅಧಿಸೂಚನೆ ಸೆಟ್ಟಿಂಗ್‌ಗಳು'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        for (final e in labels.entries)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(e.value),
            value: s.pushPrefs[e.key]!,
            onChanged: (v) => app.set(() => app.pushPrefs[e.key] = v),
          ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => app.push(AppNotification(
            'test-${DateTime.now().millisecondsSinceEpoch}',
            const L('Heavy rain expected', 'ಭಾರೀ ಮಳೆ ನಿರೀಕ್ಷೆ'),
            const L('Rain likely in Bengaluru Urban this evening.',
                'ಇಂದು ಸಂಜೆ ಬೆಂಗಳೂರು ನಗರದಲ್ಲಿ ಮಳೆ ಸಾಧ್ಯತೆ.'),
            DateTime.now(),
            'weather',
            route: 'weather',
          )),
          icon: const Icon(Icons.notifications_active_outlined),
          label: Text(context.tr('Send a test notification', 'ಪರೀಕ್ಷಾ ಅಧಿಸೂಚನೆ ಕಳುಹಿಸಿ')),
        ),
      ]),
    );
  }
}
