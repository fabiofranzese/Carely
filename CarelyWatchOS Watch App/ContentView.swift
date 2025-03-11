//
//  ContentView.swift
//  CarelyWatchOS Watch App
//
//  Created by Daniele Fontana on 07/03/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var watchViewModel: WatchViewModel
    
    var body: some View {
            
           List {
                ForEach(watchViewModel.tasks
                    .filter { !$0.isDone }
                    .sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
                ) { task in
                    Text(task.isDone.description)
                    Text(task.date.description)}
                }
            
            .navigationTitle("Tasks")
        }
    }


// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let watchViewModel = WatchViewModel()
        
        watchViewModel.isSynced = false
        
        return ContentView()
            .environmentObject(watchViewModel)
    }
}
