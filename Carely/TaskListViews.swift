//
//  TaskListViews.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import SwiftUI

struct TaskListViewCaregiver: View {
    @StateObject var tasksList = TaskListViewModel()
    @StateObject var user = UserViewModel()
    @State var addTask: Bool = false
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
                    NavigationLink (destination: TaskDetailViewCaregiver(task: task)){
                        Text(task.id)}
                }
            }
            taskListView
            
            let addTaskView = Button(action: {
                addTask = true
            }) {
              Text("Add Task".uppercased())
                .bold()
            }
                .sheet(isPresented: $addTask) {
                    addTaskViewContent(user: user, isPresented: $addTask, tasksList: tasksList)
            }
            addTaskView
            .buttonStyle(BorderlessButtonStyle())
        }
        .onAppear {
            tasksList.getTasks()
          }
          .onDisappear {
              tasksList.onViewDisappear()
          }
    }
}

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
                ForEach(tasksList.tasks) { task in
                    NavigationLink (destination: TaskDetailViewPatient(task: task)){
                        Text(task.id)}
                }
            }
            taskListView

            Button(action: {
                print(user.getCaregiverEmail())
            }) {
                HStack {
                    Image(systemName: "email")
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
