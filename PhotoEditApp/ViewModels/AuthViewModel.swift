//
//  AuthViewModel.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 06.05.2025.
//

import Foundation
@preconcurrency import FirebaseAuth
import Combine
import GoogleSignIn
import UIKit

@MainActor
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

    func signInWithGoogle() async {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }

        do {
            let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            guard let idToken = userAuth.user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: userAuth.user.accessToken.tokenString)

            let result = try await Auth.auth().signIn(with: credential)
            DispatchQueue.main.async { [weak self] in
                self?.user = result.user
                self?.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Не удалось войти через Google"
            }
            print("Google Sign-In error:", error)
        }
    }
}
