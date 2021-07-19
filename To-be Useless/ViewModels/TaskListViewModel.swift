//
//  TaskListViewModel.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import Foundation
import Combine
import Resolver

class TaskListViewModel: ObservableObject {
  @Published var taskRepository: TaskRepository = Resolver.resolve()
  @Published var taskCellViewModels = [TaskCellViewModel]()
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    taskRepository.$tasks.map { tasks in
      tasks.map { task in
        TaskCellViewModel(task: task) // (2)
      }
    }
    .assign(to: \.taskCellViewModels, on: self)
    .store(in: &cancellables)
  }
  
  func removeTasks(atOffsets indexSet: IndexSet) {
    // remove from repo
    let viewModels = indexSet.lazy.map { self.taskCellViewModels[$0] }
    viewModels.forEach { taskCellViewModel in
      taskRepository.removeTask(taskCellViewModel.task) // (1)
    }
  }
  
  func addTask(task: Task) {
    taskRepository.addTask(task)
  }
}
