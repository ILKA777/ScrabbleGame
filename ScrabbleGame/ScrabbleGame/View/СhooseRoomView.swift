//
//  СhooseRoomView.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

struct ChooseRoomView: View {
    @StateObject private var viewModel = ChooseRoomViewModel()
    @State private var inputID = ""
    @State private var isCreateRoomPresented = false
    @State private var isGameRoomPresented = false
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            viewModel.isJoinRoomAlertPresented.toggle()
                        }
                    }) {
                        Text("Войти в комнату")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 15)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: CreateRoomView(), isActive: $isCreateRoomPresented) {
                        EmptyView()
                    }
                    Button(action: {
                        withAnimation {
                            isCreateRoomPresented.toggle()
                        }
                    }) {
                        Text("Создать комнату")
                            .foregroundColor(.black)
                            .frame(width: 300, height: 15)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }

                    Spacer()
                }

                if viewModel.isJoinRoomAlertPresented {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Text("Войти в комнату")
                            .font(.headline)
                        TextField("ID комнаты", text: $inputID)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        HStack {
                            Button(action: {
                                viewModel.isJoinRoomAlertPresented = false
                            }) {
                                Text("Отмена")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            Button(action: {
                                if let uuid = UUID(uuidString: inputID) {
                                    viewModel.joinRoom(id: uuid) { [self] room in
                                        DispatchQueue.main.async { // Убедитесь, что все UI обновления происходят в основном потоке.
                                            if let room = room {
                                                self.viewModel.selectedRoom = room
                                                print("Комната найдена: \(room.id)")
                                                if room.roomCode == nil {
                                                    self.isGameRoomPresented = true
                                                } else {
                                                    self.viewModel.isPasswordAlertPresented = true
                                                }
                                            } else {
                                                print("Комната с ID \(self.inputID) не найдена")
                                            }
                                            self.viewModel.isJoinRoomAlertPresented = false
                                        }
                                    }
                                } else {
                                    print("Неверный формат UUID")
                                    viewModel.isJoinRoomAlertPresented = false
                                }
                            }) {
                                Text("Войти")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
                if viewModel.isPasswordAlertPresented {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Text("Введите пароль")
                            .font(.headline)
                        SecureField("Код комнаты", text: $viewModel.roomCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        HStack {
                            Button(action: {
                                viewModel.isPasswordAlertPresented = false
                            }) {
                                Text("Отмена")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            Button(action: {
                                if let room = viewModel.selectedRoom, viewModel.validatePassword(for: room) {
                                    print("Комната найдена: \(room.id), код верный")
                                    isGameRoomPresented = true
                                } else {
                                    print("Код неверный")
                                }
                                viewModel.isPasswordAlertPresented = false
                            }) {
                                Text("Войти")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }

                NavigationLink(destination: GameRoomView(), isActive: $isGameRoomPresented) {
                    EmptyView()
                }
            }
            .navigationBarHidden(false)
            .navigationBarTitle("Выбор комнаты", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: ProfileView(user: User(username: "UserLogin", userToken: "someToken"))) {
                    Image(systemName: "person.circle")
                        .foregroundColor(.white)
                }
            )
        }
    }
}

struct ChooseRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseRoomView()
            .environmentObject(SessionManager())
    }
}
