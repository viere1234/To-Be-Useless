//
//  MainView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import UIKit
import UserNotifications

struct TaskListView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var presentAddNewItem = false
    @State private var showAlert = false
    @State var showMissionAlertSwicher = 0
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
    let generrator = UINotificationFeedbackGenerator()
    
    init() {
        let design = UIFontDescriptor.SystemDesign.rounded
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(design)!
        let largeTitle = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.init(descriptor: descriptor, size: navigationBarLargeTitle)
        ]
        let title = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.init(descriptor: descriptor, size: navigationBarTitle)
        ]
        
        //let font = UIFont.init(descriptor: descriptor, size: 30)
        UINavigationBar.appearance().tintColor = UIColor.red
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitle
        UINavigationBar.appearance().titleTextAttributes = title
        //UINavigationBar.appearance().largeTitleTextAttributes = [.font : font]
        //UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.rounded]
        //UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.rounded]
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach (taskListVM.taskCellViewModels) { taskCellVM in
                        TaskCell(taskCellVM: taskCellVM)
                    }
                    /*
                    .onDelete { indexSet in
                        self.taskListVM.removeTasks(atOffsets: indexSet)
                    }
                
                    if presentAddNewItem {
                        TaskCell(taskCellVM: TaskCellViewModel.newTask()) { result in
                            if case .success(let task) = result {
                                self.taskListVM.addTask(task: task)
                            }
                            self.presentAddNewItem.toggle()
                        }
                    } */
                }
                .listStyle(InsetListStyle())
                
                Button(action: {
                    if self.getMissionTime <= 0 {
                        if hapticActivated { generrator.notificationOccurred(.error) }
                        self.showMissionAlertSwicher = 1
                        self.showAlert.toggle()
                    } else {
                        if hapticActivated { generrator.notificationOccurred(.warning) }
                        self.showMissionAlertSwicher = 0
                        self.showAlert.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                            .font(.title2)
                        Text("Refresh Mission")
                            .font(.system(Font.TextStyle.headline, design: .rounded))
                    }
                }
                .alert(isPresented: $showAlert, content: {
                    
                    switch showMissionAlertSwicher {
                    case 1:
                        return Alert(title: Text("Run out of times"),
                                     message: Text("\(getMissionTime) Times left"))
                    case 2:
                        return Alert(title: Text("Daily mission get!!"))
                    default:
                        return Alert(title: Text("Are you sure?"),
                                     message: Text("\(getMissionTime) Times left"),
                                     primaryButton: .default(Text("Yes"), action: {
                                        if hapticActivated { generrator.notificationOccurred(.success) }
                                        self.getMissionTime -= 1
                                        withAnimation{
                                            getMission()
                                        }
                                        //self.presentAddNewItem.toggle()
                                     }),
                                     secondaryButton: .destructive(Text("No")))
                    }
                })
                .padding()
                .accentColor(Color(UIColor.systemRed))
            }
            .navigationBarTitle(Text("To-Be Useless"))
            .toolbar {
              ToolbarItem() {
                  NavigationLink(
                      destination: SettingView(),
                      label: {
                          Image(systemName: "gearshape.fill")
                  })
              }
            }
        }
        .onAppear(perform: {
            if isGetDalyMission {
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
            }
        })
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}

struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel
    @ObservedObject var taskListVM = TaskListViewModel()
    var onCommit: (Result<Task, InputError>) -> Void = { _ in }
    var body: some View {
        HStack {
            Image(systemName: taskCellVM.completionStateIconName)
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    self.taskCellVM.task.completed.toggle()
                }
            
            Text(taskCellVM.task.title)
                .font(.system(.body, design: .rounded))
            
            /*
            TextField("Enter your useless tasks", text: $taskCellVM.task.title, onCommit: {
                if !self.taskCellVM.task.title.isEmpty {
                    self.onCommit(.success(self.taskCellVM.task))
                } else {
                    self.onCommit(.failure(.empty))
                }
            }).id(taskCellVM.id)*/
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
    
    var difficlutChose: [Int] = [],
        highMissionIndex: [Int] = [], highMissionNum = 0,
        mediumMissionIndex: [Int] = [], mediumMissionNum = 0,
        lowMissionIndex: [Int] = [], lowMissionNum = 0, tmp: Int
    
    clearMission()
    
    while difficlutChose.reduce(0, +) < 6 { difficlutChose.append(Int.random(in: 1...3)) }
    
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
