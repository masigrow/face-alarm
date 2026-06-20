# 👁 Face Alarm

> **You can't stop it until your eyes are open.**

An iOS alarm app that requires you to hold your eyes open in front of the camera for 3 seconds to dismiss. No more half-asleep screen taps.

---

## Status

| Phase | Status | Target |
|-------|--------|--------|
| Phase 0 — Spec & Design | 🔄 In Progress | Jul 2026 |
| Phase 1 — MVP (Core alarm + face unlock) | ⏳ Pending | Aug 2026 |
| Phase 2 — Beta (TestFlight) | ⏳ Pending | Sep 2026 |
| Phase 3 — App Store v1.0 | ⏳ Pending | Oct 2026 |

---

## How It Works

1. Set an alarm as usual
2. When it fires, the camera activates
3. Keep **both eyes open** for **3 continuous seconds** → alarm dismissed
4. Look away or blink → timer resets

**Tech:** `Vision Framework` + `AVFoundation` — detects `leftEyeOpenConfidence` / `rightEyeOpenConfidence` (threshold: 0.8) at ~30fps.

---

## Pricing

- Launch: **¥300** (one-time purchase, Apple Tier 3)
- Post-viral bump: **¥500**
- No subscription. No ads.

---

## Tech Stack

- Language: Swift 5.10 / SwiftUI
- Face detection: Vision Framework (`VNDetectFaceLandmarksRequest`)
- Audio: AVAudioSession (`.playback` category for background alarm)
- AI support: Anthropic API + Claude Knowledge Plugin
- CI/CD: GitHub Actions → Fastlane → TestFlight

---

## Language Support

| Version | Languages |
|---------|-----------|
| v1.0 | English only |
| v1.x | + Japanese |
| v2.0+ | + Chinese, Korean, Spanish (data-driven) |

---

## Project Structure

```
FaceAlarm/
├── FaceAlarm/               # Main app target
│   ├── App/                 # Entry point, AppDelegate
│   ├── Features/
│   │   ├── Alarm/           # Alarm scheduling & management
│   │   ├── FaceUnlock/      # Vision Framework face detection
│   │   ├── Settings/        # User preferences
│   │   └── Stats/           # Wake history & streaks
│   ├── Core/
│   │   ├── Audio/           # AVAudioSession management
│   │   ├── Notifications/   # Local push notifications
│   │   └── ClaudeSupport/   # Anthropic API integration
│   └── Resources/           # Assets, Localizable.strings
├── FaceAlarmTests/
├── FaceAlarmUITests/
├── fastlane/
└── .github/
    ├── workflows/
    ├── ISSUE_TEMPLATE/
    └── PULL_REQUEST_TEMPLATE.md
```

---

## Development

### Prerequisites

- Xcode 16+
- iOS 17+ device (Vision Framework face detection requires real device)
- [Fastlane](https://fastlane.tools) for CI/CD

### Setup

```bash
git clone https://github.com/YOUR_USERNAME/face-alarm.git
cd face-alarm
open FaceAlarm.xcodeproj
```

### Branching

This project uses **GitHub Flow**:

```
main          ← always deployable
└── feature/face-detection
└── feature/alarm-scheduler
└── fix/low-light-detection
└── chore/update-dependencies
```

- Branch from `main`
- Open a PR even for solo work (self-review creates a useful log)
- Squash merge into `main`
- Tag releases: `v1.0.0`, `v1.1.0`, etc.

---

## Milestones & Issues

Track everything in [GitHub Issues](../../issues) and [Milestones](../../milestones):

- `📐 Phase 0` — Spec & Design
- `🔨 Phase 1` — MVP
- `🧪 Phase 2` — Beta
- `🚀 Phase 3` — App Store

**Labels:** `feature` `bug` `design` `marketing` `chore` `claude-ai`

---

## CI/CD

GitHub Actions runs on every PR and push to `main`:

1. **SwiftLint** — code style
2. **Unit Tests** — `xcodebuild test`
3. **TestFlight Deploy** — on merge to `main` with version bump (via Fastlane)

---

## Links

- [Roadmap (Word doc)](./FaceAlarm_Roadmap.docx)
- [App Store Connect](https://appstoreconnect.apple.com) *(after account setup)*
- [TestFlight](https://testflight.apple.com) *(after Phase 2)*
- [claude.ai/design](https://claude.ai/design) *(UI design)*

---

## Contact

William Takagi — [takagi@studiosaitama.com](mailto:takagi@studiosaitama.com)
