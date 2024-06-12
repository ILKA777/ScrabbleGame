//
//  Room.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import Foundation

struct Room: Identifiable, Decodable {
    var id: UUID
    var roomCode: String?
    var adminNickname: String
    var currentNumberOfChips: Int
    var gameStatus: String
}
