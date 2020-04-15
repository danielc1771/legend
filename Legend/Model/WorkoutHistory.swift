//
//  WorkoutHistory.swift
//  Legend
//
//  Created by Daniel Castro on 3/30/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//
import Foundation

struct WorkoutHistory {
    let date : Double
    let strWorkout : [String: [[String: Int]]]
    let agiWorkout: [String: String]
    let duration: String
    let expGained: Int
    let type: String
    let dateObj: Date
    
    init(date: Double, strWorkout: [String: [[String: Int]]], agiWorkout: [String: String], duration: String, expGained:Int, type: String) {
        self.date = date
        self.strWorkout = strWorkout
        self.agiWorkout = agiWorkout
        self.duration = duration
        self.expGained = expGained
        self.type = type
    
        self.dateObj = Date(timeIntervalSince1970: TimeInterval(date))
    }
}
