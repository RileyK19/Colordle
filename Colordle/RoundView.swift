//
//  RoundView.swift
//  Colordle
//
//  Created by Riley Koo on 5/16/26.
//

import SwiftUI

struct RoundView: View {
    @State var answer: Int
    @State var guess: Int = 0
    @State var submitted: Bool = false
    @State var revealing: Bool = true
    @State var timeLeft: Int = 5
    var onNext: () -> Void
    var onSubmit: (_ ans: Int, _ gs: Int) -> Void

    var answerColor: Color {
        Color(
            red:   Double((answer >> 16) & 0xFF) / 255,
            green: Double((answer >> 8)  & 0xFF) / 255,
            blue:  Double((answer)       & 0xFF) / 255
        )
    }

    var guessColor: Color {
        Color(
            red:   Double((guess >> 16) & 0xFF) / 255,
            green: Double((guess >> 8)  & 0xFF) / 255,
            blue:  Double((guess)       & 0xFF) / 255
        )
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Color square
            ZStack {
                if submitted {
                    // Side by side after submission
                    HStack(spacing: 0) {
                        answerColor
                        guessColor
                    }
                    .frame(width: 280, height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        HStack {
                            Text("Answer").font(.caption).foregroundStyle(.white)
                            Spacer()
                            Text("Guess").font(.caption).foregroundStyle(.white)
                        }
                        .padding(8),
                        alignment: .bottom
                    )
                } else if revealing {
                    // Show answer color with countdown
                    answerColor
                        .frame(width: 240, height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            Text("\(timeLeft)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(.white.opacity(0.8))
                        )
                } else {
                    // Guess phase — show guess color
                    guessColor
                        .frame(width: 240, height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .animation(.easeInOut, value: submitted)

            Spacer()

            // Picker + submit (only shown during guess phase)
            if !revealing && !submitted {
                HSBWheelPicker(guess: $guess)
                    .padding(.horizontal)

                Button("Submit") {
                    onSubmit(answer, guess)
                    submitted = true
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary)
                .foregroundStyle(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
            }

            if submitted {
                    Text("Score: \(ViewModel.score(answer, guess)) / 100")
                        .font(.title2.bold())

                    Button("Continue") {
                        onNext()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                }

            Spacer()
        }
        .onAppear { startCountdown() }
        .padding(.top, 20)
        .padding(.bottom, 49)
    }

    private func startCountdown() {
        timeLeft = 5
        revealing = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timeLeft -= 1
            if timeLeft <= 0 {
                timer.invalidate()
                withAnimation { revealing = false }
            }
        }
    }
}



#Preview {
    RoundView(answer: 0, onNext: {}, onSubmit: { _, _ in })
}
