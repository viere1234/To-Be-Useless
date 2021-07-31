//
//  SupportView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI

struct SupportView: View {
    
    @ObservedObject var model = WebViewModel(url: "https://to-be-useless.notion.site/to-be-useless/To-be-Useless-c78abcd5caba493bb9bce50ae093c9c1")
    
    var body: some View {
        LoadingView(isShowing: self.$model.isLoading) {
            WebView(viewModel: self.model)
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
    }
}
