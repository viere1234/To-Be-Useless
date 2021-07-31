//
//  AboutView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/20.
//

import SwiftUI
import WebKit

struct AboutView: View {
    
    @State private var showBrianLinks = false
    @State private var showTerryLinks = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Image("AppPicture")
                .resizable()
                .frame(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 3.5, alignment: .center)
                .cornerRadius(15)
            
            Text("To-Be Useless")
                .font(.largeTitle)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.black.opacity(0.8))
            
            Spacer()
            
            HStack {
                Text("Developer & Designer :")
                Text("Brian Chang")
                    .underline()
                    .foregroundColor(.blue)
                    .onTapGesture(perform: {
                        self.showBrianLinks.toggle()
                    })
                Image(systemName: "link")
            }
            .padding(.bottom, 5)
            .actionSheet(isPresented: $showBrianLinks) {
                ActionSheet(title: Text("Social Networks"), buttons: [
                    .default(Text("Facebook : Brian Chang")) {
                        openURL(URL(string: "https://www.facebook.com/BrianChang0928/")!) },
                    .default(Text("Instagram : @chihyao_0928")) {
                        openURL(URL(string: "https://www.instagram.com/chihyao_0928/")!) },
                    .cancel()
                ])
            }
            
            HStack {
                Text("Designer & Marketing :")
                Text("Fu-Syuan Wang")
                    .underline()
                    .foregroundColor(.blue)
                    .onTapGesture(perform: {
                        self.showTerryLinks.toggle()
                    })
                Image(systemName: "link")
            }
            .actionSheet(isPresented: $showTerryLinks) {
                ActionSheet(title: Text("Social Networks"), buttons: [
                    .default(Text("Facebook : Fu-Syuan Wang")) {
                        openURL(URL(string: "https://www.facebook.com/terry.wang.20040119")!) },
                    .default(Text("Instagram : @tofus7.45")) {
                        openURL(URL(string: "https://www.instagram.com/tofus7.45/")!) },
                    .cancel()
                ])
            }
            
            Spacer()
            
            LottieView(name: "60586-developer-isometric-people-working-with-technology", loopMode: .loop)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
            
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
