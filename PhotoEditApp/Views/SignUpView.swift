//
//  SignUpView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 01.05.2025.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var errorMessage: String = ""
    @State private var isShowingSuccess: Bool = false
    @State private var emailAlreadyExists: Bool = false
    
    var body: some View {
        VStack(spacing: 20.0) {
            header
            emailField
            passwordField
            confirmPasswordField
            errorMessageView
            signUpButton
        }
        .padding()
        .alert("Регистрация прошла успешно", isPresented: $isShowingSuccess) {
            Button("OK") {
                dismiss()
            }
        }
        
    }
    
    // MARK: - Subviews

    private var header: some View {
        Text("Новый аккаунт")
            .font(.largeTitle)
            .bold()
    }

    private var emailField: some View {
        TextField("Email", text: $email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .textContentType(.emailAddress)
            .padding()
            .background(emailAlreadyExists ? Color.red.opacity(0.2) : Color(.secondarySystemBackground))
            .cornerRadius(10)
    }

    private var passwordField: some View {
        SecureField("Пароль", text: $password)
            .textContentType(.password)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }

    private var confirmPasswordField: some View {
        SecureField("Подтвердите пароль", text: $confirmPassword)
            .textContentType(.password)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }

    private var errorMessageView: some View {
        Group {
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }

    private var signUpButton: some View {
        Button("Готово") {
            // сбрасываем возможное предыдущее состояние
            emailAlreadyExists = false

            if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                errorMessage = "Все поля должны быть заполнены"
            } else if password != confirmPassword {
                errorMessage = "Пароли не совпадают"
            } else {
                errorMessage = ""
                authViewModel.signUp(email: email, password: password) { result in
                    switch result {
                    case .success:
                        isShowingSuccess = true
                    case .failure(let error):
                        if error == .emailAlreadyInUse {
                            emailAlreadyExists = true
                            errorMessage = "Такой email уже зарегистрирован"
                        } else {
                            errorMessage = error.friendlyMessage
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
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
