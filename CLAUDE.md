# Face Alarm — AI Context

This file gives Claude full context about this project so every session starts with shared understanding.

## What This App Does

iOS alarm app. To dismiss: hold eyes open in front of the camera for 3 continuous seconds.
Built with Vision Framework (`VNDetectFaceLandmarksRequest`) + AVFoundation.

## Key Decisions (don't re-litigate without reason)

- **Platform:** iOS only (Swift/SwiftUI). No Android, no React Native.
- **Pricing:** ¥300 one-time purchase at launch → ¥500 after traction. No subscription.
- **Language:** English first (v1.0), Japanese next (v1.x), then data-driven expansion.
- **Eye detection threshold:** 0.8 confidence on both `leftEyeOpenConfidence` and `rightEyeOpenConfidence`
- **Unlock duration:** 3 seconds continuous (≈90 frames @ 30fps). Blink = reset.
- **No TrueDepth required:** Uses standard AVFoundation, works on all modern iPhones.
- **AI support:** Claude Knowledge Plugin for in-app FAQ + personalized wake tips.
- **Design tool:** Claude Design (claude.ai/design) for UI mockups → Claude Code handoff.

## Branching Strategy (GitHub Flow)

- `main` is always deployable
- Feature branches: `feature/`, `fix/`, `chore/`, `design/`, `marketing/`
- PR even for solo work — creates audit trail
- Squash merge, then delete branch
- Release tags: `v1.0.0`, `v1.1.0`

## Milestones

- Phase 0 (Jul 2026): Spec, Figma/Claude Design mockups
- Phase 1 (Aug 2026): MVP — core alarm + face unlock
- Phase 2 (Sep 2026): Beta — TestFlight 50 users
- Phase 3 (Oct 2026): App Store v1.0 launch

## File Map

- `README.md` — public-facing project doc, source of truth for status
- `CLAUDE.md` — this file, AI context
- `CHANGELOG.md` — version history
- `FaceAlarm_Roadmap.docx` — full business + marketing plan
- `.github/` — issue templates, PR template, GitHub Actions workflows
- `fastlane/` — Fastlane config for TestFlight + App Store deployment

## Code Conventions

- SwiftUI for all UI
- MVVM architecture
- No third-party dependencies unless unavoidable
- All strings in `Localizable.strings` from day one (en, then ja)
- No `print()` in production — use `os.Logger`

## Marketing Notes

- Tagline: "You can't stop it until your eyes are open."
- Target: 18–35, English-speaking, tech-savvy, prone to oversleeping
- Channels: TikTok/Reels (demo video), X (thread), Product Hunt
- KPI: 1,000 DL week 1 → 10,000 DL by month 3

## Owner

William Takagi — takagi@studiosaitama.com — Studio Saitama
