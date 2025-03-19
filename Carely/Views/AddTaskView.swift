//
//  TaskListViews.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import SwiftUI

struct addTaskView: View {
    var user: UserViewModel
    @Binding var isPresented: Bool
    @ObservedObject var tasksList: TaskListViewModel
    
    @State var title : String = ""
    @State var desc : String = ""
    @State private var selectedDate = Date()
    @State private var isRecurrent = false
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.body)
                        .foregroundColor(.purple)
                }
                Spacer()
                Text("New Task")
                Spacer()
                Button(action: {
                    if(!title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                        tasksList.createTask(task: ["title": title,
                                                    "description": desc,
                                                    "date": selectedDate.timeIntervalSince1970,
                                                    "isRecurrent": isRecurrent,
                                                    "interval": ["start": 0, "end": 0],
                                                    "isDone": false
                                                   ])
                        isPresented = false
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Add")
                        .foregroundColor(.purple)
                }
                .alert("Error", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Add a title before adding the Task.")
                }
            }
            .padding()
            
            TextField("Title", text: $title)
                .foregroundColor(.purple)
                .padding(0.02 * UIScreen.main.bounds.height)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .padding()
                .padding(.bottom, -20)
            
            TextField("Description", text: $desc)
                .foregroundColor(.purple)
                .padding(0.02 * UIScreen.main.bounds.height)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .padding()
            
            VStack(alignment: .leading) {
                DatePicker("Time of the task", selection: $selectedDate)
                    .tint(.purple)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Toggle("Recurrent", isOn: $isRecurrent)
                    .tint(.purple)
            }
            .padding()
            
            Spacer()
        }
        
        .font(.system(size: 18))
    }
}
