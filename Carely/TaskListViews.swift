//
//  TaskListViews.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import SwiftUI

struct addTaskViewContent: View {
    var user: UserViewModel
    @Binding var isPresented: Bool
    @ObservedObject var tasksList: TaskListViewModel
    var body: some View {
        VStack{
            Text("add Task")
            let add = Button(action: {
                tasksList.createTask(task: ["title": "titolonuovo",
                                            "description": "descrizionenuobo",
                                            "date": Date().timeIntervalSince1970,
                                            "isRecurrent": false,
                                            "interval": ["start": 0, "end": 0],
                                            "isDone": false
                                           ])
                isPresented = false
            }) {
                HStack {
                    Image(systemName: "map")
                    Text("Add task")
                }
            }
            add
        }
    }
}

struct TaskListViewPatient: View {
    @StateObject var tasksList = TaskListViewModel()
    @StateObject var user = UserViewModel()
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
                ForEach(tasksList.tasks
                    .filter { !$0.isDone }
                    .sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
                ) { task in
                    NavigationLink (destination: TaskDetailViewPatient(task: task)){
                        VStack{
                            Text(task.title)
                            Text(task.description)
                            Text(task.date.description)
                        }}
                }
            }
            taskListView

            Button(action: {
                print(user.getCaregiverEmail())
            }) {
                HStack {
                    Image(systemName: "mail")
                    Text("Logout")
                }
            }
        }
        .onAppear {
            tasksList.getPatientTasks()
        }
          .onDisappear {
              tasksList.onViewDisappear()
          }
    }
}
