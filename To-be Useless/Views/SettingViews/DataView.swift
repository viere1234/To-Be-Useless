//
//  DataView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/27.
//

import SwiftUI
import Disk

struct DataView: View {
    
    let content = try! Disk.retrieve("tasks.json", from: .documents, as: [Task].self)
    
    var body: some View {
        VStack {
            Button(action: {print(content)}, label: {
                Text("Get Data")
            })
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}

