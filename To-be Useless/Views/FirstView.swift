//
//  FirstView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import Combine

struct FirstView: View {
    
    let photos = ["IMG_6067", "IMG_6068", "IMG_6069", "IMG_6070", "IMG_6071"]
    @State var currentIndex: Int = 0
    @AppStorage("First") var first = true
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color(.white)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        TabView(selection: $currentIndex) {
                            ForEach(photos.indices) { index in
                                Image(photos[index])
                                    .resizable()
                                    .scaledToFill()
                                    .tag(index)
                                    .padding(.bottom, 100)
                            }
                            .frame(width: geometry.size.width, alignment: .top)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
                        CustomTabIndicator(count: 5, current: $currentIndex)
                            .frame(width: 75, height:8, alignment: .center)
                            .padding(.bottom)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                withAnimation{
                                    first.toggle()
                                }
                            }, label: {
                                Text("Get started")
                                    .frame(width: 160, height: 60, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                    .cornerRadius(7)
                            })
                            
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
            .accentColor(.black)
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomTabIndicator: View {
    
    var count: Int
    @Binding var current: Int
    
    var body: some View {
        HStack {
            ForEach(0..<count, id: \.self) { index in
                ZStack {
                    if (current) == index {
                        Circle()
                            .fill(Color.gray)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                }
            }
        }
    }
}
