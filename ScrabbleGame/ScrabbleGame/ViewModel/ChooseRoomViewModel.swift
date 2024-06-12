//
//  ChooseRoomViewModel.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

class ChooseRoomViewModel: ObservableObject {
    @Published var isJoinRoomAlertPresented = false
    @Published var isPasswordAlertPresented = false
    @Published var id: UUID?
    @Published var roomCode = ""
    @Published var selectedRoom: Room?

    func joinRoom(id: UUID, completion: @escaping (Room?) -> Void) {
        guard let url = URL(string: "\(Constants.serverURL)/gameRooms/\(id)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let currentUser = UserManager.shared.getCurrentUser()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Constants.serverApiKey, forHTTPHeaderField: "ApiKey")
        request.setValue("Bearer \(currentUser.userToken!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let decodedRoom = try JSONDecoder().decode(Room.self, from: data)
                        completion(decodedRoom)
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

    func validatePassword(for room: Room) -> Bool {
        return room.roomCode == roomCode
    }
}
