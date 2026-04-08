import AVFoundation
import Combine

final class BrownNoisePlayer: ObservableObject {
  @Published private(set) var isPlaying = false

  private var samplePlayer: AVAudioPlayer?

  init() {
    configureAudioSession()
    configureSamplePlayer()
    registerForAudioSessionNotifications()
    logRuntimeAudioConfiguration()
  }

  func togglePlayback() {
    isPlaying ? stop() : start()
  }

  private func start() {
    do {
      try AVAudioSession.sharedInstance().setActive(true)
      samplePlayer?.play()
      isPlaying = samplePlayer?.isPlaying ?? false
    } catch {
      isPlaying = false
      print("Failed to start sample playback: \(error.localizedDescription)")
    }
  }

  private func stop() {
    samplePlayer?.pause()
    samplePlayer?.currentTime = 0
    isPlaying = false
  }

  private func configureAudioSession() {
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(.playback, mode: .default, options: [])
      try session.setActive(true)
    } catch {
      print("Failed to configure audio session: \(error.localizedDescription)")
    }
  }

  private func registerForAudioSessionNotifications() {
    let center = NotificationCenter.default

    center.addObserver(
      forName: AVAudioSession.interruptionNotification,
      object: AVAudioSession.sharedInstance(),
      queue: .main
    ) { [weak self] notification in
      guard let self else { return }
      guard
        let userInfo = notification.userInfo,
        let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
        let type = AVAudioSession.InterruptionType(rawValue: typeValue)
      else { return }

      if type == .ended, self.isPlaying {
        do {
          try AVAudioSession.sharedInstance().setActive(true)
          self.samplePlayer?.play()
        } catch {
          print("Failed to reactivate audio session: \(error.localizedDescription)")
        }
      }
    }
  }

  private func configureSamplePlayer() {
    guard let resourceURL = Bundle.main.url(forResource: "noise", withExtension: "mp3") else {
      print("noise.mp3 not found in app bundle")
      samplePlayer = nil
      return
    }

    do {
      let player = try AVAudioPlayer(contentsOf: resourceURL)
      player.numberOfLoops = -1
      player.volume = 1.0
      player.prepareToPlay()
      samplePlayer = player
    } catch {
      print("Failed to load noise.mp3 sample: \(error.localizedDescription)")
    }
  }

  private func logRuntimeAudioConfiguration() {
    let modes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] ?? []
    let session = AVAudioSession.sharedInstance()
    print("UIBackgroundModes: \(modes)")
    print("Audio session category: \(session.category.rawValue), mode: \(session.mode.rawValue)")
  }
}
