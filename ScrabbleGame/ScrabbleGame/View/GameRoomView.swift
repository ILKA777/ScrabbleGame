//
//  GameRoomView.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

struct GameRoomView: View {
    @State private var isMainViewPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("Игровая комната")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                }
                .navigationBarTitle("Игровая комната", displayMode: .inline)
                .navigationBarItems(trailing:
                    NavigationLink(destination: MainView(), isActive: $isMainViewPresented) {
                        Button(action: {
                            // Trigger the transition to MainView
                            isMainViewPresented = true
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .foregroundColor(.white)
                        }
                    }
                )
            }
        }
    }
}

struct GameRoomView_Previews: PreviewProvider {
    static var previews: some View {
        GameRoomView()
    }
}
