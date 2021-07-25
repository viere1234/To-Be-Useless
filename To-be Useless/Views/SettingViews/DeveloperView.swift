//
//  DeveloperView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/25.
//

import SwiftUI

struct DeveloperView: View {
    
    @AppStorage("First") var first = true
    @AppStorage("HapticActivated") var hapticActivated = true
    @AppStorage("DeveloperActivated") var developerActivated = false
    @AppStorage("MissionStartTime") var missionStartTime = Calendar.current.nextDate(after: Date(), matching: .init(hour: 8), matchingPolicy: .strict)!
    @AppStorage("IsGetDalyMission") var isGetDalyMission = false
    @AppStorage("GetMossionTime") var getMissionTime = 1
    @AppStorage("LastDalyMissionYear") var lastDalyMissionYear = 0
    @AppStorage("LastDalyMissionMonth") var lastDalyMissionMonth = 0
    @AppStorage("LastDalyMissionDay") var lastDalyMissionDay = 0
    
    var body: some View {
        Form {
            Toggle(isOn: $first) {
                Label(
                    title: { Text("First?") },
                    icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
                )
            }
            
            ZStack {
                HStack {
                    Label(
                        title: { Text("Refesh Mission Times") },
                        icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
                    )
                    
                    Spacer()
                }
                
                Picker("", selection: $getMissionTime) {
                    ForEach(0 ..< 100) {
                        Text("\($0) Times")
                    }
                }
                
            }
            
            Button(action: { clearMission() }, label: {
                Label(
                    title: { Text("Clear Mission").foregroundColor(.black) },
                    icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
                )
            })
            
            Toggle(isOn: $isGetDalyMission) {
                Label(
                    title: { Text("Daily?") },
                    icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
                )
            }
            
            Section(header: Text("Daily Mission Date (DD/MM/YYYY)"), content: {
                TextField("", value: $lastDalyMissionDay, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                TextField("", value: $lastDalyMissionMonth, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                TextField("", value: $lastDalyMissionYear, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            })
            
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
    }
}
