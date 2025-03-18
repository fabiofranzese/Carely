//
//  ContentView.swift
//  CarelyWatchOS Watch App
//
//  Created by Daniele Fontana on 07/03/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var watchViewModel: WatchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let nextTask = watchViewModel.tasks.first(where: { !$0.isDone }) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(nextTask.title)
                        .font(.headline)
                    Text(nextTask.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(nextTask.date.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    watchViewModel.markTaskAsDone(taskId: nextTask.id)
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            } else {
                // Nessun task disponibile
                Text("No tasks available")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .navigationTitle("Tasks")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let watchViewModel = WatchViewModel()
        
     
        watchViewModel.tasks = [
            WatchTask(
                id: "1",
                title: "Task 1",
                description: "Description for Task 1",
                date: Date(),
                isDone: false
            ),
            WatchTask(
                id: "2",
                title: "Task 2",
                description: "Description for Task 2",
                date: Date().addingTimeInterval(3600),
                isDone: false
            )
        ]
        
        return ContentView()
            .environmentObject(watchViewModel)
    }
}
