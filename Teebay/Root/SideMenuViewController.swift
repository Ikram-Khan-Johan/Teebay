//
//  SideMenuViewController.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//


import UIKit

class SideMenuViewController: UIViewController {

    let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.6 // Half or partial width

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupMenuButtons()
    }

    private func setupMenuButtons() {
        let myProductsButton = createButton(title: "My Products", color: .systemBlue, action: #selector(showMyProducts))
        let allProductsButton = createButton(title: "All Products", color: .systemBlue, action: #selector(showAllProducts))
        let logoutButton = createButton(title: "Logout", color: .systemRed, action: #selector(logout))

        let stack = UIStackView(arrangedSubviews: [myProductsButton, allProductsButton, logoutButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func showMyProducts() {
        print("Tapped My Products")
        // Example: notify parent VC or use delegate/notification
        guard let vc = ProductVC.instantiateSelf() else { return }
        vc.pageType = .myProduct
        goToProductsScreen(vc: vc)
    }

    @objc private func showAllProducts() {
        print("Tapped All Products")
        // Same here – trigger navigation or reload
        guard let vc = ProductVC.instantiateSelf() else { return }
        vc.pageType = .allProduct
        goToProductsScreen(vc: vc)
    }

    @objc private func logout() {
        print("Tapped Logout")
        // For example: clear user defaults and return to login
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
        
        
        goToRootScreen()
    }
    
    func goToRootScreen() {
          guard let authVC = AuthVC.instantiateSelf() else { return }
           let navController = UINavigationController(rootViewController: authVC)

           // Replace the root view controller
           if let sceneDelegate = UIApplication.shared.connectedScenes
               .first?.delegate as? SceneDelegate {
               sceneDelegate.window?.rootViewController = navController
               sceneDelegate.window?.makeKeyAndVisible()
           }
       }

    func goToProductsScreen(vc : UIViewController) {
        let productsVC = vc
        let navController = UINavigationController(rootViewController: productsVC)

        // Replace the root view controller
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
