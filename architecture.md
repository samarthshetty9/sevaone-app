# Architecture

**Stack:** Flutter 3.47 / Dart 3.13, Material 3. The only plugin is `url_launcher`, for real phone calls; nothing touches the camera, microphone, network or real payments. Targets: iOS, Android, web.

**Entry:** `lib/main.dart` loads the catalogue, then `RootGate` picks language screen, login or `Shell` (Home, Services, Documents, Track, with a raised centre Ask Seva button). Profile opens from the avatar on Home.

**State:** one in-memory `AppState` (`lib/app/state.dart`), exposed as the global `app`. In `build`, `context.tr` / `context.loc` / `context.watchApp` subscribe the widget through the `AppScope` InheritedNotifier. In callbacks use `app` and the global `tx()`. Nothing persists: a restart resets the demo, as does Profile > Reset demo.

**Design system:** `lib/widgets/art.dart` and `common.dart`. `SevaBar` is the header on every page, `GlowPanel` the gradient hero that opens most screens, `SevaCard` the shadowed card, `IconBadge` the gradient icon tile (colour comes from the icon via `Seva.toneFor`). `Skyline` paints the Vidhana Soudha motif. Open a new screen with a `GlowPanel` and avoid bare lists on the page background. Anything painted beyond its box must clip, or it bleeds over page content.

**Language:** every string is inline as `(en, kn)`; data uses `L(en, kn)`. Catalogue entries from `assets/data/catalog.json` are English only, as in the source CSV.

**Navigation:** string routes in `lib/router.dart`. Notifications, assistant replies, SMS and the Feature Map all use `openRoute`. Tab routes switch tabs; the rest push.

**Simulation:**
- `SimSteps` shows fake multi-step network work.
- `think()` in `screens/assistant.dart` is the keyword "brain" behind the voice bot, live chat, WhatsApp and Ask, and reads real app state.
- `submitApplication` advances status on timers and raises `push()` banners; `PushBanner` overlays them from `MaterialApp.builder`.
- The scanner viewfinder, map and QR are painted. The QR encodes nothing.
- Calculators do real maths with example rates.

**Files:** `lib/data/seed.dart` holds demo content; `lib/screens/` has one file per area (`more.dart` holds smaller tools, `extras.dart` life events and calculators, `ai_home.dart` the Seva AI home and Ask).

**Tests:** `test/widget_test.dart` opens every screen in English and Kannada at 100% and 160% text and fails on overflow. Test fonts are wider than real ones, so it is deliberately strict. `test/flows_test.dart` taps through the core journeys. In `testWidgets`, load assets in `setUpAll`, since real file IO hangs under the fake clock.

`tool/capture_screens_test.dart` renders every screen to `screenshots/` (git-ignored) with the real fonts; run it with `flutter test tool/capture_screens_test.dart --update-goldens`. Look at the output: it catches visual bugs, like dark-on-dark titles, that the sweep cannot.

**Known constraints:** Kannada copy is machine-written and needs native review. Android has not been built here (no Android SDK). `dial()` places real calls, so the emergency and helpline numbers must stay correct.
