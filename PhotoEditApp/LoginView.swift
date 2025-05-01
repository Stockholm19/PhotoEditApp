//
//  LoginView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 01.05.2025.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20.0) {
            Text("Вход")
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
            
            Button("Войти") {
                print("Email: \(email), Password: \(password)")
                // ниже потом сделаю логику по через Firebase
            }
            .padding()
            .frame (maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            VStack(spacing: 10) {
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
