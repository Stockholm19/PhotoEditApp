//
//  AuthValidatorTests.swift
//  PhotoEditAppTests
//
//  Created by Роман Пшеничников on 21.05.2025.
//

import XCTest
@testable import PhotoEditApp

final class AuthValidatorTests: XCTestCase {

    func testValidEmail() {
        XCTAssertTrue(AuthValidator.isValidEmail("test@example.com"))
    }

    func testInvalidEmail_missingAtSymbol() {
        XCTAssertFalse(AuthValidator.isValidEmail("testexample.com"))
    }

    func testInvalidEmail_missingDot() {
        XCTAssertFalse(AuthValidator.isValidEmail("test@examplecom"))
    }

    func testInvalidEmail_emptyString() {
        XCTAssertFalse(AuthValidator.isValidEmail(""))
    }
}
