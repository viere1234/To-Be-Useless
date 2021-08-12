//
//  Intro.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/8/7.
//

import Foundation

struct Intro: Identifiable {
    var id = UUID().uuidString
    var order: Int
}

var intros: [Intro] = [
    Intro(order: 1),
    Intro(order: 2),
    Intro(order: 3)
]
