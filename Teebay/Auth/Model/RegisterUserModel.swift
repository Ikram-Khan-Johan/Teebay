//
//  RegisterUserModel.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//


// MARK: - RegisterUserModel
struct RegisterUserModel: Codable {
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

// MARK: - RegisterErrorModel
struct RegisterErrorModel: Codable, Error {
    let email: [String]?

    enum CodingKeys: String, CodingKey {
        case email = "email"
    }
}
