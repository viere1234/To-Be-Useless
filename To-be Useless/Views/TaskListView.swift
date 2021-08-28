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
    //Current Version
    let currentVersion = "1.0.0"
    @AppStorage("Version") var version = "1.0.0"
    //end
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State var offset: CGFloat = 0
    @State var presentAddNewItem = false
    @State private var showAlert = false
    @State var showMissionAlertSwicher = 0
    @State var openTask = false
    @State var isFinishMission = false
    @State var missionSize: [CGSize] = [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    @State var textSize: Dictionary<String, CGSize> = [:]
    @State var size: CGSize = .zero
    @State var reload = false
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
    @AppStorage("DeveloperActivated") var developerActivated = false
    @AppStorage("First") var first = true
    @ObservedObject var model = Model()
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
        
        /*
        for taskCell in taskListVM.taskCellViewModels {
            textSize[taskCell.task] = CGFloat(10)
        }
         */
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack(spacing: 0) {
                    GeometryReader { mainView in
                        ScrollView {
                            VStack(spacing: 15) {
                                if !reload {
                                    ForEach (taskListVM.taskCellViewModels) { taskCellVM in
                                        //textSize[taskCellVM.task] = .zero
                                        GeometryReader { item in
                                            TaskCell(isFinishMission: $isFinishMission,
                                                     taskCellVM: taskCellVM,
                                                     width: mainView.size.width)
                                                .scaleEffect(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY), anchor: .bottom)
                                                .opacity(Double(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY)))
                                                .offset(x: (openTask ? 0 : mainView.size.width))
                                                .readIntrinsicContentSize(to: $textSize[taskCellVM.task.id])
                                                .id(taskCellVM.task.id)
                                        }
                                        .frame(height: (textSize[taskCellVM.task.id]?.height ?? CGFloat(0)) + 25)
                                    }
                                }
                            }
                            .padding(.top, 10)
                        }
                        .zIndex(1)
                        .navigationBarTitle(Text("Daily Missions"), displayMode: .automatic)
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
                                return Alert(title: Text("Daily Mission Refreshed."))
                            default:
                                return Alert(title: Text("Are you sure?"),
                                             message: Text("\(getMissionTime) Times left"),
                                             primaryButton: .default(Text("Yes"), action: {
                                                if hapticActivated { generrator.notificationOccurred(.success) }
                                                self.getMissionTime -= 1
                                                
                                                DispatchQueue.main.async {
                                                    withAnimation() {
                                                        openTask = false
                                                    }
                                                    
                                                    getMission()
                                                    textSize = [:]
                                                    
                                                    
                                                    
                                                    withAnimation() {
                                                        openTask = true
                                                    }
                                                }
                                             }),
                                             secondaryButton: .cancel())
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
                    if UIApplication.shared.applicationIconBadgeNumber != 0 {
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
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
                            
                            getMissionTime = 1
                            showMissionAlertSwicher = 2
                            if hapticActivated { generrator.notificationOccurred(.success) }
                            showAlert.toggle()
                            
                            DispatchQueue.main.async {
                                withAnimation() {
                                    openTask = false
                                }
                                
                                getMission()
                                textSize = [:]
                                
                                withAnimation() {
                                    openTask = true
                                }
                            }
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
                    if version != currentVersion { // Warning Disappear After
                        getMission()
                        textSize = [:]
                        self.developerActivated = false
                        version = currentVersion
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
    private func scaleValue(mainFrame: CGFloat, minY: CGFloat)-> CGFloat {
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
    @State var size: CGSize? = .zero
    
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
                    .readIntrinsicContentSize(to: $size)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .frame(width: (width * 0.9), height: (size!.height + 25))
            .id(taskCellVM.task.id)
            .background(Color.white)
            .cornerRadius(15)
            .onTapGesture {
                DispatchQueue.main.async {
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

struct IntrinsicContentSizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func readIntrinsicContentSize(to size: Binding<CGSize?>) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(
                key: IntrinsicContentSizePreferenceKey.self,
                value: proxy.size
            )
        })
        .onPreferenceChange(IntrinsicContentSizePreferenceKey.self) { value in
            DispatchQueue.main.async {
                size.wrappedValue = value//$0
            }
        }
    }
}

class Model: ObservableObject {
    func reloadView() {
        objectWillChange.send()
    }
}

//50
//25
