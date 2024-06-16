//
//  GameRoomSettingsView.swift
//  ScrabbleGame
//
//  Created by Карим on 16.06.2024.
//

import SwiftUI

struct GameRoomSettingsView: View {
    @ObservedObject var viewModel: RoomViewModel
    let roomId: UUID
    @State private var isMainViewPresented = false
    @State private var roomStatus: String = "Not Started"
    @State private var userRole: String = "user"
    @State private var navigateFromRoom = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Настройки комнаты")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Spacer()
                
                if userRole == "admin" {
                    Button(action: {
                        viewModel.changeRoomStatus(id: roomId, status: roomStatus == "Running" ? "Pause" : "Running")
                    }) {
                        Text(roomStatus == "Running" ? "Пауза" : "Начать")
                            .padding()
                            .background(roomStatus == "Running" ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)

                    Button(action: {
                        viewModel.deleteRoom(roomId: roomId)
                        navigateFromRoom = true
                    }) {
                        Text("Удалить комнату")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                Spacer()
            }
            .onAppear {
                viewModel.getRoomRole(roomId: roomId) { role in
                    self.userRole = role
                }
                viewModel.getRoom(id: roomId) { room in
                    if room != nil {
                        self.roomStatus = room!.gameStatus
                    }
                }
            }
            .fullScreenCover(isPresented: $navigateFromRoom) {
                ChooseRoomView()
            }
        }
    }
}
