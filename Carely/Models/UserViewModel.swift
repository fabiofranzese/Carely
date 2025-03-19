//
//  FirebaseViewModel.swift
//  Carely
//
//  Created by Daniele Fontana on 08/03/25.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth
import WatchConnectivity

class UserViewModel: ObservableObject {
    @AppStorage("isSignedIn") var isSignedIn = false
    @AppStorage("isCaregiver") var isCaregiver = true
    @Published var email = ""
    @Published var password = ""
    @Published var alert = false
    @Published var alertMessage = ""
    @Published var caregiverEmail = ""
    @Published var patientEmail = ""
    
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
        Auth.auth().createUser(withEmail: patientEmail, password: password) { result, err in
            if let err = err {
                self.alertMessage = err.localizedDescription
                self.alert.toggle()
            } else {
                self.login()
                guard let user = result?.user else { return }
                let uid = user.uid
                let ref = Database.database(url: self.databaseURL).reference()
                ref.child("patients").child(uid).setValue(["caregiver": false, "email": self.patientEmail, "caregiverEmail" : self.email]) { error, _ in
                    if let error = error {
                        print("Error saving user data: (error.localizedDescription)")
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
            } else{
                Auth.auth().createUser(withEmail: self.email, password: self.password) { result, err in
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
        }
    }
    
    func getCaregiverEmail() -> String {
        let ref = Database.database(url: self.databaseURL).reference()
        var res = ""
        if let uid = getCurrentUserID() {
            print(uid)
            var refHandle = ref.child("patients").child(uid).child("caregiverEmail").observe(DataEventType.value, with: {snapshot in
                guard let value = snapshot.value as? String else { return }
                res = value
                print(res)
            })
        }
        return res
    }
    
    private func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
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
