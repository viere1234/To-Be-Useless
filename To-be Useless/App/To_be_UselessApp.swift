//
//  To_be_UselessApp.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import Resolver
import StoreKit

@main
struct To_be_UselessApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    register { LocalTaskRepository() as TaskRepository }.scope(.application)
  }
}
