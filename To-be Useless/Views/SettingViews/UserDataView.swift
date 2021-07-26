//
//  UserDataView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/25.
//

import SwiftUI

struct UserDataView: View {
    
    @AppStorage("MissionStartTime") var missionStartTime = Calendar.current.nextDate(after: Date(), matching: .init(hour: 8), matchingPolicy: .strict)!
    @AppStorage("IsGetDalyMission") var isGetDalyMission = false
    @AppStorage("GetMossionTime") var getMissionTime = 1
    @AppStorage("LastDalyMissionYear") var lastDalyMissionYear = 0
    @AppStorage("LastDalyMissionMonth") var lastDalyMissionMonth = 0
    @AppStorage("LastDalyMissionDay") var lastDalyMissionDay = 0
    
    var body: some View {
        VStack {
            Text(missionStartTime.rawValue)
            Toggle(isOn: $isGetDalyMission, label: T)
        }
    }
}

struct UserDataView_Previews: PreviewProvider {
    static var previews: some View {
        UserDataView()
    }
}
