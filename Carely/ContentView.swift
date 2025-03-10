//
//  ContentView.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isSignedIn") var isSignedIn = false
    @AppStorage("isCaregiver") var caregiver = true
    
    var body: some View {
        if isSignedIn {
            if caregiver {
                TaskListViewCaregiver()
            } else {
                TaskListViewPatient()
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
