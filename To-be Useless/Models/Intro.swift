//
//  Intro.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/8/7.
//

import Foundation

struct Intro: Identifiable {
    var id = UUID().uuidString
    var animation: Bool
    var image: String
    var title: String
    var description: String
}

var intros: [Intro] = [
    Intro(animation: true, image: "41068-man-filling-a-list",
          title: "Hi, there! Welcome to\n\"To-be Useless\"",
          description: "Here is a place where you can get encouraged by completing some small \"Missions\""),
    Intro(animation: false, image: "IMG_6068",
          title: "This is Dart\nA frog-shaped slime from the Amazon forest",
          description: "If you don't tell him,\nit will give you 3-5 missions at 8 AM every day"),
    Intro(animation: true, image: "3091-process-complete",
          title: "If possible,\nfinish the daily missions!",
          description: "What?\nYou said you don't like the missions today?"),
    Intro(animation: true, image: "53194-earth-globe-rotating-with-seamless-loop-animation",
          title: "Didn't see any mission you like?",
          description: "Then go to \"Mission proposal\" in \"Setting\" and tell us what you want to add in future updates!"),
    Intro(animation: true, image: "18045-teamwork-is-all-we-need",
          title: "That's all!",
          description: "For more information,\nplease visit \"Information Center\" in \"Settings\"")
]
