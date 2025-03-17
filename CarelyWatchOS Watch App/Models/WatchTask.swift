//
//  WatchTask.swift
//  CarelyWatchOS Watch App
//
//  Created by Daniele Fontana on 08/03/25.
//

import Foundation

struct WatchTask: Identifiable {
    let id: String
    let title: String
    let description: String
    let date: Date
    var isDone: Bool
}
