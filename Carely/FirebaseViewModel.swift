//
//  FirebaseViewModel.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

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

class TaskListViewModel: ObservableObject, Identifiable {
    @Published var tasks: [TaskViewModel] = []
    private var ref: DatabaseReference!
    private let databaseURL = "https://carely-b368f-default-rtdb.europe-west1.firebasedatabase.app"
    
    init() {
        ref = Database.database(url: self.databaseURL).reference()
        getTasks()
        print(Auth.auth().currentUser?.uid ?? "no user")
    }
    
    private func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
      }
    
    func getTasks() {
        if let uid = getCurrentUserID() {
            var refHandle = ref.child("users/\(uid)/tasks").observe(DataEventType.value, with: {snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else { return }
                self.tasks = value.compactMap { TaskViewModel(id: $0, dict: $1) }
            })
        }
    }
    
    func getCaregiverEmail() -> String {
        let ref = Database.database(url: self.databaseURL).reference().child("patients")
        var res = ""
        if let uid = getCurrentUserID() {
            var refHandle = ref.child("patients/\(uid)/caregiverEmail").observeSingleEvent(of: .value) {snapshot in
                guard let value = snapshot.value as? String else { return }
                res = value
            }
        }
        print(res)
        return res
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
}

class UserViewModel: ObservableObject {
  @AppStorage("isSignedIn") var isSignedIn = false
  @AppStorage("isCaregiver") var isCaregiver = true
  @Published var email = ""
  @Published var password = ""
  @Published var alert = false
  @Published var alertMessage = ""
    @Published var caregiverEmail = ""
    
    private let databaseURL = "https://carely-b368f-default-rtdb.europe-west1.firebasedatabase.app"
    
  private func showAlertMessage(message: String) {
    alertMessage = message
    alert.toggle()
  }

  func login() {
    // check if all fields are inputted correctly
    if email.isEmpty || password.isEmpty {
      showAlertMessage(message: "Neither email nor password can be empty.")
      return
    }
      let ref = Database.database(url: self.databaseURL).reference().child("users")
      ref.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { snapshot in
          if snapshot.exists(){
              self.isCaregiver = true
          } else{
              self.isCaregiver = false
          }
      }

    // sign in with email and password
    Auth.auth().signIn(withEmail: email, password: password) { result, err in
      if let err = err {
        self.alertMessage = err.localizedDescription
        self.alert.toggle()
      } else {
        self.isSignedIn = true
          guard let user = result?.user else { return }
          let uid = user.uid
        let ref = Database.database(url: self.databaseURL).reference()
          print(ref.child("users").child(uid).child("tasks").description())
      }
    }
  }
    
    func signUp() {
    // check if all fields are inputted correctly
    if email.isEmpty || password.isEmpty {
      showAlertMessage(message: "Neither email nor password can be empty.")
      return
    }
    // sign up with email and password
      
    Auth.auth().createUser(withEmail: email, password: password) { result, err in
      if let err = err {
        self.alertMessage = err.localizedDescription
        self.alert.toggle()
      } else {
        self.login()
          guard let user = result?.user else { return }
          let uid = user.uid
          let ref = Database.database(url: self.databaseURL).reference()
          ref.child("users").child(uid).setValue(["caregiver": true, "email": self.email, "tasks" : [:]]) { error, _ in
              if let error = error {
                  print("Error saving user data: \(error.localizedDescription)")
              } else {
                  print("User data saved successfully!")
              }
          }
      }
    }
  }
    
    func patientSignUp() {
        if email.isEmpty || password.isEmpty {
          showAlertMessage(message: "Neither email nor password can be empty.")
          return
        }
        // sign up with email and password
        let ref = Database.database(url: self.databaseURL).reference().child("users")
        ref.queryOrdered(byChild: "email").queryEqual(toValue: caregiverEmail).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists(){
                self.showAlertMessage(message: "Caregiver not Found")
                return
            }
        }
                
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
          if let err = err {
            self.alertMessage = err.localizedDescription
            self.alert.toggle()
          } else {
            self.login()
              guard let user = result?.user else { return }
              let uid = user.uid
              let ref = Database.database(url: self.databaseURL).reference()
              ref.child("patients").child(uid).setValue(["caregiver": false, "email": self.email, "caregiverEmail": self.caregiverEmail]) { error, _ in
                  if let error = error {
                      print("Error saving user data: \(error.localizedDescription)")
                  } else {
                      print("User data saved successfully!")
                  }
              }
          }
        }
    }
    
    func emailToUID(email: String) -> String {
        let ref = Database.database(url: self.databaseURL).reference().child("users")
        var res = ""
        ref.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { snapshot in
            print(snapshot.description)
            res = snapshot.description
        }
        return res
    }
    
  func logout() {
    do {
      try Auth.auth().signOut()
      isSignedIn = false
        isCaregiver = false
      email = ""
      password = ""
    } catch {
      print("Error signing out.")
    }
  }
}

let user = UserViewModel()
