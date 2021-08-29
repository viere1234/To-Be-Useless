//
//  MissionFunc.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/8/25.
//

import Foundation
import SwiftUI

func getMission() {
    @ObservedObject var taskListVM = TaskListViewModel()
    @AppStorage("MissionCounts") var missionCounts = 0
    @AppStorage("MissionCompletes") var missionCompletes = 0
    
    let missionRep = MissionRepsitory()
    
    var difficlutChose: [Int] = [],
        highMissionIndex: [Task] = [],
        mediumMissionIndex: [Task] = [],
        lowMissionIndex: [Task] = [],
        currentMissions: [Task] = [], tmpTask: Task
    
    missionCompletes = 0
    
    for taskCellVM in taskListVM.taskCellViewModels {
        currentMissions.append(taskCellVM.task)
    }
    
    clearMission()
    
    while difficlutChose.reduce(0, +) < 6 {
        difficlutChose.append(Int.random(in: 1...3))
    }
    
    missionCounts = difficlutChose.count
    
    for difficluty in difficlutChose {
        switch difficluty {
        case 1: // low difficulty mission
            repeat {
                tmpTask = missionRep.LowMission.randomElement()!//Int.random(in: 0...LowMission.count-1)
            } while ( lowMissionIndex.contains(tmpTask) || currentMissions.contains(tmpTask))
            lowMissionIndex.append(tmpTask)
        case 2: // medium difficulty mission
            repeat {
                tmpTask = missionRep.MediumMission.randomElement()!//Int.random(in: 0...MediumMission.count-1)
            } while ( mediumMissionIndex.contains(tmpTask) || currentMissions.contains(tmpTask))
            mediumMissionIndex.append(tmpTask)
        default: //case 3: high diffculty mission
            repeat {
                tmpTask = missionRep.HighMission.randomElement()!//Int.random(in: 0...HighMission.count-1)
            } while ( highMissionIndex.contains(tmpTask) || currentMissions.contains(tmpTask))
            highMissionIndex.append(tmpTask)
        }
        
        taskListVM.addTask(task: tmpTask)
    }
}

func clearMission() {
    @ObservedObject var taskListVM = TaskListViewModel()
    
    for _ in 0..<taskListVM.taskCellViewModels.count {
        taskListVM.removeTasks(atOffsets: IndexSet([0]))
    }
}
