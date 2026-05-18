
# Colordle 🎨

A daily color-guessing game for iOS, inspired by Wordle. Each day you get 5 unique colors to memorize and match — fully offline, no backend required.

## Gameplay

1. A color is shown for 5 seconds — memorize it
2. Use the HSB color wheel to mix your best guess
3. Score is based on how close your guess is to the target
4. Repeat for all 5 daily colors
5. Come back tomorrow for a new set

An **Infinite Mode** lets you play unlimited rounds with randomly generated colors.

## Architecture

```
Colordle/
├── ColordleApp.swift        # App entry point
├── ContentView.swift        # Root TabView (Daily / Infinite)
├── DailyView.swift          # Daily game flow + stats toolbar
├── InfiniteView.swift       # Infinite mode with Play Again
├── RoundView.swift          # Single round UI (reveal → guess → score)
├── HSBWheelPicker.swift     # Custom inline HSB color wheel
├── ResultsView.swift        # End-of-game scorecard
├── ViewModel.swift          # Daily color generation + scoring
├── DataModel.swift          # Persistence via UserDefaults
└── Constants.swift          # Shared constants
```

### Key Design Decisions

**Offline-first color generation** — Daily colors are derived deterministically from the current date using a seeded hash function (djb2-style mixing of year/month/day components). No server, no lookup table — the same 5 colors are always produced for a given date on any device.

```swift
// Same date → same seed → same colors, forever
var h: UInt32 = UInt32(round) &* 2654435761
h ^= year  &* 2246822519
h ^= month &* 3266489917
h ^= day   &* 668265263
h ^= h >> 16
h &*= 0x45d9f3b
h ^= h >> 16
```

**Scoring** — RGB component distance, normalized to 0–100. Max possible distance (black vs white) maps to 0, perfect match maps to 100.

```swift
let dist = abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2)
return max(0, 100 - (dist * 100 / 765))
```

**Persistence** — `DataModel` stores completed round scores keyed by date string (`"yyyy-MM-dd"`) in `UserDefaults` as JSON. Data is only written after all 5 rounds are completed, so incomplete days don't persist.

**Custom color wheel** — SwiftUI's built-in `ColorPicker` doesn't support inline rendering. `HSBWheelPicker` draws a hue/saturation wheel using `Canvas`, with drag gesture for selection and a separate brightness slider.

## Requirements

- iOS 17+
- Xcode 15+
- No third-party dependencies

## Setup

```bash
git clone <repo>
open Colordle.xcodeproj
```

Run on simulator or device — no configuration needed.

## Stats

The stats popover (toolbar button in Daily mode) shows your overall average score and a per-day breakdown of all completed games, sorted by most recent.
