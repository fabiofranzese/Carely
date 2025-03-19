//
//  NotesView.swift
//  Carely
//
//  Created by Daniele Fontana on 19/03/25.
//

import SwiftUI

struct NotesView: View {
    @State private var pillsNotes: String = ""
    @State private var activitiesNotes: String = ""
    @State private var choresNotes: String = ""
    @State private var otherNotes: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Pills")
                    .font(.headline)
                TextEditor(text: $pillsNotes)
                    .frame(height: 100)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )


                Text("Activities")
                    .font(.headline)
                TextEditor(text: $activitiesNotes)
                    .frame(height: 100)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )

     
                Text("Chores")
                    .font(.headline)
                TextEditor(text: $choresNotes)
                    .frame(height: 100)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )


                Text("Other")
                    .font(.headline)
                TextEditor(text: $otherNotes)
                    .frame(height: 100)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding()
        }
        .navigationTitle("Notes")
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotesView()
        }
    }
}
