# Blanket

A minimal iOS brown-noise app built with SwiftUI for sleep.

Blanket is intentionally simple: open the app, tap once, and let a local noise track play in the background all night.

## Features

- One-tap Play/Pause interface
- Local `noise.mp3` looping playback
- Background audio support (continues when app is backgrounded/locked)
- Lock Screen / Dynamic Island media controls via Now Playing
- Lock Screen widget shortcut that opens the app and toggles playback
- Minimal neumorphic UI with subtle motion and haptics

## Tech Stack

- SwiftUI
- AVFoundation (`AVAudioPlayer`, `AVAudioSession`)
- MediaPlayer (`MPNowPlayingInfoCenter`, `MPRemoteCommandCenter`)
- WidgetKit (Lock Screen widget)

## Project Structure

- `Blanket/` - iOS app source
  - `ContentView.swift` - main UI
  - `BrownNoisePlayer.swift` - audio playback/session logic
  - `Assets.xcassets/` - app assets, icons
- `BlanketWidgetExtension/` - lock screen widget extension

## Requirements

- Xcode 15+
- iOS 17+ (recommended)
- iPhone device for proper background-audio and lock screen behavior testing

## Setup

1. Clone the repo.
2. Open `Blanket.xcodeproj`.
3. Select your Development Team for both app and widget targets.
4. Build and run on device.

## Important Configuration Notes

- The app uses a manual plist at `Blanket-Info.plist`.
- `UIBackgroundModes` includes `audio` so playback can continue in background.
- App playback audio source is a bundled local file:
  - `Blanket/Resources/noise.mp3`

If you replace the sound file, keep the same name/extension or update `BrownNoisePlayer.swift`.

## Lock Screen Widget Notes

- Widget tap uses deep link: `blanket://toggle`
- The app handles this URL and toggles playback.
- The widget is designed as a quick action surface, not a full transport controller.

## Privacy

Blanket is local-first:

- no account
- no cloud sync
- no remote audio streaming required for playback

## Roadmap (Ideas)

- Sleep timer + fade out
- Alarm handoff
- Additional local sound packs
- App Shortcuts / Action Button integration

---

Built for personal use first, but polished to be clean and dependable.
