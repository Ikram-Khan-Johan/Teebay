//
//  Storyboarded.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 14/6/25.
//

import UIKit

protocol StoryboardInstantiable {
    static var storyboardName: StoryboardName { get }
    static func instantiate() -> UIViewController
    static func instantiateSelf() -> Self?
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static func instantiate() -> UIViewController {
        return UIStoryboard(name: storyboardName.rawValue, bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: Self.self))
    }
    
    static func instantiateSelf() -> Self? {
        return UIStoryboard(name: storyboardName.rawValue, bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self
    }
}

enum StoryboardName: String {
    case main = "Main"
    case product = "Product"
    case auth = "Auth"

}
