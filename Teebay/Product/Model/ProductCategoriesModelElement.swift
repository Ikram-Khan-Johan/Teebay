//
//  ProductCategoriesModelElement.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//


import Foundation

// MARK: - ProductCategoriesModelElement
struct ProductCategoriesModelElement: Codable {
    let value: String?
    let label: String?

    enum CodingKeys: String, CodingKey {
        case value = "value"
        case label = "label"
    }
}

typealias ProductCategoriesModel = [ProductCategoriesModelElement]