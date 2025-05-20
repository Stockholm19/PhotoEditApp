//
//  AuthValidator.swift
//  PhotoEditAppTests
//
//  Created by Роман Пшеничников on 21.05.2025.
//

import Foundation

struct AuthValidator {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}
