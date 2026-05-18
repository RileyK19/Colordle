//
//  InfiniteView.swift
//  Colordle
//
//  Created by Riley Koo on 5/18/26.
//

import SwiftUI

struct InfiniteView: View {
    @State var colors: [Int] = []
    @State var scores: [Int] = []
    @State var round: Int = 0
    @State var start: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                if colors.isEmpty {
                    ProgressView()
                } else if round >= 5 {
                    ResultsView(
                        scores: scores,
                        colors: colors,
                        resultText: "Play again for new colors!"
                    )
                    Button {
                        resetAll()
                    } label: {
                        Text("Play Again")
                            .font(.headline)
                            .padding()
                            .background(Color.primary)
                            .foregroundStyle(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding(.horizontal)
                    }
                } else if !start {
                    Button {
                        start = true
                    } label: {
                        Text("Start")
                            .font(.headline)
                            .padding()
                            .background(Color.primary)
                            .foregroundStyle(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding(.horizontal)
                    }
                } else {
                    RoundView(
                        answer: colors[round],
                        onNext: {
                            round += 1
                        },
                        onSubmit: { answer, guess in
                            scores.append(ViewModel.score(answer, guess))
                        }
                    )
                    .id(round)
                }
            }
        }
        .onAppear {
            resetAll()
            generateColors()
        }
    }
    
    private func generateColors() {
        let seed = UInt32.random(in: 0...UInt32.max)
        colors = (0..<5).map { i in
            var h = seed &* 2654435761
            h ^= UInt32(i) &* 2246822519
            h ^= h >> 16
            h &*= 0x45d9f3b
            h ^= h >> 16
            return Int(h & 0xFFFFFF)
        }
    }
    
    private func resetAll() {
        colors = []
        scores = []
        round = 0
        start = false
    }
}
