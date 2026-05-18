//
//  HSBWheelPicker.swift
//  Colordle
//
//  Created by Riley Koo on 5/16/26.
//


import SwiftUI

struct HSBWheelPicker: View {
    @Binding var guess: Int

    @State private var hue: Double = 0.5
    @State private var saturation: Double = 0.5
    @State private var brightness: Double = 0.8

    private let wheelSize: CGFloat = 260

    var body: some View {
        VStack(spacing: 20) {
            // Wheel
            ZStack {
                // Draw the hue/saturation wheel
                Canvas { ctx, size in
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let radius = size.width / 2

                    for y in stride(from: 0, to: size.height, by: 1.5) {
                        for x in stride(from: 0, to: size.width, by: 1.5) {
                            let dx = x - center.x
                            let dy = y - center.y
                            let dist = sqrt(dx * dx + dy * dy)
                            guard dist <= radius else { continue }

                            let angle = (atan2(dy, dx) + .pi) / (2 * .pi)
                            let sat = dist / radius

                            let color = Color(hue: angle, saturation: sat, brightness: brightness)
                            ctx.fill(Path(CGRect(x: x, y: y, width: 1.5, height: 1.5)), with: .color(color))
                        }
                    }
                }
                .frame(width: wheelSize, height: wheelSize)
                .clipShape(Circle())

                // Selector dot
                let angle = hue * 2 * .pi - .pi
                let r = saturation * wheelSize / 2
                Circle()
                    .stroke(Color.white, lineWidth: 3)
                    .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
                    .frame(width: 24, height: 24)
                    .offset(
                        x: r * cos(angle),
                        y: r * sin(angle)
                    )
                    .shadow(radius: 3)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let center = CGPoint(x: wheelSize / 2, y: wheelSize / 2)
                        let dx = value.location.x - center.x
                        let dy = value.location.y - center.y
                        let dist = sqrt(dx * dx + dy * dy)

                        // angle → hue
                        hue = ((atan2(dy, dx) + .pi) / (2 * .pi))
                        // distance from center → saturation, clamped to circle
                        saturation = min(dist / (wheelSize / 2), 1.0)

                        updateGuess()
                    }
            )

            // Brightness slider
            VStack(alignment: .leading, spacing: 4) {
                Text("Brightness").font(.caption).foregroundStyle(.secondary)
                ZStack {
                    // gradient track
                    LinearGradient(
                        colors: [.black, Color(hue: hue, saturation: saturation, brightness: 1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .frame(height: 24)

                    Slider(value: $brightness, in: 0...1)
                        .tint(.clear)
                        .onChange(of: brightness) { updateGuess() }
                }
            }
            .padding(.horizontal)
        }
        .onAppear { updateGuess() }
    }

    private func updateGuess() {
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        guess = (Int(r * 255) << 16) | (Int(g * 255) << 8) | Int(b * 255)
    }
}