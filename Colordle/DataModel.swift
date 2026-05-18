//
//  DataModel.swift
//  Colordle
//
//  Created by Riley Koo on 5/16/26.
//

import Foundation
import Combine

class DataModel: ObservableObject {
    @Published var completed: [String: [Int]] = [:]

    private let key = "completed"

    init() {
        load()
    }

    var completedToday: Int {
        let str = dateString(from: Date())
        return completed[str]?.count ?? 0
    }

    func guess(_ color: Int, _ guessColor: Int) {
        let score = ViewModel.score(color, guessColor)
        let str = dateString(from: Date())
        if completed[str] == nil {
            completed[str] = []
        }
        completed[str]!.append(score)

        // only save once all 5 rounds done
        if completed[str]!.count >= 5 {
            save()
        }
    }
    
    func getTodaysGuesses() -> [Int] {
        return completed[dateString(from: Date())] ?? []
    }
    
    func getAverage() -> Double {
        var sum: Int = 0
        var totalScores: Int = 0
        for (_, value) in completed {
            totalScores += value.count
            sum += value.reduce(0, +)
        }
        return (Double(sum)) / (Double(totalScores))
    }
    
    func getDailyAverages() -> [String: Double] {
        var ret: [String: Double] = [:]
        for (key, value) in completed {
            ret[key] = (Double(value.reduce(0, +)) / Double(value.count))
        }
        return ret
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(completed) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String: [Int]].self, from: data) {
            completed = decoded
        }
    }

    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
