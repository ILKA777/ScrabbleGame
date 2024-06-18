//
//  GameRoomView.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

struct GameRoomView: View {
    @ObservedObject var viewModel: RoomViewModel
    let roomId: UUID
    @State private var isMainViewPresented = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Игровая комната")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Spacer()
                Text("Ваше количество фишек: \(viewModel.currentNumberOfChips)")
                    .foregroundColor(.white)
            }
            .navigationBarTitle("Игровая комната", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                print("leave \(roomId)")
                viewModel.leaveRoom(id: roomId)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Выйти из комнаты")
                    .foregroundColor(.red)
            })
            .navigationBarItems(trailing:
                NavigationLink(destination: GameRoomSettingsView(viewModel: viewModel, roomId: roomId), isActive: $isMainViewPresented) {
                Button(action: {
                    isMainViewPresented = true
                }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.white)
                }
            }
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}