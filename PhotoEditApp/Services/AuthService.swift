//
//  AuthService.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 16.05.2025.
//

import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    private init() {}

    func createUser(email: String, password: String,
                    completion: @escaping (Result<User, AuthErrorCode>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let code = AuthErrorCode(rawValue: (error as NSError).code)
                completion(.failure(code ?? .internalError))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }

    func signIn(email: String, password: String,
                completion: @escaping (Result<User, AuthErrorCode>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let code = AuthErrorCode(rawValue: (error as NSError).code)
                completion(.failure(code ?? .internalError))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
}
