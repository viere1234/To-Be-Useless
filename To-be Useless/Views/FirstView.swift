//
//  FirstView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import Combine

struct FirstView: View {
    
    @AppStorage("First") var first = true
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        VStack {
            OffsetPageTabView(offset: $offset) {
                HStack(spacing: 0) {
                    ForEach(intros) {intro in
                        VStack {
                            
                            if intro.animation {
                                LottieView(name: intro.image, loopMode: .loop)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: UIScreen.main.bounds.height/2)
                            } else {
                                Image(intro.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: UIScreen.main.bounds.height/2)
                            }
                            
                            VStack(alignment: .leading, spacing: 22, content: {
                                Text(intro.title)
                                    .font(.title.bold())
                                
                                Text(intro.description)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            })
                            .padding(.top, 50)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            
            HStack(spacing: 12) {
                ForEach(intros.indices, id: \.self) {index in
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: (getIndex() == index ? 20 : 7), height: 7)
                }
            }
            .overlay(
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 7)
                    .offset(x: getIndicatorOffset())
                
                ,alignment: .leading
            )
            
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation{
                        first.toggle()
                    }
                }, label: {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .font(.system(size: 20, design: .rounded))
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 44, alignment: .center)
                        .background(Color("OnBoardingUIColor"))
                        .cornerRadius(25)
                })
                
                Spacer()
            }
            .padding(.top)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
    
    func getIndicatorOffset()->CGFloat {
        let progress = offset / UIScreen.main.bounds.width
        let maxWidth: CGFloat = 12 + 7
        
        return progress * maxWidth
    }
    
    func getIndex() -> Int {
        let progress = round(offset / UIScreen.main.bounds.width)
        
        let index = min(Int(progress), intros.count - 1)
        return index
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}

/*
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
                                Text("Get Started")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, design: .rounded))
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 44, alignment: .center)
                                    .background(Color("OnBoardingUIColor"))
                                    .cornerRadius(25)
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
*/
