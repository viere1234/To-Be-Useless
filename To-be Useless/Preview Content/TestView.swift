//
//  TestView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/30.
//

import SwiftUI
import BottomSheet

struct TestView: View {
    
    @State var tmp = false
    
    var body: some View {
        
        Button(action: {self.tmp.toggle()}, label: {
            Text("Button")
        })
        .bottomSheet(isPresented: $tmp, height: UIScreen.main.bounds.height) {
            FirstView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
//, height: UIScreen.main.bounds.height / 1.3
