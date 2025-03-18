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
