//
//  TaskListViews.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import SwiftUI

struct TaskListViewCaregiver: View {
    @StateObject var tasksList = TaskListViewModel()
    var body: some View {
        NavigationStack{
            Button(action: {
                user.logout()
            }) {
                HStack {
                    Image(systemName: "person")
                    Text("Logout")
                }
            }
            let taskListView = List {
                ForEach(tasksList.tasks) { task in
                    NavigationLink (destination: TaskDetailView(task: task)){
                        Text(task.id)}
                }
            }
            taskListView
            let addTask = Button(action: {
                tasksList.createTask(task: ["title": "titolo1",
                                            "description": "descrizione1",
                                            "date": Date().timeIntervalSince1970,
                                            "isRecurrent": false,
                                            "interval": ["start": 0, "end": 0],
                                            "isDone": false
                                           ])
            }) {
                HStack {
                    Image(systemName: "map")
                    Text("Add task")
                }
            }
            addTask
        }
    }
}

struct TaskListViewPatient: View {
    @StateObject var tasksList = TaskListViewModel()
    var body: some View {
        Text("TaskListViewPatient")

        Button(action: user.logout) {
            Text("Logout")
        }
    }
}
