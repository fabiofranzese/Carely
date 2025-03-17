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
