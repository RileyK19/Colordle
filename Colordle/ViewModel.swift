//
//  ViewModel.swift
//  Colordle
//
//  Created by Riley Koo on 5/16/26.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    var dailyColors: [Int] = []
    var lastUpdated: Date? = nil
    var numDailyColors: Int = 5
    
    init() {
        update()
    }
    
    init(dailyColors: [Int], lastUpdated: Date? = nil, numDailyColors: Int) {
        self.dailyColors = dailyColors
        self.lastUpdated = lastUpdated
        self.numDailyColors = numDailyColors
        update()
    }
    
    func update() {
        let calendar = Calendar.current
        if lastUpdated == nil || !calendar.isDateInToday(lastUpdated!) {
            var colors: [Int] = []
            for round in 0..<numDailyColors {
                colors.append(hash(Date(), round))
            }
            dailyColors = colors
            lastUpdated = Date()
        }
    }
    
    private func hash(_ date: Date, _ round: Int) -> Int {
        let calendar = Calendar.current
        let year  = UInt32(calendar.component(.year,  from: date))
        let month = UInt32(calendar.component(.month, from: date))
        let day   = UInt32(calendar.component(.day,   from: date))

        var h: UInt32 = UInt32(round) &* 2654435761
        h ^= year  &* 2246822519
        h ^= month &* 3266489917
        h ^= day   &* 668265263

        h ^= h >> 16
        h &*= 0x45d9f3b
        h ^= h >> 16

        return Int(h & 0xFFFFFF) 
    }
    
    static func score(_ color: Int, _ guess: Int) -> Int {
        let r1 = Int((color >> 16) & 0xFF)
        let g1 = Int((color >> 8)  & 0xFF)
        let b1 = Int((color)       & 0xFF)

        let r2 = Int((guess >> 16) & 0xFF)
        let g2 = Int((guess >> 8)  & 0xFF)
        let b2 = Int((guess)       & 0xFF)

        let dist = abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2)
        // max possible dist is 255*3 = 765
        return max(0, 100 - (dist * 100 / 765))
    }
}
