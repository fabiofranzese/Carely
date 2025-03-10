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
        NavigationStack {
            
            HStack {
                Button(action: {
                    user.logout()
                }) {
                    Image(systemName: "line.3.horizontal")
                }
                Spacer()
                Button(action: {
                    addTask = true
                }) {
                    Text(Image(systemName: "plus"))
                }
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $addTask) {
                    addTaskViewContent(user: user, isPresented: $addTask, tasksList: tasksList)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.top, -15)
            .font(.title2)
            
            let taskListView = List {
                ForEach(tasksList.tasks
                    .filter { !$0.isDone }
                    .sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
                ) { task in
                    NavigationLink(destination: TaskDetailViewCaregiver(task: task)) {
                        VStack{
                            Text(task.title)
                            Text(task.description)
                            Text(task.date.description)
                        }
                    }
                }
            }
            taskListView
            
        }
        //        .toolbar {
        //            ToolbarItem(placement: .topBarLeading) {
        //                Button(action: {
        //                    user.logout()
        //                }) {
        //                    Image(systemName: "line.3.horizontal")
        //                }
        //            }
        //            ToolbarItem(placement: .topBarTrailing) {
        //                Button(action: {
        //                    addTask = true
        //                }) {
        //                    Text(Image(systemName: "plus"))
        //                }
        //                    .buttonStyle(BorderlessButtonStyle())
        //                    .sheet(isPresented: $addTask) {
        //                        addTaskViewContent(user: user, isPresented: $addTask, tasksList: tasksList)
        //                    }
        //            }
        //        }
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
    
    @State var title : String = ""
    @State var desc : String = ""
    @State private var selectedDate = Date()
    @State private var isRecurrent = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    tasksList.createTask(task: ["title": title,
                                                "description": desc,
                                                "date": selectedDate.timeIntervalSince1970,
                                                "isRecurrent": isRecurrent,
                                                "interval": ["start": 0, "end": 0],
                                                "isDone": false
                                               ])
                    isPresented = false
                }) {
                    Text("Add")
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                
                Text("Title")
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            VStack(alignment: .leading) {
                
                Text("Description")
                TextField("Description", text: $desc)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            VStack(alignment: .leading) {
                
                DatePicker("Time of the task", selection: $selectedDate)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Toggle("Recurrent", isOn: $isRecurrent)
            }
            .padding()
            
            Spacer()
        }
        
        .font(.system(size: 18))
    }
}

struct TaskListViewPatient: View {
    @StateObject var tasksList = TaskListViewModel()
    @StateObject var user = UserViewModel()
    var body: some View {
        NavigationStack {
            
            HStack {
                Button(action: {
                    user.logout()
                }) {
                    Text("Logout")
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.top, -10)
            
            let taskListView = List {
                ForEach(tasksList.tasks
                    .filter { !$0.isDone }
                    .sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
                ) { task in
                    NavigationLink (destination: TaskDetailViewPatient(task: task)) {
                        VStack{
                            Text(task.title)
                            Text(task.description)
                            Text(task.date.description)
                        }
                    }
                }
            }
            taskListView
            
        }
        .onAppear {
            tasksList.getTasks()
        }
        .onDisappear {
            tasksList.onViewDisappear()
        }
    }
}
