//
//  DailyView.swift
//  Colordle
//
//  Created by Riley Koo on 5/18/26.
//

import SwiftUI

struct DailyView: View {
    @StateObject var data: DataModel = DataModel()
    @StateObject var vm: ViewModel = ViewModel()
    @State var start: Bool = false
    @State var round: Int = 0
    @State var showStats: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                if vm.dailyColors.isEmpty {
                    ProgressView()
                } else if data.completedToday >= 5 {
                    ResultsView(
                        scores: data.getTodaysGuesses(),
                        colors: vm.dailyColors
                    )
                } else if !start {
                    Button {
                        vm.update()
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
                        answer: vm.dailyColors[data.completedToday],
                        onNext: {
                            round += 1
                        },
                        onSubmit: { answer, guess in
                            data.guess(answer, guess)
                        }
                    )
                    .id(round)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Stats") {
                        showStats = true
                    }
                }
            }
            .popover(isPresented: $showStats) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Stats")
                        .font(.title2.bold())
                        .padding(.bottom, 4)

                    ScoreCard(date: "Overall", averageScore: data.getAverage())
                    
                    Divider()

                    // loop through all daily averages, sorted by date
                    ForEach(data.getDailyAverages().sorted(by: { $0.key > $1.key }), id: \.key) { date, avg in
                        ScoreCard(date: date, averageScore: avg)
                    }
                    Spacer()
                }
                .padding()
                .frame(minWidth: 300)
            }

        }
        .onAppear {
            vm.update()
        }
    }
}

struct ScoreCard: View {
    var date: String
    var averageScore: Double

    var body: some View {
        HStack {
            Text(date)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 100, height: 20)
                RoundedRectangle(cornerRadius: 4)
                    .fill(scoreColor(averageScore))
                    .frame(width: CGFloat(averageScore / 100) * 100, height: 20)
            }
            Text(String(format: "%.0f", averageScore))
                .font(.headline.monospacedDigit())
                .frame(width: 36, alignment: .trailing)
        }
    }

    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 80...100: return .green
        case 50...79:  return .orange
        default:       return .red
        }
    }
}
