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
    
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20.0) {
            Text("Новый аккаунт")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Пароль", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Подтвердите пароль", text: $confirmPassword)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Button("Готово") {
                if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                    errorMessage = "Все поля должны быть заполнены"
                } else if password != confirmPassword {
                    errorMessage = "Пароли не совпадают"
                } else {
                    errorMessage = ""
                    
                    // здесь потом сделаю логику с Firebase
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") {
                        print("Preview: Назад нажата")
                    }
                }
            }
    }
}
