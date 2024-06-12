//
//  ProfileViewModel.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoggedIn: Bool = true
    @Published var showDeleteConfirmation: Bool = false

    init(user: User) {
        self.user = user
    }
    
    func logout() {
        // Handle logout logic here
        print("User logged out")
        isLoggedIn = false
    }

    func deleteAccount() {
        // Handle delete account logic here
        print("User account deleted")
        isLoggedIn = false
    }
}
