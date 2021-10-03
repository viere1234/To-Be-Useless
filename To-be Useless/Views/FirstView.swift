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
    @Environment(\.openURL) var openURL
    
    var body: some View {
        
        VStack {
            GeometryReader { main in
                OffsetPageTabView(offset: $offset) {
                    HStack(spacing: 0) {
                        ForEach(intros) {intro in
                            VStack {
                                switch intro.order
                                {
                                case 1:
                                    VStack {
                                        //Spacer()
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                        
                                        Image("AppPicture")
                                            .resizable()
                                            .cornerRadius(UIScreen.main.bounds.width / 15.9230769)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: UIScreen.main.bounds.width / 4)
                                            //.padding([.top], UIScreen.main.bounds.height / 4.5)
                                        //Spacer()
                                        
                                        Text("To-be Useless")
                                            .font(.system(.largeTitle, design: .rounded))
                                            .fontWeight(.bold)
                                        
                                        
                                        //Spacer()
                                        Spacer()
                                        
                                        LottieView(name: "lf30_editor_rrt6z0zt", loopMode: .loop)
                                            .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5, alignment: .center)
                                            .rotationEffect(.degrees(-90))
                                            .offset(x: UIScreen.main.bounds.width / 70)
                                            //.padding([.top], UIScreen.main.bounds.height / 10)
                                        /*
                                        VStack(alignment: .leading, spacing: 22, content: {
                                            Text("Welcome to \"To-be Useless\"")
                                                .font(.system(.title, design: .rounded))
                                                .fontWeight(.bold)
                                        })
                                        .padding(.top, 50)
                                        .frame(maxWidth: .infinity, alignment: .leading) */
                                        
                                        Spacer()
                                        Spacer()
                                    }
                                case 2:
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        Spacer()
                                        
                                        Text("How to use it?")
                                            .font(.system(.largeTitle, design: .rounded))
                                            .fontWeight(.bold)
                                            .padding(.leading)
                                        
                                        Spacer()
                                        
                                        NewDetail(image: "rectangle.fill.on.rectangle.angled.fill", imageColor: .orange,
                                                  title: "Refresh Mission",
                                                  description: "Every day we will provide you with up to 6 missions, and you can refresh it by the button (once per day).")
                                            .padding([.bottom])
                                        
                                        NewDetail(image: "calendar.badge.clock", imageColor: .red,
                                                  title: "Daily Mission Time",
                                                  description: "We will refresh your missions every day, and you can change the refresh time at \"Daily Mission Time\" in Settings.")
                                            .padding([.top, .bottom])
                                        
                                        NewDetail(image: "arrow.turn.right.up", imageColor: .blue,
                                                  title: "Contribute your mission",
                                                  description: "If you want to add any mission to this app, you can go to \"Mission Proposal\" in Settings and fill in the form.")
                                            .padding([.top])
                                        
                                        Spacer()
                                        Spacer()
                                    }
                                    //.padding([.top], UIScreen.main.bounds.height / 6.5)
                                    //.frame(height: UIScreen.main.bounds.height / 1.3)
                                default:
                                    VStack {
                                        Spacer()
                                            .frame(height: UIScreen.main.bounds.height / 13)
                                        
                                        Text("If you don't know what to do next,\njust come back and get your\ndaily missions!")
                                            .font(.system(.title2, design: .rounded))
                                            .fontWeight(.bold)
                                            .padding([.bottom, .top])
                                            .multilineTextAlignment(.center)
                                                                    
                                        Text("For more information,\nplease visit \"Information Center\"\nin \"Settings\".")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                            .padding([.bottom])
                                        
                                        Text("Or interact directly in our")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                        
                                        Button(action: {
                                            openURL(URL(string: "https://discord.gg/ReEwSbNdMV")!)
                                        }, label: {
                                            HStack {
                                                Text("Discord Community")
                                                    .underline()
                                                    .foregroundColor(.blue.opacity(0.9))
                                                    .font(.headline)
                                                    .multilineTextAlignment(.center)
                                                Image(systemName: "link")
                                            }
                                        })
                                    }
                                    //.padding([.top], UIScreen.main.bounds.height / 20)
                                }
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width, height: main.size.height)
                        }
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
                        .frame(width: UIScreen.main.bounds.width * 0.88, height: UIScreen.main.bounds.width / 8.28, alignment: .center)
                        .background(Color("OnBoardingUIColor"))
                        .cornerRadius(15)
                })
                
                Spacer()
            }
            .padding(.top, 15)
            //.padding(.bottom, 20)
            
            VStack {
                Text("By started you accept our")
                    .padding(.top, 5)
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                
                Button(action: {
                    openURL(URL(string: "https://www.privacypolicies.com/live/0748be9e-79ac-455c-9c3f-68ed5df5273f")!)
                }, label: {
                    Text("Privacy Policy")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black.opacity(0.9))
                        .underline()
                })
            }
            //.ignoresSafeArea(.all)
            .padding(.bottom)
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

#if DEBUG
struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
#endif

struct NewDetail: View {
    var image: String
    var imageColor: Color
    var title: String
    var description: String

    var body: some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: image)
                    .font(.system(size: UIScreen.main.bounds.width / 10.35))
                    .frame(width: UIScreen.main.bounds.width / 8.92)
                    .foregroundColor(imageColor)
                    .padding()

                VStack(alignment: .leading) {
                    Text(LocalizedStringKey(title))
                        .font(.system(.body, design: .rounded))
                        .bold()
                
                    Text(LocalizedStringKey(description))
                        .font(.system(.footnote, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
