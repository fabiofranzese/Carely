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

class WatchViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var tasks: [WatchTask] = []
    @Published var isSynced: Bool = false
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let tasksData = message["tasks"] as? [[String: Any]] {
            DispatchQueue.main.async {
                self.tasks = tasksData.compactMap { dict in
                    guard let id = dict["id"] as? String,
                          let title = dict["title"] as? String,
                          let description = dict["description"] as? String,
                          let date = dict["date"] as? TimeInterval,
                          let isDone = dict["isDone"] as? Bool else {
                        return nil
                    }
                    return WatchTask(
                        id: id,
                        title: title,
                        description: description,
                        date: Date(timeIntervalSince1970: date),
                        isDone: isDone
                    )
                }
                self.isSynced = true
            }
        }
    }
}
