//
//  ContentView.swift
//  ScrabbleGame
//
//  Created by Илья on 08.06.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSplash = true
    @State private var isRegistrationViewPresented = false
    @State private var isLoginViewPresented = false
    @State private var isSellerLoginViewPresented = false
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        NavigationView {
            ZStack {
                if showSplash {
                    SplashScreenView()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.5))
                } else {
                    Color.black.edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer()
                        
                        Image("ScrabbleLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                        
                        Spacer()
                        
                        NavigationLink(destination: LoginView(), isActive: $isLoginViewPresented) {
                            EmptyView()
                        }
                        Button(action: {
                            withAnimation {
                                isLoginViewPresented.toggle()
                            }
                            print("Войти")
                        }) {
                            Text("Войти")
                                .foregroundColor(.white)
                                .frame(width: 300, height: 15)
                                .padding()
                                .background(.gray)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: RegistrationView(), isActive: $isRegistrationViewPresented) {
                            EmptyView()
                        }
                        Button(action: {
                            withAnimation {
                                isRegistrationViewPresented.toggle()
                            }
                        }) {
                            Text("Зарегистрироваться")
                                .foregroundColor(.black)
                                .frame(width: 300, height: 15)
                                .padding()
                                .background(Color(uiColor: .orange))
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.showSplash = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
