//
//  LoginView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 01.05.2025.
//

import SwiftUI
import UIKit
import GoogleSignInSwift

/// Простая геометрическая анимация «shake»
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * shakesPerUnit),
                y: 0
            )
        )
    }
}

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var wrongAttempts: Int = 0
    
    var body: some View {
        VStack(spacing: 20.0) {
            header
            emailField
            passwordField

            errorMessageView
            
            signInButton
            
            linksSection
        }
        .onChange(of: authViewModel.errorMessage) {
            guard let message = authViewModel.errorMessage, !message.isEmpty else { return }
            errorMessage = "Неправильный логин или пароль."
            withAnimation { wrongAttempts += 1 }
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
        .padding()
    }
}

// MARK: - Subviews

private extension LoginView {
    var header: some View {
        Text("Вход")
            .font(.largeTitle)
            .bold()
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

    var passwordField: some View {
        SecureField("Пароль", text: $password)
            .textContentType(.password)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .modifier(Shake(animatableData: CGFloat(wrongAttempts)))
    }

    var errorMessageView: some View {
        Group {
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }

    var signInButton: some View {
        Button("Войти") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            if email.trimmingCharacters(in: .whitespaces).isEmpty ||
                password.trimmingCharacters(in: .whitespaces).isEmpty {
                errorMessage = "Пожалуйста, заполните все поля."
                withAnimation { wrongAttempts += 1 }
            } else if !email.contains("@") {
                errorMessage = "Некорректный email."
                withAnimation { wrongAttempts += 1 }
            } else if password.count < 6 {
                errorMessage = "Пароль должен содержать минимум 6 символов."
                withAnimation { wrongAttempts += 1 }
            } else {
                errorMessage = ""
                authViewModel.signIn(email: email, password: password)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    var linksSection: some View {
        VStack(spacing: 10) {
            GoogleSignInButton {
                Task {
                    await authViewModel.signInWithGoogle()
                }
            }
            .frame(height: 50)
            
            NavigationLink("Забыли пароль?") {
                ResetPasswordView()
            }
            .font(.footnote)
            .foregroundColor(.gray)

            HStack {
                NavigationLink("Зарегистрироваться") {
                    SignUpView()
                }
            }
            .font(.footnote)
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AuthViewModel())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") {
                        print("Preview: Назад нажата")
                    }
                }
            }
    }
}
