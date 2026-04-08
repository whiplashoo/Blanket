//
//  ContentView.swift
//  Blanket
//
//  Created by Minas Giannekas on 8/4/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
  @StateObject private var player = BrownNoisePlayer()
  @State private var isBreathing = false
  @State private var tapDepth = false
  private let surface = Color(red: 0.10, green: 0.11, blue: 0.15)
  private let lightShadow = Color.white.opacity(0.10)
  private let darkShadow = Color.black.opacity(0.62)

  var body: some View {
    ZStack {
      surface
        .overlay(
          RadialGradient(
            colors: [
              Color(red: 0.27, green: 0.32, blue: 0.44).opacity(player.isPlaying ? 0.30 : 0.12),
              Color(red: 0.12, green: 0.15, blue: 0.23).opacity(player.isPlaying ? 0.18 : 0.06),
              .clear
            ],
            center: .center,
            startRadius: 30,
            endRadius: 420
          )
          .scaleEffect(isBreathing ? 1.10 : 0.92)
          .opacity(isBreathing ? 1.0 : 0.78)
          .animation(
            .easeInOut(duration: player.isPlaying ? 4.8 : 7.2).repeatForever(autoreverses: true),
            value: isBreathing
          )
        )
        .ignoresSafeArea()

      Button {
        tapDepthAnimation()
        impactFeedback()
        player.togglePlayback()
      } label: {
        ZStack {
          let corner = player.isPlaying ? 66.0 : 42.0

          RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(surface)
            .modifier(
              SoftOuterShadow(
                isPressed: player.isPlaying,
                darkShadow: darkShadow,
                lightShadow: lightShadow,
                cornerRadius: corner
              )
            )
            .modifier(
              SoftInnerShadow(
                isPressed: player.isPlaying,
                darkShadow: darkShadow,
                lightShadow: lightShadow,
                cornerRadius: corner
              )
            )

          ZStack {
            Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
              .font(.system(size: player.isPlaying ? 56 : 64, weight: .black, design: .rounded))
              .foregroundStyle(lightShadow.opacity(0.45))
              .offset(x: player.isPlaying ? 0 : 4)
              .offset(x: -1.1, y: -1.1)

            Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
              .font(.system(size: player.isPlaying ? 56 : 64, weight: .black, design: .rounded))
              .foregroundStyle(darkShadow.opacity(0.9))
              .offset(x: player.isPlaying ? 0 : 4)
              .offset(x: 1.2, y: 1.5)

            Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
              .font(.system(size: player.isPlaying ? 56 : 64, weight: .black, design: .rounded))
              .foregroundStyle(Color(red: 0.74, green: 0.78, blue: 0.86).opacity(player.isPlaying ? 0.58 : 0.78))
              .offset(x: player.isPlaying ? 0 : 4)
          }
        }
        .frame(width: 232, height: 232)
        .scaleEffect((player.isPlaying ? 0.985 : 1.0) * (tapDepth ? 0.95 : 1.0))
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: player.isPlaying)
        .animation(.spring(response: 0.20, dampingFraction: 0.62), value: tapDepth)
      }
      .buttonStyle(.plain)
      .accessibilityLabel(player.isPlaying ? "Pause" : "Play")
    }
    .preferredColorScheme(.dark)
    .onAppear {
      isBreathing = true
    }
  }

  private func impactFeedback() {
    let style: UIImpactFeedbackGenerator.FeedbackStyle = player.isPlaying ? .rigid : .soft
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred(intensity: 0.9)
  }

  private func tapDepthAnimation() {
    tapDepth = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
      tapDepth = false
    }
  }
}

#Preview {
  ContentView()
}

private struct SoftOuterShadow: ViewModifier {
  let isPressed: Bool
  let darkShadow: Color
  let lightShadow: Color
  let cornerRadius: CGFloat

  func body(content: Content) -> some View {
    content
      .shadow(color: isPressed ? .clear : darkShadow, radius: 18, x: 14, y: 14)
      .shadow(color: isPressed ? .clear : lightShadow, radius: 14, x: -10, y: -10)
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .stroke(Color.white.opacity(isPressed ? 0.03 : 0.08), lineWidth: 1)
      )
  }
}

private struct SoftInnerShadow: ViewModifier {
  let isPressed: Bool
  let darkShadow: Color
  let lightShadow: Color
  let cornerRadius: CGFloat

  func body(content: Content) -> some View {
    content
      .overlay {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .stroke(lightShadow.opacity(isPressed ? 0.28 : 0), lineWidth: 6)
          .blur(radius: 4)
          .mask(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
              .fill(
                LinearGradient(
                  colors: [.black, .clear],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
          )
      }
      .overlay {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .stroke(darkShadow.opacity(isPressed ? 0.42 : 0), lineWidth: 7)
          .blur(radius: 5)
          .mask(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
              .fill(
                LinearGradient(
                  colors: [.clear, .black],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
          )
      }
  }
}
