//
//  SettingView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
struct SettingView: View {
    
    @AppStorage("First") var first = true
    @AppStorage("HapticActivated") var hapticActivated = true
    @AppStorage("MissionStartTime") var missionStartTime = Calendar.current.nextDate(after: Date(), matching: .init(hour: 8), matchingPolicy: .strict)!
    @AppStorage("GetMossionTime") var getMissionTime = 1
    @AppStorage("DeveloperActivated") var developerActivated = false
    @AppStorage("IsGetDalyMission") var isGetDalyMission = false
    @State private var developerCounter = 0
    @State private var changeMissionTime = false
    @State private var showAlert = false    
    var body: some View {
        Form {
            if developerActivated {
                Section(header: Text("Developer")) {
                    NavigationLink(destination: DeveloperView(), label: {
                        Label(
                            title: { Text("Developer Setting") },
                            icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
                        )
                    })
                }
            }
            
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
                
                ZStack {
                    HStack {
                        Label(
                            title: { Text("Daly Mission Time") },
                            icon: { Image(systemName: "calendar.badge.clock").foregroundColor(.red) }
                        )
                        
                        Spacer()
                    }
                    
                    DatePicker("", selection: $missionStartTime, displayedComponents: .hourAndMinute)
                }
                
                Toggle(isOn: $hapticActivated) {
                    Label(
                        title: { Text("Core Haptics") },
                        icon: { Image(systemName: "hand.tap").foregroundColor(.red) }
                    )
                }
            }
            
            Section (header: Text("Support")) {
                NavigationLink(destination: SupportView()) {
                    Label(
                        title: { Text("Support") },
                        icon: { Image(systemName: "person.fill.questionmark").foregroundColor(.red) }
                    )
                }
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Label(
                        title: { Text("Sent Feedback").foregroundColor(.black) },
                        icon: { Image(systemName: "paperplane").foregroundColor(.red) }
                    )
                })
            }
            
            Section (header: Text("Useless to do")) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Label(
                        title: { Text("Rate This App").foregroundColor(.black) },
                        icon: { Image(systemName: "star.fill").foregroundColor(.red) }
                    )
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Label(
                        title: { Text("Share With Friends").foregroundColor(.black) },
                        icon: { Image(systemName: "square.and.arrow.up.on.square").foregroundColor(.red) }
                    )
                })
                
                NavigationLink(
                    destination: AboutView(),
                    label: {
                        Label(
                            title: { Text("About Us").foregroundColor(.black) },
                            icon: { Image(systemName: "crown.fill").foregroundColor(.red) }
                        )
                    })
            }
            
            Button(action: {
                self.developerCounter += 1
                if developerCounter == 10 {
                    developerCounter = 0
                    showAlert.toggle()
                }
            }, label: {
                HStack {
                    Spacer()
                    
                    Text("To-be Useless Version Beta 0.1.1")
                        .foregroundColor(.gray)
                    
                    Spacer()
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
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}


extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

