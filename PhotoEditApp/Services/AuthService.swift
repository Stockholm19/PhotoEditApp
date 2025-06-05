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

    func createUser(email: String, password: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    let code = AuthErrorCode(rawValue: (error as NSError).code)
                    continuation.resume(throwing: code ?? AuthErrorCode.internalError)
                } else if let user = result?.user {
                    continuation.resume(returning: user)
                }
            }
        }
    }

    func signIn(email: String, password: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    let code = AuthErrorCode(rawValue: (error as NSError).code)
                    continuation.resume(throwing: code ?? AuthErrorCode.internalError)
                } else if let user = result?.user {
                    continuation.resume(returning: user)
                }
            }
        }
    }
}
