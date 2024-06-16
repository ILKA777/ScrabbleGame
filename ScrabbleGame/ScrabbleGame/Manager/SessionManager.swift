//
//  SessionManager.swift
//  ScrabbleGame
//
//  Created by Илья on 08.06.2024.
//

import SwiftUI
class SessionManager: ObservableObject {
    @Published var isLoggedIn = UserManager.shared.isLoggedIn()
    static let shared = SessionManager()
    
    func login() {
        // Здесь происходит логин
        isLoggedIn = true
    }
    
    func logout() {
        // Очистка данных или любые другие операции при выходе
        isLoggedIn = false
        
        // Находим окно приложения
        if let window = UIApplication.shared.windows.first {
            // Создаем новый экземпляр представления для входа в систему
            let rootView = ContentView()
                .environmentObject(SessionManager())
            
            // Обертываем rootView в UINavigationController
            let navigationController = UINavigationController(rootViewController: UIHostingController(rootView: rootView))
            
            // Устанавливаем navigationController как корневой контроллер окна
            window.rootViewController = navigationController
            
            // Опционально: анимируем переход
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
