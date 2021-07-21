//
//  Task.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import Foundation

enum TaskPriority: Int, Codable {
  case high
  case medium
  case low
}

struct Task: Codable, Identifiable {
  var id: String = UUID().uuidString
  var title: String
  var priority: TaskPriority
  var completed: Bool
}
