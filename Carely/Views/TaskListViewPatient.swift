//
//  TaskListViewPatient.swift
//  Carely
//
//  Created by Daniele Fontana on 16/03/25.
//

import SwiftUI
import FirebaseAuth

struct TaskListViewPatient: View {
    @StateObject var tasksList = TaskListViewModel()
    @StateObject var user = UserViewModel()
    @State private var showMenu: Bool = false
    @State private var showLogoutAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer()
                            .frame(height: 50)

                        Text("To-Do")
                            .font(.largeTitle)
                            .bold()
                            .padding(.horizontal)

                        let dailyTasks = tasksList.tasks
                            .filter { !$0.isDone && Calendar.current.isDateInToday($0.date) }
                            .sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })

                        if dailyTasks.isEmpty {
                            Text("No tasks for today")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            ForEach(dailyTasks) { task in
                                HStack(alignment: .center, spacing: 12) {
                                    Button(action: {
                                        tasksList.markTaskAsDone(taskId: task.id)
                                    }) {
                                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 24))
                                            .foregroundColor(task.isDone ? .green : .gray)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(task.title)
                                            .font(.headline)
                                            .strikethrough(task.isDone, color: .gray)
                                        Text(task.description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .strikethrough(task.isDone, color: .gray)
                                        Text(task.date.formatted(date: .omitted, time: .shortened))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Menu {
                    if let email = Auth.auth().currentUser?.email {
                        Text("Logged in as: \(email)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Button(role: .destructive, action: {
                        showLogoutAlert = true
                    }) {
                        Label("Logout", systemImage: "person.fill.xmark")
                    }
                } label: {
                    Image(systemName: showMenu ? "person.circle.fill" : "person.circle")
                        .font(.title)
                        .foregroundColor(.purple)
                        .padding()
                }
                .onTapGesture {
                    showMenu.toggle()
                }
                .padding(.trailing, 16)
            }
            .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
                Button("Yes", role: .destructive) {
                    user.logout()
                }
                Button("No", role: .cancel) {}
            }
            .onAppear {
                tasksList.getPatientTasks()
            }
            .onDisappear {
                tasksList.onViewDisappear()
            }
        }
    }
}

struct TaskListViewPatient_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = TaskListViewModel()
        
        let task1 = TaskViewModel(
            id: "1",
            title: "Task 1",
            description: "Description for Task 1",
            date: Date(),
            isRecurrent: false,
            interval: DateInterval(start: Date(), end: Date()),
            isDone: false
        )
        
        let task2 = TaskViewModel(
            id: "2",
            title: "Task 2",
            description: "Description for Task 2",
            date: Date(),
            isRecurrent: false,
            interval: DateInterval(start: Date(), end: Date()),
            isDone: false
        )
        
        mockViewModel.tasks = [task1, task2]
        
        return TaskListViewPatient(tasksList: mockViewModel)
    }
}
