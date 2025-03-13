//
//  TaskViewModel.swift
//  Carely
//
//  Created by Daniele Fontana on 13/03/25.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth
import WatchConnectivity

class TaskViewModel: ObservableObject, Identifiable {
    @Published var id: String
    @Published var title: String
    @Published var description: String
    @Published var date: Date
    @Published var isRecurrent: Bool
    @Published var interval: DateInterval
    @Published var isDone: Bool
    
    private var ref = Database.database(url: "https://carely-b368f-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    init(id: String, title: String, description: String, date: Date, isRecurrent: Bool, interval: DateInterval, isDone: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.isRecurrent = isRecurrent
        self.interval = interval
        self.isDone = isDone
    }
    
    init?(id: String, dict: [String: Any]) {
        self.id = id
        guard let title = dict["title"] as? String else {return nil}
        guard let description = dict["description"] as? String else {return nil}
        guard let date = dict["date"] as? TimeInterval else {return nil}
        guard let isRecurrent = dict["isRecurrent"] as? Bool else {return nil}
        guard let interval = dict["interval"] as? [String: TimeInterval] else {return nil}
        guard let formattedinterval = DateInterval(start: Date(timeIntervalSince1970: interval["start"] ?? 0), end: Date(timeIntervalSince1970: interval["end"] ?? 0)) as? DateInterval else {return nil}
        guard let isDone = dict["isDone"] as? Bool else {return nil}
        
        self.title = title
        self.description = description
        self.date = Date(timeIntervalSince1970: date)
        self.isRecurrent = isRecurrent
        self.interval = formattedinterval
        self.isDone = isDone
    }
    
    private func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
      }
    
    func done() {
        if let uid = getCurrentUserID(){
            var done = true
            if self.isDone{
                done = false
            }
            ref.child("users/\(uid)/tasks/\(id)/isDone").setValue(done)
        }
    }
}
