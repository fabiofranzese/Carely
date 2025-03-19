//
//  TaskListViewCaregiver.swift
//  Carely
//
//  Created by Daniele Fontana on 13/03/25.
//

import SwiftUI
import FirebaseAuth

struct TaskListViewCaregiver: View {
    @StateObject var tasksList = TaskListViewModel()
    @StateObject var user = UserViewModel()
    @State var addTask: Bool = false
    @State private var searchText: String = ""
    @State private var showMenu: Bool = false
    @State private var showLogoutAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer()
                            .frame(height: 50)

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
                            .foregroundColor(.purple)
                            .padding(.horizontal)

                        Divider()
                            .padding(.vertical)

                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 16) {
                            NavigationLink(destination: CompletedView(tasksList: tasksList)) {
                                BoxView(
                                    icon: "checkmark.seal",
                                    title: "Completed",
                                    count: tasksList.tasks.filter { $0.isDone }.count,
                                    color: .black
                                )
                            }

                            NavigationLink(destination: EmptyView()) {
                                BoxView(
                                    icon: "timer",
                                    title: "Scheduled",
                                    count: 0,
                                    color: .black
                                )
                            }

                            NavigationLink(destination: AllTasksView(tasksList: tasksList)) {
                                BoxView(
                                    icon: "tray",
                                    title: "All",
                                    count: tasksList.tasks.filter { !$0.isDone }.count,
                                    color: .black
                                )
                            }

                            NavigationLink(destination: NotesView()) {
                                BoxView(
                                    icon: "note.text",
                                    title: "Notes",
                                    count: nil,
                                    color: .black
                                )
                            }
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
            .sheet(isPresented: $addTask) {
                addTaskView(user: user, isPresented: $addTask, tasksList: tasksList)
            }
            .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
                Button("Yes", role: .destructive) {
                    user.logout()
                }
                Button("No", role: .cancel) {}
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

struct TaskListViewCaregiver_Previews: PreviewProvider {
    static var previews: some View {
        TaskListViewCaregiver()
    }
}

