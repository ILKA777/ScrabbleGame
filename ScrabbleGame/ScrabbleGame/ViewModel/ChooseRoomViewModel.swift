//
//  ChooseRoomViewModel.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

class ChooseRoomViewModel: ObservableObject {
    @Published var rooms: [Room] = [
        Room(id: UUID(uuidString: "a071ed7c-8e7e-4853-acef-5775197706d8") ?? UUID(), roomCode: "pass123"),
        Room(id: UUID(uuidString: "31779a3f-58a8-47bb-aae9-4c5eb68adefa") ?? UUID())  // Mock room without password
    ]
    @Published var isJoinRoomAlertPresented = false
    @Published var isPasswordAlertPresented = false
    @Published var id: UUID?
    @Published var roomCode = ""
    @Published var selectedRoom: Room?

    func joinRoom(id: UUID) -> Room? {
        return rooms.first(where: { $0.id == id })
    }

    func validatePassword(for room: Room) -> Bool {
        return room.roomCode == roomCode
    }
}
