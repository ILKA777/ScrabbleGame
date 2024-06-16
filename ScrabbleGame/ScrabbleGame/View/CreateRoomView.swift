//
//  CreateRoomView.swift
//  ScrabbleGame
//
//  Created by Карим on 16.06.2024.
//

import Foundation
import SwiftUI


struct CreateRoomView: View {
    @StateObject private var viewModel = RoomViewModel()
    @State private var navigateToGameRoom = false
    @State private var roomId: String = ""

    var body: some View {
            Toggle(isOn: $viewModel.isPrivate) {
                Text("Сделать приватной")
            }
            .padding(.horizontal)

            if viewModel.isPrivate {
                TextField("Придумайте код", text: Binding(
                    get: { viewModel.roomCode },
                    set: { viewModel.roomCode = $0.isEmpty ? "" : $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            Button(action: {
                viewModel.createRoom { createdRoom in
                    if createdRoom != nil {
                        roomId = createdRoom!.id.uuidString
                        navigateToGameRoom = true
                    }
                }
            }) {
                Text("Создать комнату")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top)

            NavigationLink(
                destination: GameRoomView(viewModel: viewModel, roomId: UUID(uuidString: roomId) ?? UUID()),
                isActive: $navigateToGameRoom) {
                    EmptyView()
                }
    }
}


struct CreateRoomView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateRoomView()
        }
    }
}
