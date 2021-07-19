//
//  MainView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskListVM = TaskListViewModel() // (7)
    @State var presentAddNewItem = false
    
    init() {
        UINavigationBar.appearance().tintColor = UIColor.red
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
    }
    
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        
        List {
          ForEach (taskListVM.taskCellViewModels) { taskCellVM in // (8)
            TaskCell(taskCellVM: taskCellVM) // (1)
          }
          .onDelete { indexSet in
            self.taskListVM.removeTasks(atOffsets: indexSet)
          }
          if presentAddNewItem { // (5)
            TaskCell(taskCellVM: TaskCellViewModel.newTask()) { result in // (2)
              if case .success(let task) = result {
                self.taskListVM.addTask(task: task) // (3)
              }
              self.presentAddNewItem.toggle() // (4)
            }
          }
        }
        .listStyle(InsetListStyle())
        
        Button(action: { self.presentAddNewItem.toggle() }) { // (6)
          HStack {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
            Text("New Task")
                .font(.headline)
          }
        }
        .padding()
        .accentColor(Color(UIColor.systemRed))
      }
      .navigationBarTitle("Useless Tasks")
      .toolbar {
        ToolbarItem() {
            NavigationLink(
                destination: SettingView(),
                label: {
                    Image(systemName: "gearshape.fill")
            })
        }
      }
    }
  }
}

struct TaskListView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView()
  }
}

struct TaskCell: View {
  @ObservedObject var taskCellVM: TaskCellViewModel // (1)
  var onCommit: (Result<Task, InputError>) -> Void = { _ in } // (5)
  
  var body: some View {
    HStack {
      Image(systemName: taskCellVM.completionStateIconName) // (2)
        .resizable()
        .frame(width: 20, height: 20)
        .onTapGesture {
          self.taskCellVM.task.completed.toggle()
        }
      TextField("Enter your useless tasks", text: $taskCellVM.task.title, // (3)
                onCommit: { //(4)
                  if !self.taskCellVM.task.title.isEmpty {
                    self.onCommit(.success(self.taskCellVM.task))
                  }
                  else {
                    self.onCommit(.failure(.empty))
                  }
      }).id(taskCellVM.id)
    }
  }
}

enum InputError: Error {
  case empty
}
