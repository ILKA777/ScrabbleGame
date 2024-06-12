//
//  CustomCellView.swift
//  ScrabbleGame
//
//  Created by Илья on 12.06.2024.
//

import SwiftUI

struct CustomCellView: View {
    var username: String
    var onRemove: () -> Void
    var onAccept: () -> Void

    var body: some View {
        HStack {
            Text(username)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
            
            Button(action: onAccept) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

