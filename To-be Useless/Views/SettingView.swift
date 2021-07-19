//
//  SettingView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI

struct SettingView: View {
    
    @AppStorage("First") var first = true
    
    var body: some View {
        Form {
            Section(header: Text("Beta Version Control")) {
                Toggle(isOn: $first) {
                    Label(
                        title: { Text("First?") },
                        icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
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
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
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
