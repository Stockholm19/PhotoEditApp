//
//  ProfileView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 06.05.2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    let userEmail: String
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            header
            emailText
            signOutButton
        }
        .padding()
    }
}

// MARK: - Subviews

private extension ProfileView {
    var header: some View {
        Text("👤 Добро пожаловать")
            .font(.largeTitle)
    }

    var emailText: some View {
        Text("Email: \(userEmail)")
    }

    var signOutButton: some View {
        Button("Выйти") {
            do {
                try Auth.auth().signOut()
                authViewModel.user = nil
            } catch {
                print("Ошибка выхода: \(error.localizedDescription)")
            }
        }
        .padding()
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

#Preview {
    ProfileView(userEmail: "preview@example.com")
        .environmentObject(AuthViewModel())
}
