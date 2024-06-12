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
    @Published var isRoomJoined = false
    @Published var id: UUID?
    @Published var roomCode = ""
    @Published var selectedRoom: Room?

    func getRoom(id: UUID, completion: @escaping (Room?) -> Void) {
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
    
    func joinRoom(id: UUID, code: String?) {
        guard let url = URL(string: "\(Constants.serverURL)/gamersIntoRoom") else {
            print("Invalid URL")
            return
        }
        
        let parameters = [
            "roomId": id.uuidString,
            "enteredPassword": code
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Failed to serialize parameters")
            return
        }
        let currentUser = UserManager.shared.getCurrentUser()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.serverApiKey, forHTTPHeaderField: "ApiKey")
        request.setValue("Bearer \(currentUser.userToken!)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.isRoomJoined = true
                        return
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Ошибка", message: "ошибка добавления в комнату", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                        print("HTTP Response Error: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }

    func validatePassword(for room: Room) -> Bool {
        return room.roomCode == roomCode
    }
}
