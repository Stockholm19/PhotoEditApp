//
//  AuthErrorCode+Message.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 16.05.2025.
//

import FirebaseAuth

extension AuthErrorCode {
    var friendlyMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "Этот email уже зарегистрирован."
        case .userNotFound:
            return "Пользователь не найден."
        case .wrongPassword, .invalidCredential:
            return "Неверный пароль."
        case .invalidEmail, .invalidRecipientEmail, .invalidSender:
            return "Некорректный email."
        case .networkError:
            return "Проблема с подключением к интернету."
        case .tooManyRequests:
            return "Слишком много попыток. Попробуйте позже."
        default:
            return "Не удалось выполнить операцию. Попробуйте ещё раз."
        }
    }
}
