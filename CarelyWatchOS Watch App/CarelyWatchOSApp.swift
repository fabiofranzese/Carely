//
//  CarelyWatchOSApp.swift
//  CarelyWatchOS Watch App
//
//  Created by Daniele Fontana on 07/03/25.
//

import SwiftUI
import WatchConnectivity


@main
struct CarelyWatchOSApp: App {
    @StateObject private var watchViewModel = WatchViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(watchViewModel)
        }
    }
}
