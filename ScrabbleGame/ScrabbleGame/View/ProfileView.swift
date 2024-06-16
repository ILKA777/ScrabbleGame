//
//  ProfileView.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var isLoggedOut = false
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    if let username = viewModel.user.username {
                        Label(username, systemImage: "person.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(10)
                            .padding(.top, 50)
                    } else {
                        Text("No username available")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(10)
                            .padding(.top, 50)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showDeleteConfirmation = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                    .alert(isPresented: $viewModel.showDeleteConfirmation) {
                        Alert(
                            title: Text("Delete Account"),
                            message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteAccount()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("Profile", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    viewModel.logout()
                }) {
                    Image(systemName: "door.right.hand.open")
                        .foregroundColor(.white)
                })
                .onReceive(viewModel.$isLoggedIn) { isLoggedIn in
                    if !isLoggedIn {
                        isLoggedOut = true
                    }
                }
                .fullScreenCover(isPresented: $isLoggedOut) {
                    ContentView()
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User(username: "UserLogin", userToken: "someToken"))
    }
}
