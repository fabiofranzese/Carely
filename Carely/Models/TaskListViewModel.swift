//
//  TaskListViewModel.swift
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

class TaskListViewModel: ObservableObject, Identifiable {
    @Published var tasks: [TaskViewModel] = []
    private var ref: DatabaseReference!
    private let databaseURL = "https://carely-b368f-default-rtdb.europe-west1.firebasedatabase.app"
    @AppStorage("isCaregiver") var isCaregiver = true
    
    init() {
        ref = Database.database(url: self.databaseURL).reference()
        if isCaregiver{
            print("Caregiver Tasks Loading")
            getTasks()
        } else{
            print("Patient Tasks Loading")
            getPatientTasks()
        }
    }
    
    private func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
      }
    
    func getTasks() {
        if let uid = getCurrentUserID(){
            var refHandle = ref.child("users/\(uid)/tasks").observe(DataEventType.value, with: {snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else { return }
                self.tasks = value.compactMap { TaskViewModel(id: $0, dict: $1) }
                self.sendTasksToWatch()
            })}
    }
    
    func getPatientTasks() {
        let ref = Database.database(url: self.databaseURL).reference()
        getCaregiverEmail { email in
            guard let email = email else {
                print("Caregiver email not found")
                return
            }
            print("email", email)
            self.getUID(email: email) { uid in
                guard let uid = uid else {
                    print("User not found")
                    return
                }
                print(uid)
                // Doesn't load the tasks: TO FIX
                var refHandle = ref.child("users/\(uid)/tasks").observe(DataEventType.value, with: {snapshot in
                    print(snapshot.value)
                    guard let value = snapshot.value as? [String: [String: Any]] else { return }
                    print(value)
                    self.tasks = value.compactMap { TaskViewModel(id: $0, dict: $1) }
                    self.sendTasksToWatch()
                })
            }
        }
    }
    
    func sendTasksToWatch() {
        if WCSession.default.isReachable {
            let tasksData = getTasksForWatch()
            WCSession.default.sendMessage(["tasks": tasksData], replyHandler: nil) { error in
                print("Error sending tasks to watch: \(error.localizedDescription)")
            }
        }
    }
    
    func getTasksForWatch() -> [[String: Any]] {
        return tasks.map { task in
            return [
                "id": task.id,
                "title": task.title,
                "description": task.description,
                "date": task.date.timeIntervalSince1970,
                "isDone": task.isDone
            ]
        }
    }
    
    func getUID(email: String, completion: @escaping (String?) -> Void) {
        let ref = Database.database(url: self.databaseURL).reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let userSnapshot = child as? DataSnapshot,
                   let userData = userSnapshot.value as? [String: Any],
                   let userEmail = userData["email"] as? String,
                   userEmail.lowercased() == email.lowercased() {
                    print(userSnapshot.key, email)
                    completion(userSnapshot.key) // UID found
                    return
                }
            }
            completion(nil) // UID not found
        }
    }
    
    func getCaregiverEmail(completion: @escaping (String?) -> Void) {
        let ref = Database.database(url: self.databaseURL).reference()
        
        guard let uid = getCurrentUserID() else {
            completion(nil)
            return
        }
        
        ref.child("patients").child(uid).child("caregiverEmail").observeSingleEvent(of: .value) { snapshot in
            if let email = snapshot.value as? String {
                print("res", email) // This will print AFTER data is fetched
                completion(email)
            } else {
                completion(nil) // No email found
            }
        }
    }
    
    func createTask(task: [String: Any]){
        if let uid = getCurrentUserID(){
            let userRef = ref.child("users/\(uid)/tasks")
            userRef.childByAutoId().setValue(task) { error, _ in
                if let error = error {
                    print("Error adding new task: \(error.localizedDescription)")
                } else {
                    print("Successfully added new task!")
                }
            }
        }
    }
    
    func onViewDisappear() {
        ref.removeAllObservers()
      }
}
