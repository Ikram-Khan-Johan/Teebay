//
//  LoginResponseModel.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 17/6/25.
//


// MARK: - LoginResponseModel
struct LoginResponseModel: Codable {
    let message: String?
    let user: LoginResponseUser?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case user = "user"
    }
}

// MARK: - LoginResponseUser
struct LoginResponseUser: Codable {
    let id: Int?
    let email: String?
    let firstName: String?
    let lastName: String?
    let address: String?
    let firebaseConsoleManagerToken: String?
    let password: String?
    let dateJoined: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case address = "address"
        case firebaseConsoleManagerToken = "firebase_console_manager_token"
        case password = "password"
        case dateJoined = "date_joined"
    }
}

// MARK: - LoginErrorModel
struct LoginErrorModel: Codable, Error {
    let error: String?

    enum CodingKeys: String, CodingKey {
        case error = "error"
    }
}
