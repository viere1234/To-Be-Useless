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


struct TaskListView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State var offset: CGFloat = 0
    @State var presentAddNewItem = false
    @State private var showAlert = false
    @State var showMissionAlertSwicher = 0
    @State var openTask = false
    @State var isFinishMission = false
    @ObservedObject var taskListVM = TaskListViewModel()
    @ScaledMetric(relativeTo: .largeTitle) var navigationBarLargeTitle: CGFloat = 40
    @ScaledMetric(relativeTo: .largeTitle) var navigationBarTitle: CGFloat = 20
    @AppStorage("MissionStartTime") var missionStartTime = Calendar.current.nextDate(after: Date(), matching: .init(hour: 8), matchingPolicy: .strict)!
    @AppStorage("IsGetDalyMission") var isGetDalyMission = false
    @AppStorage("GetMossionTime") var getMissionTime = 1
    @AppStorage("LastDalyMissionYear") var lastDalyMissionYear = 0
    @AppStorage("LastDalyMissionMonth") var lastDalyMissionMonth = 0
    @AppStorage("LastDalyMissionDay") var lastDalyMissionDay = 0
    @AppStorage("HapticActivated") var hapticActivated = true
    @AppStorage("MissionCounts") var missionCounts = 1
    @AppStorage("MissionCompletes") var missionCompletes = 0
    @AppStorage("Version") var version = ""
    @AppStorage("DeveloperActivated") var developerActivated = false
    @AppStorage("First") var first = true
    let generrator = UINotificationFeedbackGenerator()
    
    init() {
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
        
        //let font = UIFont.init(descriptor: descriptor, size: 30)
        UINavigationBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitle
        UINavigationBar.appearance().titleTextAttributes = title
        //UINavigationBar.appearance().largeTitleTextAttributes = [.font : font]
        //UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.rounded]
        //UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.rounded]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack(spacing: 0) {
                    GeometryReader { mainView in
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach (taskListVM.taskCellViewModels) { taskCellVM in
                                    GeometryReader { item in
                                        TaskCell(isFinishMission: $isFinishMission, taskCellVM: taskCellVM, width: mainView.size.width)
                                            .scaleEffect(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY), anchor: .bottom)
                                            .opacity(Double(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY)))
                                            .offset(x: (openTask ? 0 : mainView.size.width))
                                    }
                                    .frame(height: 50)
                                }
                            }
                            .padding(.top, 10)
                        }
                        .zIndex(1)
                        .navigationBarTitle(Text("Daily Missions"), displayMode: .automatic)
                        .onAppear(perform: {
                            withAnimation {
                                
                            }
                        })
                    }
                    
                    HStack {
                        Button(action: {
                            if self.getMissionTime > 0 {
                                if hapticActivated { generrator.notificationOccurred(.warning) }
                                self.showMissionAlertSwicher = 0
                                self.showAlert.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                                    .font(.title2)
                                Text(LocalizedStringKey("Refresh Mission" + (self.getMissionTime > 0 ? "" : " (Used Up)")))
                                    .font(.system(Font.TextStyle.headline, design: .rounded))
                            }
                        }
                        .alert(isPresented: $showAlert, content: {
                            
                            switch showMissionAlertSwicher {
                            /*case 1:
                                return Alert(title: Text("Run out of times"),
                                             message: Text("\(getMissionTime) Times left"))*/
                            case 2:
                                return Alert(title: Text("Daily mission get!!"))
                            default:
                                return Alert(title: Text("Are you sure?"),
                                             message: Text("\(getMissionTime) Times left"),
                                             primaryButton: .default(Text("Yes"), action: {
                                                if hapticActivated { generrator.notificationOccurred(.success) }
                                                self.getMissionTime -= 1
                                                withAnimation() {
                                                    getMission()
                                                }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                    withAnimation() {
                                                        getMission()
                                                    }
                                                }
                                             }),
                                             secondaryButton: .destructive(Text("No")))
                            }
                        })
                        .padding()
                        .accentColor(Color(self.getMissionTime > 0 ? UIColor.orange : UIColor.systemGray)
                                        .opacity(self.getMissionTime > 0 ? 1 : 0.7))
                        
                        Spacer()
                    }
                    
                    ProgressView(percent: percent(complete: (openTask ? missionCompletes : 0), count: missionCounts))
                        .padding([.bottom, .leading, .trailing], 16)
                }
                .onReceive(self.timer, perform: { time in
                    if !isGetDalyMission {
                        let userHour = Calendar.current.dateComponents([.hour], from: missionStartTime).hour ?? 0
                        let userMinute = Calendar.current.dateComponents([.minute], from: missionStartTime).minute ?? 0
                        let currentHour = Calendar.current.dateComponents([.hour], from: Date()).hour ?? 0
                        let currentMinute = Calendar.current.dateComponents([.minute], from: Date()).minute ?? 0
                        
                        if currentHour > userHour || (currentHour == userHour && currentMinute >= userMinute) {
                            isGetDalyMission.toggle()
                            lastDalyMissionYear = Calendar.current.dateComponents([.year], from: Date()).year ?? 0
                            lastDalyMissionMonth = Calendar.current.dateComponents([.month], from: Date()).month ?? 0
                            lastDalyMissionDay = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
                            getMission()
                            getMissionTime = 1
                            showMissionAlertSwicher = 2
                            if hapticActivated { generrator.notificationOccurred(.success) }
                            showAlert.toggle()
                        }
                    } else {
                        let currentYear = Calendar.current.dateComponents([.year], from: Date()).year ?? 0
                        let currentMonth = Calendar.current.dateComponents([.month], from: Date()).month ?? 0
                        let currentDay = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
                        
                        if currentYear > lastDalyMissionYear ||
                            (currentYear == lastDalyMissionYear && currentMonth > lastDalyMissionMonth) ||
                            (currentYear == lastDalyMissionYear && currentMonth == lastDalyMissionMonth && currentDay > lastDalyMissionDay) {
                            self.isGetDalyMission.toggle()
                        }
                    }
                })
                .background(Color("BackGround").edgesIgnoringSafeArea(.all))
                .toolbar {
                  ToolbarItem() {
                      NavigationLink(
                          destination: SettingView(),
                          label: {
                              Image(systemName: "gearshape.fill")
                      })
                  }
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation() {
                            openTask = true
                        }
                    }
                    if version != "0.1.3" { // Warning Disappear After
                        self.first = true
                        self.developerActivated = false
                        version = "0.1.3"
                    }
                })
                
                
                
                SlideOverCard(isPresented: $isFinishMission) {
                    VStack {
                        Text("Daliy Missions have been completed")
                            .font(.headline)
                            .font(.system(.body, design: .rounded))
                        
                        LottieView(name: "23222-checkmark", loopMode: .playOnce)
                            .frame(width: 100, height: 100, alignment: .center)
                            
                            
                        Text("Pick up more Missions tomorrow")
                            .font(.headline)
                            .fontWeight(.light)
                            
                        
                        Text("Let's work hard together !")
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
        }
    }
    func scaleValue(mainFrame: CGFloat, minY: CGFloat)-> CGFloat {
        withAnimation(.easeOut) {
            let scale = (minY - mainFrame*0.55) / mainFrame * 2
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
struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
#endif

struct TaskCell: View {
    
    
    @Binding var isFinishMission: Bool
    @AppStorage("HapticActivated") var hapticActivated = true
    @AppStorage("MissionCompletes") var missionCompletes = 0
    @AppStorage("MissionCounts") var missionCounts = 1
    @ObservedObject var taskCellVM: TaskCellViewModel
    let width: CGFloat
    let generrator = UINotificationFeedbackGenerator()
    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                Image(systemName: taskCellVM.completionStateIconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                
                Text(LocalizedStringKey(taskCellVM.task.title))
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .frame(width: (width * 0.9), height: 50)
            .background(Color.white)
            .cornerRadius(15)
            .onTapGesture {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.taskCellVM.task.completed.toggle()
                }
                if hapticActivated {
                    if !taskCellVM.task.completed {
                        generrator.notificationOccurred(.success)
                        withAnimation() {
                            if missionCompletes != missionCounts {
                                missionCompletes+=1
                                if missionCompletes == missionCounts {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        self.isFinishMission = true
                                    }
                                }
                            }
                        }
                    } else {
                        generrator.notificationOccurred(.warning)
                        withAnimation() {
                            if missionCompletes > 0 {
                                missionCompletes-=1
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

enum InputError: Error {
  case empty
}

extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}

func clearMission() {
    @ObservedObject var taskListVM = TaskListViewModel()
    
    for _ in 0..<taskListVM.taskCellViewModels.count {
        taskListVM.removeTasks(atOffsets: IndexSet([0]))
    }
}

func getMission() {
    @ObservedObject var taskListVM = TaskListViewModel()
    @AppStorage("MissionCounts") var missionCounts = 0
    @AppStorage("MissionCompletes") var missionCompletes = 0
    
    var difficlutChose: [Int] = [],
        highMissionIndex: [Int] = [], highMissionNum = 0,
        mediumMissionIndex: [Int] = [], mediumMissionNum = 0,
        lowMissionIndex: [Int] = [], lowMissionNum = 0, tmp: Int
    
    missionCompletes = 0
    
    clearMission()
    
    while difficlutChose.reduce(0, +) < 6 {
        difficlutChose.append(Int.random(in: 1...3))
    }
    
    missionCounts = difficlutChose.count
    
    for difficluty in difficlutChose {
        switch difficluty {
        case 1: // low difficulty mission
            repeat {
                tmp = Int.random(in: 0...LowMission.count-1)
            } while ( lowMissionIndex.contains(tmp) )
            lowMissionIndex.append(tmp)
            taskListVM.addTask(task: LowMission[lowMissionNum])
            lowMissionNum+=1
        case 2: // medium difficulty mission
            repeat {
                tmp = Int.random(in: 0...MediumMission.count-1)
            } while ( mediumMissionIndex.contains(tmp) )
            mediumMissionIndex.append(tmp)
            taskListVM.addTask(task: MediumMission[mediumMissionNum])
            mediumMissionNum+=1
        default: //3 high
            repeat {
                tmp = Int.random(in: 0...HighMission.count-1)
            } while ( highMissionIndex.contains(tmp) )
            highMissionIndex.append(tmp)
            taskListVM.addTask(task: HighMission[highMissionNum])
            highMissionNum+=1
        }
    }
}

struct ProgressView: View {
    
    var percent: CGFloat
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.black.opacity(0.04))
                .frame(height: 8)
            
            Capsule()
                .fill(Color("ProgressBar"))
                .frame(width: self.callPercent(), height: 8)
        }
    }
    
    private func callPercent()->CGFloat {
        let width = UIScreen.main.bounds.width - 32
        
        return width * self.percent
    }
}
