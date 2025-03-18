//
//  WatchViewModel.swift
//  CarelyWatchOS Watch App
//
//  Created by Daniele Fontana on 16/03/25.
//

import Foundation
import WatchConnectivity

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
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let tasksData = applicationContext["tasks"] as? [[String: Any]] {
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
    
    func markTaskAsDone(taskId: String) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].isDone = true
            
            if WCSession.default.isReachable {
                let message = ["taskId": taskId]
                WCSession.default.sendMessage(message, replyHandler: nil) { error in
                    print("Error sending task done message: \(error.localizedDescription)")
                }
            }
            
            tasks.remove(at: index)
        }
    }
}
