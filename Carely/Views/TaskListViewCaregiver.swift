//
//  TaskListViewCaregiver.swift
//  Carely
//
//  Created by Daniele Fontana on 13/03/25.
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

                // DELAYS Section
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
                    NavigationLink(destination: CompletedView(tasksList: tasksList)) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 100)
                            .foregroundColor(Color(.systemGray5))
                            .overlay(Text("Completed").foregroundColor(.black))
                    }

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
