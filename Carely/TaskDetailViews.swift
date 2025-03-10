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
            
            Spacer()
            
            Text(task.title)
                .font(.largeTitle)
                .frame(height: 100)
            
            Text(task.description)
                .multilineTextAlignment(.center)
                .font(.title3)
                .frame(height: 100)
            
            VStack(spacing: 10) {
                Text("Start: \(task.interval.start.formatted())")
                    .font(.title3)
                Text("End: \(task.interval.end.formatted())")
                    .font(.title3)
            }
            .padding()
            
            Spacer()
        }
    }
}

struct TaskDetailViewPatient: View {
    @ObservedObject var task: TaskViewModel
    var body: some View {
        VStack {
            
            Spacer()
            
            Text(task.title)
                .font(.largeTitle)
                .frame(height: 100)
            
            Text(task.description)
                .multilineTextAlignment(.center)
                .font(.title3)
                .frame(height: 100)
            
            VStack(spacing: 10) {
                Text("Start: \(task.interval.start.formatted())")
                    .font(.title3)
                Text("End: \(task.interval.end.formatted())")
                    .font(.title3)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                task.done()
                print("done")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 180, height: 60)
                    Text("\(Image(systemName: "checkmark.circle.fill")) Done")
                        .foregroundStyle(.white)
                }
            }
            Spacer()
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var exampleTask = TaskViewModel(id: "1", title: "Titolo esempio", description: "Descrizione Esempio", date: Date(), isRecurrent: false, interval: DateInterval(), isDone: false)
    static var previews: some View {
        TaskDetailViewPatient(task: exampleTask)
    }
}
