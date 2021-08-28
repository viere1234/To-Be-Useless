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
        VStack(alignment: .center) {
            Image("AppPicture")
                .resizable()
                .frame(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 3.5, alignment: .center)
                .cornerRadius(UIScreen.main.bounds.width / 15.9230769)
                
            HStack(spacing: 0) {
                Text("To-be ")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Useless")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("UIColor"))
            }
            
            /*
            Text("To-Be Useless")
                .font(.largeTitle)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.black.opacity(0.8))*/
            
            Spacer()
            
            VStack {
                Text("Developer & Designer :")
                    .font(.title3)
                    .padding(.bottom, 1)
                
                HStack {
                    Text("Brian Chang")
                        .underline()
                        .foregroundColor(.blue)
                        .onTapGesture(perform: {
                            self.showBrianLinks.toggle()
                        })
                }
            }
            .padding(.bottom, 10)
            .actionSheet(isPresented: $showBrianLinks) {
                ActionSheet(title: Text("Social Networks"), buttons: [
                    .default(Text("Facebook : Brian Chang")) {
                        openURL(URL(string: "https://www.facebook.com/BrianChang0928/")!) },
                    .default(Text("Instagram : @chihyao_0928")) {
                        openURL(URL(string: "https://www.instagram.com/chihyao_0928/")!) },
                    .cancel()
                ])
            }
            .padding([.horizontal])
            
            VStack {
                Text("Designer & Marketing :")
                    .font(.title3)
                    .padding(.bottom, 1)
                
                HStack {
                    Text("Fu-Syuan Wang")
                        .underline()
                        .foregroundColor(.blue)
                        .onTapGesture(perform: {
                            self.showTerryLinks.toggle()
                        })
                }
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
            .padding([.horizontal])
            
            Spacer()
            
            VStack {
                Text("Interact directly with us!")
                    .font(.title3)
                    .padding(.bottom, 1)
                
                Button(action: {
                    openURL(URL(string: "https://discord.gg/ReEwSbNdMV")!)
                }, label: {
                    HStack {
                        Text("Discord Community")
                            .underline()
                            .foregroundColor(.blue)
                    }
                })
            }
            
            Spacer()
            
            Button(action: {
                openURL(URL(string: "https://www.privacypolicies.com/live/0748be9e-79ac-455c-9c3f-68ed5df5273f")!)
            }, label: {
                Text("Privacy Policy")
                    .foregroundColor(.blue)
                    .underline()
            })
            
            Spacer()
            
            /*
            LottieView(name: "60586-developer-isometric-people-working-with-technology", loopMode: .loop)
                .aspectRatio(contentMode: .fit)
                .frame(width: .infinity)*/
            
        }
    }
}

#if DEBUG
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
#endif
