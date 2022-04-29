//
//  Task.swift
//  NC1
//
//  Created by Minawati on 27/04/22.
//

import Foundation

struct Task: Codable {
    let id: Int
    let title: String
    var currPomodoro: Int
    var totalPomodoros: Int
    var isCompleted: Bool
}
