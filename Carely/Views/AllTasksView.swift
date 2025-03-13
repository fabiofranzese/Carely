//
//  AllTasksView.swift
//  Carely
//
//  Created by Daniele Fontana on 13/03/25.
//

import SwiftUI

struct AllTasksView: View {
    @ObservedObject var tasksList: TaskListViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasksList.tasks
                    .filter { !$0.isDone }
                    .sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
                ) { task in
                    NavigationLink(destination: TaskDetailViewCaregiver(task: task)) {
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                            Text(task.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(task.date.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("All")
        }
    }
}

