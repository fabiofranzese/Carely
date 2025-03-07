//
//  TaskDetailView.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import SwiftUI

struct TaskDetailViewCaregiver: View {
    @ObservedObject var task: TaskViewModel
    var body: some View {
        VStack {
            Text(task.title)
            Button(action: {
                task.done()
            }) {
                Image(systemName: "person")
                Text("Done")
            }
        }
    }
}

struct TaskDetailViewPatient: View {
    @ObservedObject var task: TaskViewModel
    var body: some View {
        VStack {
            Text(task.title)
            Text(task.date.description)
            Button(action: {
                task.done()
            }) {
                Image(systemName: "person")
                Text("Done")
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var exampleTask = TaskViewModel(id: "1", title: "Titolo esempio", description: "Descrizione Esempio", date: Date(), isRecurrent: false, interval: DateInterval(), isDone: false)
    static var previews: some View {
        TaskDetailViewCaregiver(task: exampleTask)
    }
}
