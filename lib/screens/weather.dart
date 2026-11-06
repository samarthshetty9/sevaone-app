import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

IconData weatherIcon(String c) => switch (c) {
      'sunny' => Icons.wb_sunny_outlined,
      'rain' => Icons.umbrella_outlined,
      'storm' => Icons.thunderstorm_outlined,
      _ => Icons.cloud_outlined,
    };

L conditionName(String c) => switch (c) {
      'sunny' => const L('Sunny', 'ಬಿಸಿಲು'),
      'rain' => const L('Rain', 'ಮಳೆ'),
      'storm' => const L('Thunderstorm', 'ಗುಡುಗು ಸಹಿತ ಮಳೆ'),
      _ => const L('Cloudy', 'ಮೋಡ ಕವಿದ'),
    };

/// CPCB AQI bands.
(L, Color, L) aqiBand(int a) {
  if (a <= 50) {
    return (const L('Good', 'ಉತ್ತಮ'), Seva.greenDark,
        const L('Air is clean. Enjoy the outdoors.', 'ಗಾಳಿ ಸ್ವಚ್ಛವಾಗಿದೆ. ಹೊರಾಂಗಣವನ್ನು ಆನಂದಿಸಿ.'));
  }
  if (a <= 100) {
    return (const L('Satisfactory', 'ತೃಪ್ತಿಕರ'), const Color(0xFF5E8C00),
        const L('Sensitive people may feel minor discomfort.', 'ಸೂಕ್ಷ್ಮ ವ್ಯಕ್ತಿಗಳಿಗೆ ಸ್ವಲ್ಪ ಅಸ್ವಸ್ಥತೆ ಆಗಬಹುದು.'));
  }
  if (a <= 200) {
    return (const L('Moderate', 'ಮಧ್ಯಮ'), const Color(0xFFB57700),
        const L('People with asthma or heart conditions should limit long outdoor effort.',
            'ಅಸ್ತಮಾ ಅಥವಾ ಹೃದಯ ಸಮಸ್ಯೆ ಇರುವವರು ದೀರ್ಘ ಹೊರಾಂಗಣ ಶ್ರಮವನ್ನು ಕಡಿಮೆ ಮಾಡಬೇಕು.'));
  }
  return (const L('Poor', 'ಕಳಪೆ'), Seva.red,
      const L('Avoid long outdoor activity. Consider wearing a mask.',
          'ದೀರ್ಘ ಹೊರಾಂಗಣ ಚಟುವಟಿಕೆ ತಪ್ಪಿಸಿ. ಮಾಸ್ಕ್ ಧರಿಸಿ.'));
}

/// Feature 20: weather and AQI by district.
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final w = weatherByDistrict[s.weatherDistrict]!;
    final band = aqiBand(w.aqi);
    final days = [
      context.tr('Today', 'ಇಂದು'),
      for (var i = 1; i < 7; i++) _weekday(DateTime.now().add(Duration(days: i))),
    ];

    Widget stat(IconData i, String k, String v) => Expanded(
          child: Column(children: [
            Icon(i, size: 20, color: context.cs.primary),
            const SizedBox(height: 4),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(k,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
          ]),
        );

    return Scaffold(
      appBar: SevaBar(title: Text(context.tr('Weather and air quality', 'ಹವಾಮಾನ ಮತ್ತು ಗಾಳಿಯ ಗುಣಮಟ್ಟ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SizedBox(
          height: 44,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (final d in districts)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(context.loc(d)),
                  selected: s.weatherDistrict == d.en,
                  onSelected: (_) => app.set(() => app.weatherDistrict = d.en),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              gradient: Seva.headerGradient, borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${w.temp}°C',
                    style: context.tt.headlineMedium
                        ?.copyWith(color: Colors.white, fontSize: 46)),
                Text(context.loc(conditionName(w.condition)),
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text(context.tr('Feels like ${w.feels}°', '${w.feels}° ಅನಿಸುತ್ತದೆ'),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
            Icon(weatherIcon(w.condition), color: Seva.gold, size: 64),
          ]),
        ),
        const SizedBox(height: 12),
        SevaCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('Today', 'ಇಂದು'), style: context.tt.titleMedium),
            const SizedBox(height: 8),
            Row(children: [
              for (var i = 0; i < w.hourly.length; i++)
                Expanded(
                  child: Column(children: [
                    Text('${(9 + i * 2) % 12 == 0 ? 12 : (9 + i * 2) % 12}${9 + i * 2 < 12 ? 'a' : 'p'}',
                        style: TextStyle(fontSize: 11, color: context.cs.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Icon(weatherIcon(w.condition), size: 18, color: context.cs.primary),
                    const SizedBox(height: 4),
                    Text('${w.hourly[i]}°',
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  ]),
                ),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        SevaCard(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            stat(Icons.water_drop_outlined, context.tr('Humidity', 'ತೇವಾಂಶ'), '${w.humidity}%'),
            stat(Icons.air, context.tr('Wind', 'ಗಾಳಿ'), '${w.wind} km/h'),
            stat(Icons.umbrella_outlined, context.tr('Rain', 'ಮಳೆ'), '${w.rainChance}%'),
            stat(Icons.wb_sunny_outlined, 'UV', '${w.uv}'),
          ]),
        ),
        const SizedBox(height: 12),
        SevaCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(context.tr('Air quality', 'ಗಾಳಿಯ ಗುಣಮಟ್ಟ'), style: context.tt.titleMedium),
              ),
              Pill(context.loc(band.$1), color: band.$2),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              ArcGauge(value: w.aqi / 300, big: '${w.aqi}', small: 'AQI', size: 138),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('PM2.5', style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
                  Text('${w.pm25} µg/m³', style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('PM10', style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant)),
                  Text('${w.pm10} µg/m³', style: const TextStyle(fontWeight: FontWeight.w700)),
                ]),
              ),
            ]),
            const SizedBox(height: 4),
            Text(context.loc(band.$3)),
          ]),
        ),
        const SizedBox(height: 12),
        SevaCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.tr('Next 7 days', 'ಮುಂದಿನ 7 ದಿನಗಳು'), style: context.tt.titleMedium),
            const SizedBox(height: 6),
            for (var i = 0; i < w.daily.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Expanded(flex: 2, child: Text(days[i])),
                  Icon(weatherIcon(w.daily[i].$3), size: 20, color: context.cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Text(context.loc(conditionName(w.daily[i].$3)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                  ),
                  Text('${w.daily[i].$1}° / ${w.daily[i].$2}°',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ]),
              ),
          ]),
        ),
        const SizedBox(height: 10),
        Text(
          context.tr('Updated a few minutes ago.', 'ಕೆಲವು ನಿಮಿಷಗಳ ಹಿಂದೆ ನವೀಕರಿಸಲಾಗಿದೆ.'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: context.cs.onSurfaceVariant),
        ),
      ]),
    );
  }

  String _weekday(DateTime d) {
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const kn = ['ಸೋಮ', 'ಮಂಗಳ', 'ಬುಧ', 'ಗುರು', 'ಶುಕ್ರ', 'ಶನಿ', 'ಭಾನು'];
    return tx(en[d.weekday - 1], kn[d.weekday - 1]);
  }
}
