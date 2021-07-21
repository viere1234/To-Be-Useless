//
//  MainView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import UIKit

struct TaskListView: View {
    @ObservedObject var taskListVM = TaskListViewModel() // (7)
    @State var presentAddNewItem = false
    @ScaledMetric(relativeTo: .largeTitle) var navigationBarLargeTitle: CGFloat = 40
    @ScaledMetric(relativeTo: .largeTitle) var navigationBarTitle: CGFloat = 20
    
    init() {
        let design = UIFontDescriptor.SystemDesign.rounded
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(design)!
        let largeTitle = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.init(descriptor: descriptor, size: navigationBarLargeTitle)
        ]
        let title = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.init(descriptor: descriptor, size: navigationBarTitle)
        ]
        
        //let font = UIFont.init(descriptor: descriptor, size: 30)
        UINavigationBar.appearance().tintColor = UIColor.red
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitle
        UINavigationBar.appearance().titleTextAttributes = title
        //UINavigationBar.appearance().largeTitleTextAttributes = [.font : font]
        //UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.rounded]
        //UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.rounded]
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
                .font(.system(Font.TextStyle.headline, design: .rounded))
          }
        }
        .padding()
        .accentColor(Color(UIColor.systemRed))
      }
            .navigationBarTitle(Text("To-Be Useless"))
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

extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}
