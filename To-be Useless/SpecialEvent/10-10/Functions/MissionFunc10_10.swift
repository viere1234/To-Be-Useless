//
//  MissionFunc.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/8/25.
//

import Foundation
import SwiftUI

func getSpecialMission10_10() {
    @AppStorage("SpecialMissionCounts10_10") var specialMissionCounts = 1
    @AppStorage("SpecialMissionCompletes10_10") var specialMissionCompletes = 0
    @AppStorage("SpecialTaskDifficultyList10_10") var specialTaskDifficultyList:[Int] = []
    @AppStorage("SpecialTaskIndexList10_10") var specialTaskIndexList:[Int] = []
    @AppStorage("SpecialTaskFinishList10_10") var specialTaskFinishList:[Bool] = []
    
    let missionRep = MissionRepsitory10_10()
    
    var
        highMissionIndex: [Int] = [],
        mediumMissionIndex: [Int] = [],
        lowMissionIndex: [Int] = [],
        tmpIndex: Int
    
    specialMissionCompletes = 0
    
    specialTaskDifficultyList.removeAll()
    specialTaskIndexList.removeAll()
    specialTaskFinishList.removeAll()
    
    while specialTaskDifficultyList.reduce(0, +) < 6 {
        specialTaskDifficultyList.append(Int.random(in: 1...3))
    }
    
    print(specialTaskDifficultyList.count)
    
    specialMissionCounts = specialTaskDifficultyList.count
    
    for difficluty in specialTaskDifficultyList {
        switch difficluty {
        case 1: // low difficulty mission
            repeat {
                tmpIndex = Int.random(in: 0...missionRep.LowMission.count-1)
            } while ( lowMissionIndex.contains(tmpIndex))
            lowMissionIndex.append(tmpIndex)
        case 2: // medium difficulty mission
            repeat {
                tmpIndex = Int.random(in: 0...missionRep.MediumMission.count-1)
            } while ( mediumMissionIndex.contains(tmpIndex))
            mediumMissionIndex.append(tmpIndex)
        default: //case 3: high diffculty mission
            repeat {
                tmpIndex = Int.random(in: 0...missionRep.HighMission.count-1)
            } while ( highMissionIndex.contains(tmpIndex))
            highMissionIndex.append(tmpIndex)
        }
        
        specialTaskIndexList.append(tmpIndex)
        specialTaskFinishList.append(false)
    }
}
