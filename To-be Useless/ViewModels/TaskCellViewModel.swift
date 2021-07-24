//
//  TaskCellViewModel.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import Foundation
import Combine
import Resolver

class TaskCellViewModel: ObservableObject, Identifiable  {
  @Injected var taskRepository: TaskRepository
  
  @Published var task: Task
  
  var id: String = ""
  @Published var completionStateIconName = ""
  
  private var cancellables = Set<AnyCancellable>()
  
  static func newTask() -> TaskCellViewModel {
    TaskCellViewModel(task: Task(title: "", difficulty: .medium, completed: false))
  }
  
  init(task: Task) {
    self.task = task
    
    $task
      .map { $0.completed ? "checkmark.circle.fill" : "circle" }
      .assign(to: \.completionStateIconName, on: self)
      .store(in: &cancellables)

    $task
      .compactMap { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
    
    $task
      .dropFirst()
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .sink { [weak self] task in
        self?.taskRepository.updateTask(task)
      }
      .store(in: &cancellables)
  }
  
}

