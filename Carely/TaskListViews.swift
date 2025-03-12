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
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button(action: {
                        user.logout()
                    }) {
                        HStack {
                            Image(systemName: "person")
                            Text("Logout")
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)

                Text("To-do Tasks")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                TextField("Search tasks...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                Text("DELAYS")
                    .font(.headline)
                    .padding(.horizontal)

                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding(.horizontal)


                Divider()
                    .padding(.vertical)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 16) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .foregroundColor(Color(.systemGray5))
                        .overlay(Text("Completed").foregroundColor(.black))

                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .foregroundColor(Color(.systemGray5))
                        .overlay(Text("Scheduled").foregroundColor(.black))

                    NavigationLink(destination: AllTasksView(tasksList: tasksList)) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 100)
                            .foregroundColor(Color(.systemGray5))
                            .overlay(Text("All").foregroundColor(.black))
                    }

                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .foregroundColor(Color(.systemGray5))
                        .overlay(Text("Notes").foregroundColor(.black))
                }
                .padding(.horizontal)

                VStack {
                    Text("Create the first task for your care receiver.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Tap the plus button to get started.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical)

                Button(action: {
                    addTask = true
                }) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom)
            }
            .sheet(isPresented: $addTask) {
                addTaskViewContent(user: user, isPresented: $addTask, tasksList: tasksList)
            }
            .onAppear {
                tasksList.getTasks()
                tasksList.getTasksForWatch()
            }
            .onDisappear {
                tasksList.onViewDisappear()
            }
        }
    }
}

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

struct TaskListViewCaregiver_Previews: PreviewProvider {
    static var previews: some View {
        TaskListViewCaregiver()
    }
}
