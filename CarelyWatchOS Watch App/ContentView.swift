//
//  ContentView.swift
//  CarelyWatchOS Watch App
//
//  Created by Daniele Fontana on 07/03/25.
//

import SwiftUICore
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var watchViewModel: WatchViewModel
    
    var body: some View {
        List {
            ForEach(watchViewModel.tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.headline)
                    Text(task.description)
                        .font(.subheadline)
                    Text(task.date, style: .date)
                        .font(.caption)
                }
            }
        }
        .navigationTitle("Tasks")
    }
}


struct ContentViewWatch_Previews: PreviewProvider {
    static var previews: some View {
        let watchViewModel = WatchViewModel()
        
        watchViewModel.tasks = [
            WatchTask(
                id: "1",
                title: "Task 1",
                description: "Description 1",
                date: Date(),
                isDone: false
            ),
            WatchTask(
                id: "2",
                title: "Task 2",
                description: "Description 2",
                date: Date().addingTimeInterval(86400),
                isDone: true
            ),
            WatchTask(
                id: "3",
                title: "Task 3",
                description: "Description 3",
                date: Date().addingTimeInterval(172800),
                isDone: false
            )
        ]
        
        return ContentView()
            .environmentObject(watchViewModel)
    }
}
