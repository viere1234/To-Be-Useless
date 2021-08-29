//
//  DataView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/27.
//

import SwiftUI
import Disk

struct DataView: View {
    
    let missionRep = MissionRepsitory()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Low")
                .font(.title)
            List(missionRep.LowMission) { mission in
                Text(mission.title)
            }
            Text("Medium")
                .font(.title)
            List(missionRep.MediumMission) { mission in
                Text(mission.title)
            }
            Text("High")
                .font(.title)
            List(missionRep.HighMission) { mission in
                Text(mission.title)
            }
        }
        .padding()
    }
}

#if DEBUG
struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
#endif
