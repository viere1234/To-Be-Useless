//
//  SettingView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import StoreKit
import BetterSafariView
import UserNotifications

struct SettingView: View {
    
    let currentVersion = "1.0.0"
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openURL) var openURL
    @AppStorage("First") var first = true
    @AppStorage("HapticActivated") var hapticActivated = true
    @AppStorage("MissionStartTime") var missionStartTime = Calendar.current.nextDate(after: Date(), matching: .init(hour: 8), matchingPolicy: .strict)!
    @AppStorage("GetMossionTime") var getMissionTime = 1
    //@AppStorage("DeveloperActivated") var developerActivated = false
    @AppStorage("IsGetDalyMission") var isGetDalyMission = false
    @AppStorage("Version") var version = ""
    @AppStorage("Notification") var isNotification = true
    @State private var developerCounter = 0
    @State private var changeMissionTime = false
    @State private var showAlert = false
    @State private var showNotificationAlert = false
    @State var showInformationCenter = false
    @State var showMissionProposal = false
    @State var showFeedback = false
    @State var pendingCheck = false
    var body: some View {
        ZStack {
            
            Form {
                /*
                Section(header: Text("Developer")) {
                    NavigationLink(destination: DeveloperView(), label: {
                        Label(
                            title: { Text("Developer Setting") },
                            icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
                        )
                    })
                }*/
                
                Section (header: Text("General")) {
                    
                    /*
                    NavigationLink (
                        destination: LoginView(),
                        label: {
                            Label(
                                title: { Text("Account") },
                                icon: { Image(systemName: "person.fill").foregroundColor(.red) }
                            )
                        }) */
                    
                    Toggle(isOn: $isNotification) {
                        Label(
                            title: { Text("Notification") },
                            icon: { Image(systemName: "bell" + (isNotification ? "" : ".slash")).foregroundColor(.red) }
                        )
                    }
                    .onChange(of: isNotification, perform: { _ in
                        if isNotification {
                            let current = UNUserNotificationCenter.current()
                            current.getNotificationSettings(completionHandler: { permission in
                                switch permission.authorizationStatus  {
                                case .authorized:
                                    print("User granted permission for notification")
                                    let userHour = Calendar.current.dateComponents([.hour], from: missionStartTime).hour ?? 0
                                    let userMinute = Calendar.current.dateComponents([.minute], from: missionStartTime).minute ?? 0
                                    DailyNotify(title: "To-Be Useless", body: "Your daily missions are ready!", hour: userHour, minute: userMinute, id: "To-be_Useless_DailyNotify")
                                case .denied:
                                    print("User denied notification permission")
                                    self.showNotificationAlert = true
                                case .notDetermined:
                                    print("Notification permission haven't been asked yet")
                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  { success, error in
                                        if success {
                                            print("authorization granted")
                                            let userHour = Calendar.current.dateComponents([.hour], from: missionStartTime).hour ?? 0
                                            let userMinute = Calendar.current.dateComponents([.minute], from: missionStartTime).minute ?? 0
                                            DailyNotify(title: "To-Be Useless", body: "Your daily missions are ready!", hour: userHour, minute: userMinute, id: "To-be_Useless_DailyNotify")
                                        } else {
                                            print("Error")
                                            isNotification = false
                                        }
                                    }
                                default:
                                    print("Error")
                                }
                            })
                        } else {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["To-be_Useless_DailyNotify"])
                        }
                    })
                    .alert(isPresented: $showNotificationAlert, content: {
                        return Alert(title: Text(""), message: Text("Allow To-Be Useless to send notifation under your device's settings first."),
                                     primaryButton: .default(Text("Settings"), action: {
                                        let url = URL(string: UIApplication.openSettingsURLString)!
                                        pendingCheck = true
                                        UIApplication.shared.open(url)
                                     }),
                                     secondaryButton: .cancel(Text("Cancel"), action: {
                                        self.isNotification = false
                                     })
                        )
                    })
                    .onChange(of: scenePhase) { newPhase in
                        if pendingCheck {
                            if newPhase == .inactive {
                                print("Inactive")
                            } else if newPhase == .active {
                                print("active")
                                if isNotification {
                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  { success, error in
                                        if success {
                                            print("authorization granted")
                                            let userHour = Calendar.current.dateComponents([.hour], from: missionStartTime).hour ?? 0
                                            let userMinute = Calendar.current.dateComponents([.minute], from: missionStartTime).minute ?? 0
                                            DailyNotify(title: "To-Be Useless", body: "Your daily missions are ready!", hour: userHour, minute: userMinute, id: "To-be_Useless_DailyNotify")
                                        } else {
                                            print("Error")
                                            isNotification = false
                                        }
                                    }
                                }
                                
                                pendingCheck = false
                            } else if newPhase == .background {
                                print("Background")
                            }
                        }
                    }
                    
                    
                    ZStack {
                        HStack {
                            Label(
                                title: { Text("Daly Mission Time") },
                                icon: { Image(systemName: "calendar.badge.clock").foregroundColor(.red) }
                            )
                            
                            Spacer()
                        }
                        
                        DatePicker("", selection: $missionStartTime, displayedComponents: .hourAndMinute)
                            .onChange(of: missionStartTime, perform: { value in
                                if isNotification {
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["To-be_Useless_DailyNotify"])
                                    let userHour = Calendar.current.dateComponents([.hour], from: missionStartTime).hour ?? 0
                                    let userMinute = Calendar.current.dateComponents([.minute], from: missionStartTime).minute ?? 0
                                    DailyNotify(title: "To-Be Useless", body: "Your daily missions are ready!", hour: userHour, minute: userMinute, id: "To-be_Useless_DailyNotify")
                                    print("success")
                                }
                            })
                    }
                    
                    Toggle(isOn: $hapticActivated) {
                        Label(
                            title: { Text("Haptic Touch") },
                            icon: { Image(systemName: "hand.tap").foregroundColor(.red) }
                        )
                    }
                }
                
                Section (header: Text("Support")) {
                    Button(action: {
                        self.first.toggle()
                    }, label: {
                        Label(
                            title: { Text("Start Menu").foregroundColor(.black) },
                            icon: { Image(systemName: "filemenu.and.selection").renderingMode(.original)}
                        )
                    })
                    
                    Button(action: {
                        self.showInformationCenter = true
                    }, label: {
                        Label(
                            title: { Text("Information Center").foregroundColor(.black) },
                            icon: { Image(systemName: "info.circle.fill").renderingMode(.original) }
                        )
                    })
                    .safariView(isPresented: $showInformationCenter) {
                        SafariView(
                            url: URL(string: "https://to-be-useless.notion.site/To-be-Useless-Information-center-EN-US-1fa2ee954194411d809d6649d919c623")!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.white)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
                    }
                    
                    Button(action: {
                        self.showMissionProposal = true
                    }, label: {
                        Label(
                            title: { Text("Mission Proposal").foregroundColor(.black) },
                            icon: { Image(systemName: "macwindow.badge.plus").renderingMode(.original) }
                        )
                    })
                    .safariView(isPresented: $showMissionProposal) {
                        SafariView(
                            url: URL(string: "https://forms.gle/6yws6CirUUb8nk919")!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.white)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
                    }
                    
                    Button(action: {
                        self.showFeedback = true
                    }, label: {
                        Label(
                            title: { Text("Sent Feedback").foregroundColor(.black) },
                            icon: { Image(systemName: "paperplane.circle.fill").renderingMode(.original) }
                        )
                    })
                    .safariView(isPresented: $showFeedback) {
                        SafariView(
                            url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfucyu0HHT4mudHFv1xNnr0G0pnOhDTHG6zpx3j-57A6zhPBA/viewform")!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.white)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
                    }
                }
                
                Section (header: Text("To-be Useless")) {
                    Button(action: {
                        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
                        }
                    }, label: {
                        Label(
                            title: { Text("Rate This App").foregroundColor(.black) },
                            icon: { Image(systemName: "star.fill").renderingMode(.original) }
                        )
                    })
                    
                    Button(action: {
                        guard let data = URL(string: "https://apps.apple.com/us/app/to-be-useless/id1577163391") else { return }
                        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                    }, label: {
                        Label(
                            title: { Text("Share With Friends").foregroundColor(.black) },
                            icon: { Image(systemName: "square.and.arrow.up").foregroundColor(.orange) }
                        )
                    })
                    
                    NavigationLink(
                        destination: AboutView(),
                        label: {
                            Label(
                                title: { Text("About Us").foregroundColor(.black) },
                                icon: { Image(systemName: "leaf.fill").renderingMode(.original) }
                            )
                        })
                }
                
                HStack {
                    Spacer()
                    
                    Text("To-be Useless Version \(currentVersion)")
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            
            /*
            VStack {
                Spacer()
                
                Button(action: {
                    self.developerCounter += 1
                    if developerCounter == 20 {
                        developerCounter = 0
                        showAlert.toggle()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "square.and.arrow.up.on.square").foregroundColor(.gray.opacity(0))
                            .padding()
                    }
                })
                .alert(isPresented: $showAlert, content: {
                    return Alert(title: Text("Activate Developer Mode?"),
                                 message: Text("Wrong use will lead to serious errors"),
                                 primaryButton: .default(Text("Yes"), action: {
                                    developerActivated.toggle()
                                 }),
                                 secondaryButton: .destructive(Text("No"))
                    
                    )
                })
            }
            .edgesIgnoringSafeArea(.bottom)*/
        }
        .onAppear(perform: {
            if isNotification {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  { success, error in
                    if success {
                        print("Success")
                    } else {
                        print("Error")
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["To-be_Useless_DailyNotify"])
                        isNotification = false
                    }
                }
            }
        })
    }
}

#if DEBUG
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
#endif

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
