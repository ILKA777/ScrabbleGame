//
//  ChooseRoomViewModel.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

class ChooseRoomViewModel: ObservableObject {
    @Published var rooms: [Room] = [
        Room(id: "123", password: "pass123"),
        Room(id: "456")  // Mock room without password
    ]
    @Published var isJoinRoomAlertPresented = false
    @Published var isPasswordAlertPresented = false
    @Published var roomID = ""
    @Published var password = ""
    @Published var selectedRoom: Room?

    func joinRoom(id: String) -> Room? {
        return rooms.first(where: { $0.id == id })
    }

    func validatePassword(for room: Room) -> Bool {
        return room.password == password
    }
}
