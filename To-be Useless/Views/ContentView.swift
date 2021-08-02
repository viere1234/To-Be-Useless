//
//  ContentView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("First") var first = true
    
    var body: some View {
        
        if first {
            FirstView()
        } else {
            TaskListView()
        }
    }
}
