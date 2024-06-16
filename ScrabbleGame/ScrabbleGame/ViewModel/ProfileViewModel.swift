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
    
    func getCurrentUserId(completion: @escaping (UUID?) -> Void) {
        struct UserIdResponse: Decodable {
            let id: UUID
        }
        
        let currentUser = UserManager.shared.getCurrentUser()
        guard let url = URL(string: "\(Constants.serverURL)/user/me") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Constants.serverApiKey, forHTTPHeaderField: "ApiKey")
        request.setValue("Bearer \(currentUser.userToken!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let decodedUUID = try JSONDecoder().decode(UserIdResponse.self, from: data)
                        completion(decodedUUID.id)
                    } catch {
                        print("JSON Decoding Error: \(error)")
                    }
                } else {
                    completion(nil)
                    print("HTTP Error: \(response.debugDescription)")
                    return
                }
            }
        }.resume()
    }
    
    func logout() {
        UserManager.shared.logout()
        isLoggedIn = false
    }

    func deleteAccount() {
        getCurrentUserId { [weak self] userId in
            guard let self = self, let userId = userId else {
                print("Failed to get user ID")
                return
            }
            
            guard let url = URL(string: "\(Constants.serverURL)/user/\(userId.uuidString)") else {
                print("Invalid URL")
                return
            }
            let currentUser = UserManager.shared.getCurrentUser()
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue(Constants.serverApiKey, forHTTPHeaderField: "ApiKey")
            request.setValue("Bearer \(currentUser.userToken!)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        
                        self.logout()
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                        print("Account deleted successfully")
                        UserManager.shared.logout()
                        self.isLoggedIn = false
                    } else {
                        print("HTTP Error: \(response.debugDescription)")
                        return
                    }
                }
            }.resume()
        }
    }
}
