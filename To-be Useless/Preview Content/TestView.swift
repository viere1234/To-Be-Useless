//
//  TestView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/30.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        LottieView(name: "23222-checkmark", loopMode: .loop)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
