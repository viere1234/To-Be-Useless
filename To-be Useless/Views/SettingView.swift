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
    @State private var changeMissionTime = false
    
    var body: some View {
        Form {
            Section(header: Text("Beta Version Control")) {
                Toggle(isOn: $first) {
                    Label(
                        title: { Text("First?") },
                        icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
                    )
                }
                
                Picker("Refesh Mission Times", selection: $getMissionTime) {
                        ForEach(0 ..< 100) {
                            Text("\($0) Times")
                        }
                    }
            }
            
            Section (header: Text("General")) {
                NavigationLink (
                    destination: LoginView(),
                    label: {
                        Label(
                            title: { Text("Account") },
                            icon: { Image(systemName: "person.fill").foregroundColor(.red) }
                        )
                    })
                
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
