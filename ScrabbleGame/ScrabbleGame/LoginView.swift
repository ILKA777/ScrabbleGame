//
//  LoginView.swift
//  ScrabbleGame
//
//  Created by Илья on 08.06.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = BuyerAuthViewModel()
    @State private var isTabBarViewActive = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Войти")
                .font(.largeTitle)
                .padding(.bottom, 20)
                .bold()
                .offset(y: -120)
            
            TextField("Введите логин", text: $viewModel.userName)
                .padding()
                .frame(width: 350, height: 50)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding([.horizontal], 24)
                .offset(y: -120)
                .ignoresSafeArea(.keyboard, edges: .all)
            
            ZStack(alignment: .trailing) {
                if isPasswordVisible {
                    TextField("Введите пароль", text: $viewModel.password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .frame(width: 360, height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                        .padding([.horizontal], 4)
                } else {
                    SecureField("Введите пароль", text: $viewModel.password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .frame(width: 360, height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                        .padding([.horizontal], 4)
                }
                
                // Кнопка "глаз" для отображения/скрытия пароля
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
                .padding(.trailing, 10) // Отступ кнопки от правого края
            }
            .offset(y: -110)
            
            Button(action: {
                viewModel.authUser()
            }) {
                Text("Войти")
                    .foregroundColor(.white)
                    .frame(width: 300, height: 15)
                    .padding()
                    .background(Color(uiColor: .orange))
                    .cornerRadius(10)
            }
            .offset(y: -80)
            
            .onReceive(viewModel.$isAuthSuccessful) { authSuccessful in
                if authSuccessful {
                    // Переход на BuyerTabBarViewModel после успешной регистрации
                    isTabBarViewActive = true
                }
            }
            .background(
//                NavigationLink(
//                    destination: BuyerTabBarViewModel().navigationBarHidden(true),
//                    isActive: $isTabBarViewActive
//                ) {
//                    EmptyView()
//                }
            )
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
