//
//  RegistrationView.swift
//  ScrabbleGame
//
//  Created by Илья on 08.06.2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var isOrganizationInfoViewActive = false
    @State private var isTabBarViewActive = false
    @State private var isPasswordVisible = false
    @State private var isSecondPasswordVisible = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Регистрация")
                .font(.largeTitle)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                .offset(x: 20)
                .offset(y: -120)
            
            TextField("Введите имя пользователя", text: $viewModel.userName)
                .padding()
                .frame(width: 350, height: 50)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding([.horizontal], 24)
                .offset(y: -120)
            
            TextField("Введите почту", text: $viewModel.email)
                .padding()
                .frame(width: 350, height: 50)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding([.horizontal], 24)
                .offset(y: -120)
            
            // Поле ввода пароля
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
            
            // Поле ввода подтверждения пароля
            ZStack(alignment: .trailing) {
                if isSecondPasswordVisible {
                    TextField("Повторите пароль", text: $viewModel.matchingPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .frame(width: 360, height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                        .padding([.horizontal], 4)
                } else {
                    SecureField("Повторите пароль", text: $viewModel.matchingPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .frame(width: 360, height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                        .padding([.horizontal], 4)
                }
                
                // Кнопка "глаз" для отображения/скрытия подтверждения пароля
                Button(action: {
                    isSecondPasswordVisible.toggle()
                }) {
                    Image(systemName: isSecondPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
                .padding(.trailing, 10) // Отступ кнопки от правого края
            }
            .offset(y: -100)
            
            Button(action: {
                viewModel.registerUser()
            }) {
                Text("Зарегистрироваться")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: 360)
                    .background(Color(uiColor: .orange))
                    .cornerRadius(10)
                    .frame(height: 50)
                    .offset(y: 30)
            }
            .offset(y: -100)
            
            .onReceive(viewModel.$isRegistrationSuccessful) { registrationSuccessful in
                if registrationSuccessful {
                    // Переход на BuyerTabBarViewModel после успешной регистрации
                    isTabBarViewActive = true
                }
            }
            .background(
                EmptyView()
            )
            
            .padding()
        }
    }
}

#Preview {
    RegistrationView()
}

