//
//  MainView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import UIKit
import UserNotifications
import SlideOverCard
import Lottie
import BetterSafariView



struct TaskListView10_10: View {
    //end
    
    // = .zero
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var offset: CGFloat = 0
    @State private var presentAddNewItem = false
    @State private var showAlert = false
    @State private var showMissionAlertSwicher = 0
    @State private var openTask = false
    @State private var isFinishMission = false
    @State private var missionSize: [CGSize] = [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    @State private var textSize: Dictionary<String, CGSize> = [:]
    @State private var size: CGSize = .zero
    @State private var reload = false
    @ObservedObject var taskListVM = TaskListViewModel()
    @ScaledMetric(relativeTo: .largeTitle) private var navigationBarLargeTitle: CGFloat = 40
    @ScaledMetric(relativeTo: .largeTitle) private var navigationBarTitle: CGFloat = 20
    @AppStorage("HapticActivated") private var hapticActivated = true
    @AppStorage("SpecialFirst10_10") private var specialFirst = true
    
    @AppStorage("SpecialMissionCounts10_10") var specialMissionCounts = 1
    @AppStorage("SpecialMissionCompletes10_10") var specialMissionCompletes = 0
    @AppStorage("SpecialTaskDifficultyList10_10") var specialTaskDifficultyList:[Int] = [0]
    @AppStorage("SpecialTaskIndexList10_10") var specialTaskIndexList:[Int] = [0]
    @AppStorage("SpecialTaskFinishList10_10") var specialTaskFinishList:[Bool] = [false]
    let generrator = UINotificationFeedbackGenerator()
    let missionRep = MissionRepsitory10_10()
    
    let preSize: CGFloat
    
    init(preSize: CGFloat) {
        self.preSize = preSize
        
        let design = UIFontDescriptor.SystemDesign.rounded
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(design)!
        let largeTitle = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.init(descriptor: descriptor, size: navigationBarLargeTitle)
        ]
        let title = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.init(descriptor: descriptor, size: navigationBarTitle)
        ]
        
        UINavigationBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitle
        UINavigationBar.appearance().titleTextAttributes = title
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("October 10th\nWorld Mental Health Day")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.medium)
                            
                            Spacer()
                        }
                        .padding(.bottom, 7)
                        
                        Text("Annual theme:\nMental Health in an Unequal World")
                            .font(.system(.headline, design: .rounded))
                            .padding(.bottom, 3)
                        
                        HStack {
                            Text("Complete the following missions and follow the issue of sexual harassment with the student club\"HER\"")
                                .font(.system(.subheadline, design: .rounded))
                            
                                .fontWeight(.regular)
                            
                            Spacer()
                            
                            Image(systemName: "staroflife.circle.fill")
                                
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.13)
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                }
                .multilineTextAlignment(.leading)
                .frame(width: UIScreen.main.bounds.width)
                .foregroundColor(Color.white)
                .background(Color("UIColor10_10"))
                
                GeometryReader { mainView in
                    ScrollView {
                        VStack(spacing: 15) {
                            if !specialFirst {
                                ForEach(specialTaskDifficultyList.indices, id: \.self) { i in//for i in 0...specialMissionCounts-1
                                    switch ((specialMissionCounts != 0 ? specialTaskDifficultyList[i] : 0)) {
                                    case 1:
                                        GeometryReader { item in
                                            TaskCell_10_10(index: i,
                                                           isFinishMission: $isFinishMission,
                                                           taskCellVM: missionRep.LowMission[specialTaskIndexList[i]],
                                                           textSize: $textSize[missionRep.LowMission[specialTaskIndexList[i]].id],
                                                           preSize: preSize,
                                                           width: mainView.size.width)
                                                .scaleEffect(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY), anchor: .bottom)
                                                .opacity(Double(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY)))
                                                .offset(x: (openTask ? 0 : mainView.size.width))
                                                //.readIntrinsicContentSize(to: $textSize[missionRep.LowMission[specialTaskIndexList[i]].id])
                                                .id(missionRep.LowMission[specialTaskIndexList[i]].id)
                                        }
                                        .frame(height: (textSize[missionRep.LowMission[specialTaskIndexList[i]].id]?.height ?? CGFloat(0)) + (preSize) * 1.2)
                                    case 2:
                                        GeometryReader { item in
                                            TaskCell_10_10(index: i,
                                                           isFinishMission: $isFinishMission,
                                                           taskCellVM: missionRep.MediumMission[specialTaskIndexList[i]],
                                                           textSize: $textSize[missionRep.MediumMission[specialTaskIndexList[i]].id],
                                                           preSize: preSize,
                                                           width: mainView.size.width)
                                                .scaleEffect(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY), anchor: .bottom)
                                                .opacity(Double(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY)))
                                                .offset(x: (openTask ? 0 : mainView.size.width))
                                                //.readIntrinsicContentSize(to: $textSize[missionRep.MediumMission[specialTaskIndexList[i]].id])
                                                .id(missionRep.MediumMission[specialTaskIndexList[i]].id)
                                        }
                                        .frame(height: (textSize[missionRep.MediumMission[specialTaskIndexList[i]].id]?.height ?? CGFloat(0)) + (preSize) * 1.2)
                                    case 3:
                                        GeometryReader { item in
                                            TaskCell_10_10(index: i,
                                                           isFinishMission: $isFinishMission,
                                                           taskCellVM: missionRep.HighMission[specialTaskIndexList[i]],
                                                           textSize: $textSize[missionRep.HighMission[specialTaskIndexList[i]].id],
                                                           preSize: preSize,
                                                           width: mainView.size.width)
                                                .scaleEffect(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY), anchor: .bottom)
                                                .opacity(Double(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY)))
                                                .offset(x: (openTask ? 0 : mainView.size.width))
                                                //.readIntrinsicContentSize(to: $textSize[missionRep.HighMission[specialTaskIndexList[i]].id])
                                                .id(missionRep.HighMission[specialTaskIndexList[i]].id)
                                        }
                                        .frame(height: (textSize[missionRep.HighMission[specialTaskIndexList[i]].id]?.height ?? CGFloat(0)) + (preSize) * 1.2)
                                    default:
                                        Text("")
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                    .zIndex(1)
                    .navigationBarTitle(Text("#WMHD2021"))
                    .navigationBarTitleDisplayMode(.inline)
                }
                    
                Spacer()
                
                ProgressView(percent: percent(complete: (openTask ? specialMissionCompletes : 0), count: specialMissionCounts), color: "UIColor10_10")
                        .padding([.bottom, .leading, .trailing], 16)

            }

            SlideOverCard(isPresented: $isFinishMission) {
                VStack {
                    Text("Special Missions have been completed")
                        .font(.headline)
                        .font(.system(.body, design: .rounded))
                    
                    LottieView(name: "23222-checkmark", loopMode: .playOnce)
                        .frame(width: 100, height: 100, alignment: .center)
                        
                    Text("Thanks for your participation")
                        .font(.headline)
                        .fontWeight(.light)
                    
                    Text("See you next year!")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    
                    Divider()
                        .padding()
                    
                    Button("Continue", action: { isFinishMission.toggle() })
                    .buttonStyle(SOCActionButton())
                }
            }
        }
        .onReceive(self.timer, perform: { time in
            
        })
        .background(Color("BackGround").edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            if specialFirst {
                getSpecialMission10_10()
                specialFirst = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation() {
                    openTask = true
                }
            }
        })
    }
    
    private func scaleValue(mainFrame: CGFloat, minY: CGFloat)-> CGFloat {
        withAnimation(.easeOut) {
            let scale = (minY - mainFrame * 0.8) / mainFrame * 5
            if scale > 1 {
                return 1
            } else {
                return scale
            }
        }
    }
    
    private func percent(complete: Int, count: Int)-> CGFloat {
        let a: CGFloat = CGFloat(complete), b: CGFloat = CGFloat(count)
        
        return CGFloat(a/b)
    }
}

#if DEBUG
/*
struct TaskListView10_10_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView10_10()
    }
}*/
#endif

struct TaskCell_10_10: View {
    
    let index: Int
    @Binding var isFinishMission: Bool
    @AppStorage("HapticActivated") var hapticActivated = true
    @AppStorage("SpecialMissionCounts10_10") var specialMissionCounts = 1
    @AppStorage("SpecialMissionCompletes10_10") var specialMissionCompletes = 0
    @AppStorage("SpecialTaskFinishList10_10") var specialTaskFinishList:[Bool] = [false]
    @State var taskCellVM: Task
    @Binding var textSize: CGSize?
    @State var size: CGSize? = .zero
    @State var openLink = false
    
    let preSize: CGFloat
    let width: CGFloat
    let generrator = UINotificationFeedbackGenerator()
    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                Image(systemName: (specialTaskFinishList[index] ? "checkmark.circle.fill" : "circle"))
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                
                Text(LocalizedStringKey(taskCellVM.title))
                    .font(.system(.body, design: .rounded))
                    .readIntrinsicContentSize(to: $size)
                    .readIntrinsicContentSize(to: $textSize)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .frame(width: (width * 0.9), height: (size!.height + preSize * 1.2))//
            .id(taskCellVM.id)
            .background(Color.white)
            .cornerRadius(15)
            .onTapGesture {
                if hapticActivated {
                    if !self.specialTaskFinishList[index] {
                        generrator.notificationOccurred(.success)
                        withAnimation() {
                            if specialMissionCompletes != specialMissionCounts {
                                specialMissionCompletes+=1
                                if specialMissionCompletes == specialMissionCounts {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        self.isFinishMission = true
                                    }
                                }
                            }
                        }
                    } else {
                        generrator.notificationOccurred(.warning)
                        withAnimation() {
                            if specialMissionCompletes > 0 {
                                specialMissionCompletes-=1
                            }
                        }
                    }
                } else {
                    if !self.specialTaskFinishList[index] {
                        withAnimation() {
                            if specialMissionCompletes != specialMissionCounts {
                                specialMissionCompletes+=1
                                if specialMissionCompletes == specialMissionCounts {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        self.isFinishMission = true
                                    }
                                }
                            }
                        }
                    } else {
                        withAnimation() {
                            if specialMissionCompletes > 0 {
                                specialMissionCompletes-=1
                            }
                        }
                    }
                }
                
                self.specialTaskFinishList[index].toggle()
            }
            
            Spacer()
        }
    }
}
