# Log

## 2026-11-06: Full visual redesign, demo wording removed

The user called the first version basic, with too much empty space, and said UMANG looked better. They also want no mention of "demo" anywhere, since real people are the audience, so the DEMO chip, Feature Map, Reset demo and Simulate next step were all removed. The redesign adds gradient headers with a Vidhana Soudha skyline, hero panels, shadowed cards, gradient icon tiles, a raised centre assistant button, and real content on thin screens such as bill history charts and calculator breakdowns. UMANG stays the feature reference, not the visual one.

Because nothing is labelled simulated any more, the emergency and helpline numbers now dial for real; a fake call there would be dangerous. Payments, verification and application status are still simulated and must not reach the public like that. Review by eye matters: the skyline bled over page content because FittedBox does not clip by default, and no test could see it. The user declined an Antigravity review for this work.

## 2026-11-06: Changed the typeface to Noto Sans

The portal's DM Sans and Space Grotesk read as a tech startup, and the user rejected them as wrong for a government app. Everything now uses Noto Sans, which is plain, highly legible and matches the bundled Noto Sans Kannada. Keep the type neutral; do not reintroduce a display font.

## 2026-11-06: Built the simulated SevaOne app

Built a no-backend Flutter demo covering the 21 features in the plan PDF, plus features seen in UMANG. UMANG is the main feature reference, but its UI must not be copied; the colleague's existing SevaOne app was shown for context only and is not a target to match. Branding comes from the seva-one web portal. The user explicitly did not want a "service status" panel or OTP-by-call fallback, so those were removed; do not re-add them.

Decisions: no plugins at all, so simulated features cannot fail on permissions or need CocoaPods, and the demo stays offline. Web fonts were woff2 variable fonts, which Flutter cannot use, so they were converted to static TTF weights. A global store with an InheritedNotifier keeps the code small, which suits a demo.

Lessons: `rootBundle` inside `testWidgets` hangs under the fake clock, so load in `setUpAll`. Horizontal lists build lazily, so finding off-screen chips in tests fails even when the app is fine. The Simulator tool needs the user's permission; it was unanswered, so the app was checked through a web build instead of being driven around that permission.
