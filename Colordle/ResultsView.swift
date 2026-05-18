//
//  ResultsView.swift
//  Colordle
//
//  Created by Riley Koo on 5/16/26.
//

import SwiftUI

struct ResultsView: View {
    let scores: [Int]      // today's scores from data.completed[dateString]
    let colors: [Int]      // today's colors from viewModel.dailyColors

    var average: Int { scores.reduce(0, +) / scores.count }
    
    var resultText: String = "Come back tomorrow for new colors!"

    var body: some View {
        VStack(spacing: 24) {
            Text("Today's Results")
                .font(.largeTitle.bold())

            Text("Average: \(average) / 100")
                .font(.title2)
                .foregroundStyle(scoreColor(average))

            VStack(spacing: 12) {
                ForEach(scores.indices, id: \.self) { i in
                    HStack(spacing: 16) {
                        // the actual color
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color(from: colors[i]))
                            .frame(width: 44, height: 44)

                        // score bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.secondary.opacity(0.2))
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(scoreColor(scores[i]))
                                    .frame(width: geo.size.width * CGFloat(scores[i]) / 100)
                            }
                        }
                        .frame(height: 24)

                        Text("\(scores[i])")
                            .font(.headline.monospacedDigit())
                            .frame(width: 36)
                    }
                }
            }
            .padding(.horizontal)

            Text(resultText)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private func color(from hex: Int) -> Color {
        Color(
            red:   Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8)  & 0xFF) / 255,
            blue:  Double((hex)       & 0xFF) / 255
        )
    }

    private func scoreColor(_ score: Int) -> Color {
        switch score {
        case 80...100: return .green
        case 50...79:  return .orange
        default:       return .red
        }
    }
}
