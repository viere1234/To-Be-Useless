//
//  LoginView.swift
//  Student Platform
//
//  Created by 張智堯 on 2021/5/20.
//

import SwiftUI

struct LoginView: View {
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var done = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(systemName: "link.circle.fill")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Text("Welcome back !")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .padding(.bottom, 30)
                        .foregroundColor(.black)
                    
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        
                        TextField("Email", text: $emailAddress)
                            .foregroundColor(.black)
                    }
                    .frame(height: 45)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(7)
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                    
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        
                        SecureField("Password", text: $password)
                            .foregroundColor(.black)
                    }
                    .frame(height: 45)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(7)
                    .padding(.horizontal, 20)
                    
                    HStack {
                        VStack {
                            Divider()
                        }
                        
                        Text("or")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                        
                        VStack {
                            Divider()
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical)
                    
                    Button(action: {}, label: {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "applelogo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 19, height: 19)
                            
                            
                            
                            Text("Sign in with Apple")
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                            
                            Spacer()
                        }
                        .frame(width: 300, height: 44, alignment: .center)
                        .background(Color.black)
                        .cornerRadius(7)
                    })
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Spacer()
                            
                            Image("googlelogo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 19, height: 19)
                            
                            
                            
                            Text("Sign in with Google")
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                            
                            Spacer()
                        }
                        .frame(width: 300, height: 44, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(7)
                        .shadow(radius: 4)
                    })
                    
                    Spacer()
                    
                    VStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Continue")
                                .foregroundColor(.white)
                                .font(.system(size: 20, design: .rounded))
                                .frame(width: 375, height: 44, alignment: .center)
                                .background(Color.green)
                                .cornerRadius(7)
                        })
                        
                        
                        Text("By signing in you accept our")
                            .padding(.top)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.7))
                        
                        HStack {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Terms of use")
                                    .underline()
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.9))
                            })
                            
                            Text("and")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.7))
                            
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Privacy Policy")
                                    .underline()
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.9))
                            })
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
