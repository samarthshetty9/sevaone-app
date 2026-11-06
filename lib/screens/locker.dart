import 'dart:math';

import 'package:flutter/material.dart';

import '../app/state.dart';
import '../app/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../router.dart';
import '../widgets/common.dart';
import 'scanner.dart';

/// Features 1, 2, 13, 15: DigiLocker linking, wider document types, downloads
/// and document verification.
class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watchApp;
    final docs = docTypes.where((d) => s.lockerDocs.contains(d.id)).toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.tr('My documents', 'ನನ್ನ ದಾಖಲೆಗಳು')),
        actions: [
          IconButton(
            tooltip: context.tr('Scan a document', 'ದಾಖಲೆ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ'),
            onPressed: () => openRoute('scanner'),
            icon: const Icon(Icons.document_scanner_outlined),
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (!s.digilockerLinked)
          SevaCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const IconBadge(Icons.lock_outline, size: 52),
              const SizedBox(height: 12),
              Text(context.tr('Link DigiLocker', 'ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್ ಮಾಡಿ'),
                  style: context.tt.titleLarge),
              const SizedBox(height: 4),
              Text(
                context.tr('Get your Aadhaar, PAN, licence and more here, and never upload them again.',
                    'ನಿಮ್ಮ ಆಧಾರ್, ಪ್ಯಾನ್, ಪರವಾನಗಿ ಮತ್ತು ಇನ್ನಷ್ಟನ್ನು ಇಲ್ಲಿ ಪಡೆಯಿರಿ, ಮತ್ತೆ ಅಪ್‌ಲೋಡ್ ಮಾಡಬೇಕಿಲ್ಲ.'),
                style: TextStyle(color: context.cs.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => openRoute('digilocker'),
                  child: Text(context.tr('Link now', 'ಈಗ ಲಿಂಕ್ ಮಾಡಿ')),
                ),
              ),
            ]),
          )
        else ...[
          Row(children: [
            Icon(Icons.check_circle, color: context.cs.secondary, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                context.tr('DigiLocker linked · ${docs.length} documents',
                    'ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್ ಆಗಿದೆ · ${docs.length} ದಾಖಲೆಗಳು'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          for (final d in docs)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SevaCard(
                onTap: () => push(context, DocumentView(d)),
                child: Row(children: [
                  IconBadge(d.icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(context.loc(d.name), style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(context.loc(d.issuer),
                          style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant)),
                    ]),
                  ),
                  Icon(Icons.chevron_right, color: context.cs.onSurfaceVariant),
                ]),
              ),
            ),
        ],
        if (!s.digilockerLinked) ...[
          SectionHeaderPlain(context.tr('Documents you might need', 'ನಿಮಗೆ ಬೇಕಾಗಬಹುದಾದ ದಾಖಲೆಗಳು')),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final d in docTypes)
              ActionChip(
                avatar: Icon(d.icon, size: 17),
                label: Text(context.loc(d.name)),
                onPressed: () => openRoute('digilocker'),
              ),
          ]),
        ],
        SectionHeaderPlain(context.tr('Explore documents', 'ದಾಖಲೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ')),
        for (final (icon, name, count) in [
          (Icons.fingerprint, context.tr('Identity', 'ಗುರುತು'), 6),
          (Icons.school_outlined, context.tr('Education', 'ಶಿಕ್ಷಣ'), 18),
          (Icons.drive_eta_outlined, context.tr('Transport', 'ಸಾರಿಗೆ'), 4),
          (Icons.landscape_outlined, context.tr('Land and property', 'ಭೂಮಿ ಮತ್ತು ಆಸ್ತಿ'), 9),
          (Icons.account_balance_outlined, context.tr('Karnataka state documents', 'ಕರ್ನಾಟಕ ರಾಜ್ಯ ದಾಖಲೆಗಳು'), 31),
        ])
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconBadge(icon, size: 38),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(context.tr('$count documents', '$count ದಾಖಲೆಗಳು')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openRoute(s.digilockerLinked ? 'verify' : 'digilocker'),
          ),
        SectionHeaderPlain(context.tr('Scanned documents', 'ಸ್ಕ್ಯಾನ್ ಮಾಡಿದ ದಾಖಲೆಗಳು')),
        if (s.scans.isEmpty)
          SevaCard(
            onTap: () => openRoute('scanner'),
            child: Row(children: [
              const IconBadge(Icons.document_scanner_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.tr('Scan a paper document and pull out its text',
                      'ಕಾಗದದ ದಾಖಲೆಯನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ ಪಠ್ಯ ಪಡೆಯಿರಿ'),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
        for (final d in s.scans)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              onTap: () => push(context, OcrScreen(d)),
              child: Row(children: [
                const IconBadge(Icons.description_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(context.loc(d.title), style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      d.ocr != null
                          ? context.tr('Text extracted', 'ಪಠ್ಯ ಪಡೆಯಲಾಗಿದೆ')
                          : context.tr('Tap to extract text', 'ಪಠ್ಯ ಪಡೆಯಲು ಟ್ಯಾಪ್ ಮಾಡಿ'),
                      style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => openRoute('verify'),
          icon: const Icon(Icons.verified_outlined),
          label: Text(context.tr('Verify a document', 'ದಾಖಲೆಯನ್ನು ಪರಿಶೀಲಿಸಿ')),
        ),
      ]),
    );
  }
}

class SectionHeaderPlain extends StatelessWidget {
  final String text;
  const SectionHeaderPlain(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Semantics(header: true, child: Text(text, style: context.tt.titleLarge)),
      );
}

class DigilockerLinkScreen extends StatefulWidget {
  const DigilockerLinkScreen({super.key});

  @override
  State<DigilockerLinkScreen> createState() => _DigilockerLinkScreenState();
}

class _DigilockerLinkScreenState extends State<DigilockerLinkScreen> {
  int stage = 0; // 0 consent, 1 fetching, 2 done

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Link DigiLocker', 'ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್')),
        actions: const [DemoChip(), SizedBox(width: 16)],
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: switch (stage) {
        0 => [
            Text(context.tr('SevaOne is asking to read', 'ಸೇವಾಒನ್ ಓದಲು ಕೇಳುತ್ತಿದೆ'),
                style: context.tt.headlineSmall),
            const SizedBox(height: 14),
            for (final d in docTypes)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(d.icon, color: context.cs.primary),
                title: Text(context.loc(d.name)),
                subtitle: Text(context.loc(d.issuer)),
              ),
            const SizedBox(height: 6),
            Text(
              context.tr('You can unlink at any time from Profile.',
                  'ಪ್ರೊಫೈಲ್‌ನಿಂದ ಯಾವಾಗ ಬೇಕಾದರೂ ಅನ್‌ಲಿಂಕ್ ಮಾಡಬಹುದು.'),
              style: TextStyle(color: context.cs.onSurfaceVariant),
            ),
          ],
        1 => [
            SevaCard(
              child: SimSteps(
                steps: [
                  context.tr('Verifying your consent', 'ನಿಮ್ಮ ಸಮ್ಮತಿ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ'),
                  for (final d in docTypes.take(4))
                    context.tr('Fetching ${d.name.en}', '${d.name.kn} ಪಡೆಯಲಾಗುತ್ತಿದೆ'),
                  context.tr('Fetching the rest', 'ಉಳಿದವುಗಳನ್ನು ಪಡೆಯಲಾಗುತ್ತಿದೆ'),
                ],
                stepTime: const Duration(milliseconds: 500),
                onDone: () {
                  app.linkDigilocker();
                  setState(() => stage = 2);
                },
              ),
            ),
          ],
        _ => [
            const SizedBox(height: 40),
            const Center(child: SuccessTick()),
            const SizedBox(height: 18),
            Text(context.tr('DigiLocker linked', 'ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್ ಆಗಿದೆ'),
                textAlign: TextAlign.center, style: context.tt.headlineSmall),
            const SizedBox(height: 6),
            Text(
              context.tr('${docTypes.length} documents are ready. They will fill in on every application.',
                  '${docTypes.length} ದಾಖಲೆಗಳು ಸಿದ್ಧವಾಗಿವೆ. ಪ್ರತಿ ಅರ್ಜಿಯಲ್ಲಿ ಇವು ಭರ್ತಿಯಾಗುತ್ತವೆ.'),
              textAlign: TextAlign.center,
              style: TextStyle(color: context.cs.onSurfaceVariant),
            ),
          ],
      }),
      bottomNavigationBar: stage == 1
          ? null
          : BottomAction(
              child: FilledButton(
                onPressed: () =>
                    stage == 0 ? setState(() => stage = 1) : Navigator.of(context).pop(),
                child: Text(stage == 0
                    ? context.tr('Allow', 'ಅನುಮತಿಸಿ')
                    : context.tr('Done', 'ಮುಗಿಯಿತು')),
              ),
            ),
    );
  }
}

class DocumentView extends StatelessWidget {
  final DocType d;
  const DocumentView(this.d, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc(d.name))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Semantics(
          label: context.tr('${d.name.en} preview', '${d.name.kn} ಮುನ್ನೋಟ'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Seva.navy, Seva.blueDark]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(d.icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(context.loc(d.issuer),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const DemoChip(onDark: true),
                ]),
                const SizedBox(height: 26),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(context.loc(citizenName),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(d.number, style: const TextStyle(letterSpacing: 1)),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    color: Colors.white,
                    child: QrPlaceholder(seed: d.number, size: 66),
                  ),
                ]),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (!d.downloadable)
          SevaCard(
            child: Row(children: [
              Icon(Icons.visibility_outlined, color: context.cs.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(context.tr(
                    'Aadhaar can be viewed here but not downloaded.',
                    'ಆಧಾರ್ ಅನ್ನು ಇಲ್ಲಿ ನೋಡಬಹುದು ಆದರೆ ಡೌನ್‌ಲೋಡ್ ಮಾಡಲಾಗುವುದಿಲ್ಲ.')),
              ),
            ]),
          )
        else
          FilledButton.icon(
            onPressed: () => toast(tx('Saved to device (demo)', 'ಸಾಧನಕ್ಕೆ ಉಳಿಸಲಾಗಿದೆ (ಡೆಮೊ)')),
            icon: const Icon(Icons.download_outlined),
            label: Text(context.tr('Download', 'ಡೌನ್‌ಲೋಡ್')),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => push(context, VerifyScreen(d)),
          icon: const Icon(Icons.verified_outlined),
          label: Text(context.tr('Verify this document', 'ಈ ದಾಖಲೆಯನ್ನು ಪರಿಶೀಲಿಸಿ')),
        ),
      ]),
    );
  }
}

class VerifyHomeScreen extends StatelessWidget {
  const VerifyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Verify a document', 'ದಾಖಲೆ ಪರಿಶೀಲನೆ'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(
          context.tr('Check that a certificate is genuine against the issuer record.',
              'ಪ್ರಮಾಣಪತ್ರ ಅಸಲಿಯೇ ಎಂದು ನೀಡಿದವರ ದಾಖಲೆಯೊಂದಿಗೆ ಪರಿಶೀಲಿಸಿ.'),
          style: TextStyle(color: context.cs.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        for (final d in docTypes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SevaCard(
              onTap: () => push(context, VerifyScreen(d)),
              child: Row(children: [
                IconBadge(d.icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(context.loc(d.name),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Text(d.number.length > 12 ? '${d.number.substring(0, 10)}…' : d.number,
                    style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant)),
              ]),
            ),
          ),
      ]),
    );
  }
}

class VerifyScreen extends StatefulWidget {
  final DocType d;
  const VerifyScreen(this.d, {super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool done = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('Verification', 'ಪರಿಶೀಲನೆ'))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        if (!done)
          SevaCard(
            child: SimSteps(
              steps: [
                context.tr('Reading QR and document ID', 'ಕ್ಯೂಆರ್ ಮತ್ತು ದಾಖಲೆ ಐಡಿ ಓದಲಾಗುತ್ತಿದೆ'),
                context.tr('Checking issuer signature', 'ನೀಡಿದವರ ಸಹಿ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ'),
                context.tr('Matching issuer record', 'ನೀಡಿದವರ ದಾಖಲೆ ಹೊಂದಿಸಲಾಗುತ್ತಿದೆ'),
              ],
              onDone: () => setState(() => done = true),
            ),
          )
        else ...[
          const SizedBox(height: 24),
          const Center(child: SuccessTick()),
          const SizedBox(height: 16),
          Text(context.tr('Genuine document', 'ಅಸಲಿ ದಾಖಲೆ'),
              textAlign: TextAlign.center, style: context.tt.headlineSmall),
          const SizedBox(height: 16),
          SevaCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(context.loc(d.name), style: context.tt.titleMedium),
              const SizedBox(height: 6),
              Text(context.tr('Issued by ${d.issuer.en}', '${d.issuer.kn} ನೀಡಿದೆ')),
              Text(context.tr('Holder: ${citizenName.en}', 'ಹೊಂದಿರುವವರು: ${citizenName.kn}')),
              Text(context.tr('Checked: ${dateStr(DateTime.now())}', 'ಪರಿಶೀಲಿಸಿದ್ದು: ${dateStr(DateTime.now())}')),
              Text('ID: VRF-${d.number.hashCode.abs() % 900000 + 100000}'),
            ]),
          ),
        ],
      ]),
    );
  }
}

/// Decorative QR-like pattern. It does not encode anything.
class QrPlaceholder extends StatelessWidget {
  final String seed;
  final double size;
  const QrPlaceholder({super.key, required this.seed, required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _QrPainter(seed));
}

class _QrPainter extends CustomPainter {
  final String seed;
  _QrPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    const n = 21;
    final cell = size.width / n;
    final p = Paint()..color = Colors.black;
    final r = Random(seed.hashCode);
    bool finder(int x, int y) =>
        (x < 7 && y < 7) || (x >= n - 7 && y < 7) || (x < 7 && y >= n - 7);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        if (!finder(x, y) && r.nextBool()) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), p);
        }
      }
    }
    void square(int ox, int oy) {
      canvas.drawRect(Rect.fromLTWH(ox * cell, oy * cell, 7 * cell, 7 * cell), p);
      canvas.drawRect(Rect.fromLTWH((ox + 1) * cell, (oy + 1) * cell, 5 * cell, 5 * cell),
          Paint()..color = Colors.white);
      canvas.drawRect(Rect.fromLTWH((ox + 2) * cell, (oy + 2) * cell, 3 * cell, 3 * cell), p);
    }

    square(0, 0);
    square(n - 7, 0);
    square(0, n - 7);
  }

  @override
  bool shouldRepaint(_QrPainter o) => o.seed != seed;
}
