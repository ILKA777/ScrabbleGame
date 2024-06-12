//
//  MainView.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = TableViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                List {
                    ForEach(Array(viewModel.users.enumerated()), id: \.element) { index, user in
                        CustomCellView(
                            username: user,
                            onRemove: {
                                viewModel.removeUser(at: index)
                            },
                            onAccept: {
                                viewModel.acceptUser(at: index)
                            }
                        )
                        .listRowBackground(Color.black)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.black)
            }
            .navigationBarTitle("Game Room", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    // Handle pause action
                    print("Pause button tapped")
                }) {
                    Image(systemName: "pause")
                        .foregroundColor(.red)
                }
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
