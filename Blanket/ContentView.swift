//
//  ContentView.swift
//  Blanket
//
//  Created by Minas Giannekas on 8/4/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var player = BrownNoisePlayer()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.06, blue: 0.10),
                    Color(red: 0.10, green: 0.12, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Text("Blanket")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.95))

                Text(player.isPlaying ? "Brown noise is playing" : "Tap to start sleeping sound")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.65))

                Button {
                    player.togglePlayback()
                } label: {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.22, green: 0.25, blue: 0.34),
                                    Color(red: 0.14, green: 0.16, blue: 0.24)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.12), lineWidth: 2)
                        )
                        .frame(width: 220, height: 220)
                        .overlay {
                            VStack(spacing: 8) {
                                Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 42, weight: .bold))
                                Text(player.isPlaying ? "PAUSE" : "PLAY")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                        }
                        .shadow(color: Color.black.opacity(0.4), radius: 24, x: 0, y: 16)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(player.isPlaying ? "Pause brown noise" : "Play brown noise")
            }
            .padding(24)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
