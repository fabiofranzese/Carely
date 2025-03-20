//
//  ScheduledTaskView.swift
//  Carely
//
//  Created by Nicolò Amabile on 19/03/25.
//

import SwiftUI

struct ScheduledTaskView: View {
    @ObservedObject var tasksList: TaskListViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Scheduled")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                let listTask = tasksList.tasks.filter { !$0.isDone }
                
                if listTask.isEmpty {
                    Text("No tasks yet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                ForEach(listTask) { task in
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.headline)
                            Text(task.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(task.date.formatted(date: .numeric, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
