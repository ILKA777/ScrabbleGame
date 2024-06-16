//
//  ChooseRoomViewModel.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

class RoomViewModel: ObservableObject {
    @Published var isJoinRoomAlertPresented = false
    @Published var isPasswordAlertPresented = false
    @Published var isRoomJoined = false
    @Published var id: UUID?
    @Published var roomCode = ""
    @Published var selectedRoom: Room?
    @Published var isPrivate = false

    func createRoom(completion: @escaping (Room?) -> Void) {
        let currentUser = UserManager.shared.getCurrentUser()
        
        guard let url = URL(string: "\(Constants.serverURL)/gameRooms") else {
            print("Invalid URL")
            return
        }
        
        var parameters: [String: Any] = [
            "adminNickname": currentUser.username,
            "gameStatus": "Not Started",
            "currentNumberOfChips": 0
        ]
        if roomCode != "" {
            parameters["roomCode"] = roomCode
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Failed to serialize parameters")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.serverApiKey, forHTTPHeaderField: "ApiKey")
        request.setValue("Bearer \(currentUser.userToken!)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
           DispatchQueue.main.async {
               guard let data = data, error == nil else {
                   print("Error: \(error?.localizedDescription ?? "Unknown error")")
                   completion(nil)
                   return
               }
               
               if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                   let decodedRoom = try? JSONDecoder().decode(Room.self, from: data)
                   completion(decodedRoom)
                   
                   if let room = decodedRoom {
                       self?.joinRoom(id: room.id, code: self?.roomCode)
                   }
               } else {
                   print("HTTP Error: \(response.debugDescription)")
                   if let errorString = String(data: data, encoding: .utf8) {
                       print("Error response text: \(errorString)")
                   } else {
                       print("Unable to convert data to string")
                   }
                   completion(nil)
               }

           }
       }.resume()
    }

    func changeRoomStatus(id: UUID, status: String) {
        guard let url = URL(string: "\(Constants.serverURL)/gameRooms/\(id)/status") else {
            print("Invalid URL")
            return
        }
        
        let parameters: [String: Any] = ["status": status]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Failed to serialize parameters")
            return
        }
        
        let currentUser = UserManager.shared.getCurrentUser()
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.serverApiKey, forHTTPHeaderField: "ApiKey")
        request.setValue("Bearer \(currentUser.userToken!)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("Room status changed to \(status)")
                } else {
                    print("HTTP Error: \(response.debugDescription)")
                }
            }
        }.resume()
    }

    
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
    
    func leaveRoom(id: UUID) {
        let currentUser = UserManager.shared.getCurrentUser()
        ProfileViewModel(user: currentUser).getCurrentUserId { [weak self] userId in
            guard let userId = userId else {
                print("Не удалось получить идентификатор пользователя")
                return
            }

            self?.actuallyLeaveRoom(userId: userId, roomId: id)
        }
    }
 
    private func actuallyLeaveRoom(userId: UUID, roomId: UUID) {
        let currentUser = UserManager.shared.getCurrentUser()
        guard let url = URL(string: "\(Constants.serverURL)/gamersIntoRoom/deleteGamer/\(userId)/withRoom/\(roomId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.serverApiKey, forHTTPHeaderField: "ApiKey")
        request.setValue("Bearer \(currentUser.userToken!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 204 {
                        self.isRoomJoined = false
                        return
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Ошибка", message: "ошибка выхода из комнаты", preferredStyle: .alert)
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

    func getRoomRole(roomId: UUID, completion: @escaping (String) -> Void) {
        getRoom(id: roomId) { room in
            let currentUser = UserManager.shared.getCurrentUser()
            if (currentUser.username == room!.adminNickname) {
                completion("admin")
            } else {
                completion("participant")
            }
        }
    }
    
    func deleteRoom(roomId: UUID) {
        let currentUser = UserManager.shared.getCurrentUser()
        guard let url = URL(string: "\(Constants.serverURL)/gameRooms/\(roomId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.serverApiKey, forHTTPHeaderField: "ApiKey")
        request.setValue("Bearer \(currentUser.userToken!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 204 {
                        self.isRoomJoined = false
                        return
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Ошибка", message: "ошибка удаления комнаты", preferredStyle: .alert)
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
