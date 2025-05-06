//
//  ResetPasswordView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 01.05.2025.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @State private var email = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20.0) {
            header
            description
            emailField
            errorMessageView
            sendButton
        }
        .padding()
    }
}

// MARK: - Subviews

private extension ResetPasswordView {
    var header: some View {
        Text("Сброс пароля")
            .font(.largeTitle)
            .bold()
    }

    var description: some View {
        Text("Будет форма для сброса пароля")
            .foregroundColor(.gray)
    }

    var emailField: some View {
        TextField("Email", text: $email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .textContentType(.emailAddress)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }

    var errorMessageView: some View {
        Group {
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }

    var sendButton: some View {
        Button("Отправить") {
            if email.isEmpty {
                errorMessage = "Введите email"
            } else if !email.contains("@") {
                errorMessage = "Некорректный email"
            } else {
                errorMessage = ""
                print("Отправка письма на: \(email)")
                // sendPasswordReset через Firebase
            }
            // Ниже потом добавлю логику для отправки email для сброса пароля
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

#Preview {
    ResetPasswordView()
}
