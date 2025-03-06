//
//  TaskDetailView.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import SwiftUI

struct TaskDetailView: View {
    @State var task: TaskViewModel?
    var body: some View {
        Text(task?.title ?? "not found")
        Button(action:{
            task?.done()
        }) {
            Image(systemName: "person")
            Text("Done")
        }
    }
}

#Preview {
    TaskDetailView(task: TaskViewModel(id: "1", dict: ["title": "titolo1", "description": "descrizione1", "date": Date().timeIntervalSince1970, "isRecurrent": false, "interval": ["start": 0, "end": 0], "isDone": false]))
}
