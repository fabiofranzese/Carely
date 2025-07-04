import SwiftUI

struct AllTasksView: View {
    @ObservedObject var tasksList: TaskListViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("All")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                let listTask = tasksList.tasks
                
                if listTask.isEmpty {
                    Text("No tasks yet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                ForEach(listTask) { task in
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: task.isDone ? "inset.filled.circle" : "circle")
                            .font(.system(size: 24))
                            .foregroundColor(task.isDone ? .purple : .gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.headline)
                            Text(task.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(task.date.formatted(date: .numeric, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    //TO-DO IMPLEMENT FUNCTION IN THE DATABASE
    func delete(at offsets: IndexSet) {
        // Remove tasks at the given index set
        tasksList.tasks.remove(atOffsets: offsets)
    }
}
