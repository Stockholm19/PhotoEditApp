//
//  AuthViewModel.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 06.05.2025.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var errorMessage: String?

    init() {
        self.user = Auth.auth().currentUser
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
        errorMessage = nil

        AuthService.shared.createUser(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    completion(.success(()))
                case .failure(let code):
                    self.errorMessage = code.friendlyMessage
                    completion(.failure(code))
                }
            }
        }
    }

    func signIn(email: String, password: String) {
        errorMessage = nil

        AuthService.shared.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let code):
                    self.errorMessage = code.friendlyMessage
                }
            }
        }
    }
}
