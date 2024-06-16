//
//  TableViewModel.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

class TableViewModel: ObservableObject {
    @Published var users: [String] = ["User 1", "User 2", "User 3"]
    
    func removeUser(at index: Int) {
        users.remove(at: index)
    }
    
    func acceptUser(at index: Int) {
        // Handle accept user logic
        print("\(users[index]) accepted")
    }
}
