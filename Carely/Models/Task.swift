//
//  Task.swift
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

struct Task : Identifiable {
    var id: UUID
    var uid: String
    var title: String
    var description: String
    var date: Date
    var isRecurrent: Bool
    var interval: DateInterval
    var isDone: Bool
    
    mutating func done(user : String) {
        let ref: DatabaseReference = {
            Database.database(url: "https://carely-b368f-default-rtdb.europe-west1.firebasedatabase.app").reference()
        }()
        self.isDone = true
        ref.child("users/\(user)/tasks/\(uid)/isDone").setValue(true)
    }
}
