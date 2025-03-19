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

class TaskListViewModel: NSObject, ObservableObject, Identifiable {
    @Published var tasks: [TaskViewModel] = []
    private var ref: DatabaseReference!
    private let databaseURL = "https://carely-b368f-default-rtdb.europe-west1.firebasedatabase.app"
    @AppStorage("isCaregiver") var isCaregiver = true
    
    override init() {
        super.init()
        ref = Database.database(url: self.databaseURL).reference()
        
        // Attiva la sessione WatchConnectivity
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }

        if isCaregiver {
            print("Caregiver Tasks Loading")
            getTasks()
        } else {
            print("Patient Tasks Loading")
            getPatientTasks()
        }
    }
    
    private func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func getTasks() {
        if let uid = getCurrentUserID() {
            ref.child("users/\(uid)/tasks").observe(.value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else { return }
                self.tasks = value.compactMap { TaskViewModel(id: $0, dict: $1) }
                self.sendTasksToWatch() // Invia i task all'Apple Watch
            }
        }
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
                ref.child("users/\(uid)/tasks").observe(.value) { snapshot in
                    print(snapshot.value)
                    guard let value = snapshot.value as? [String: [String: Any]] else { return }
                    print(value)
                    self.tasks = value.compactMap { TaskViewModel(id: $0, dict: $1) }
                    self.sendTasksToWatch() // Invia i task all'Apple Watch
                }
            }
        }
    }
    
    func sendTasksToWatch() {
        let tasksData = getTasksForWatch()
        let context: [String: Any] = ["tasks": tasksData]

        do {
            try WCSession.default.updateApplicationContext(context)
            print("Dati inviati correttamente tramite applicationContext")
        } catch {
            print("Errore durante l'invio dei dati tramite applicationContext: \(error.localizedDescription)")
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
    
    func createTask(task: [String: Any]) {
        if let uid = getCurrentUserID() {
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
    func markTaskAsDone(taskId: String) {
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
                    ref.child("users/\(uid)/tasks/\(taskId)/isDone").setValue(true) { error, _ in
                        if let error = error {
                            print("Error marking task as done: (error.localizedDescription)")
                        } else {
                            print("Task marked as done successfully!")
                        }
                    }
                }
            }
        }

    /*func markTaskAsDone(taskId: String) {
        if let uid = getCurrentUserID() {
            ref.child("users/\(uid)/tasks/\(taskId)/isDone").setValue(true) { error, _ in
                if let error = error {
                    print("Error marking task as done: \(error.localizedDescription)")
                } else {
                    print("Task marked as done successfully!")
                }
            }
        }
    }*/
    
    func onViewDisappear() {
        ref.removeAllObservers()
    }
}

// MARK: - WCSessionDelegate
extension TaskListViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let taskId = message["taskId"] as? String {
            DispatchQueue.main.async {
                if let task = self.tasks.first(where: { $0.id == taskId }) {
                    task.done() // Usa la funzione `done` per aggiornare lo stato del task
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated")
        // Reactivate the session if needed
        WCSession.default.activate()
    }
}

