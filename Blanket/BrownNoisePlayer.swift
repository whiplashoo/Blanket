import AVFoundation
import Combine

final class BrownNoisePlayer: ObservableObject {
  @Published private(set) var isPlaying = false

  private var samplePlayer: AVAudioPlayer?

  init() {
    configureAudioSession()
    configureSamplePlayer()
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
}
