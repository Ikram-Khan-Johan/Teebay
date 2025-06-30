//
//  LoginVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 16/6/25.
//

import UIKit
import JGProgressHUD

import LocalAuthentication
import Security

class LoginVC: UIViewController, StoryboardInstantiable {
    static var storyboardName: StoryboardName
    {
        return .auth
    }
    
    private lazy var hud = JGProgressHUD(style: .dark)
    private lazy var viewModel = LoginVM(self)
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var logiinButton: UIButton!
    
    @IBOutlet weak var ligonWithFaceidButton: UIButton!
    
    var userData : [String :String] = [
        "email": "",
        "password": ""
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
//        deleteCredentialsFromKeychain()
        // Do any additional setup after loading the view.
    }
    func deleteCredentialsFromKeychain() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "user_credentials",
            kSecAttrService as String: "DON.teebay"
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    
    func setupUI() {
        emailTextfield.delegate = self
        passwordTextField.delegate = self
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordTextField.placeholder = "Password"
        emailTextfield.placeholder = "Email"
        
        if areCredentialsStored() {
            ligonWithFaceidButton.isHidden = false
        } else {
            ligonWithFaceidButton.isHidden = true
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func onTappedLoginButton(_ sender: Any) {
        
        if emailTextfield.text?.isEmpty == true &&  passwordTextField.text?.isEmpty == true {
            self.view.makeToast("Please Enter Email & Password", duration: 2.0, position: .bottom)
            return
        }
        if emailTextfield.text?.isEmpty == true {
            self.view.makeToast("Please Enter Email", duration: 2.0, position: .bottom)
            return
        }
        if passwordTextField.text?.isEmpty == true {
            self.view.makeToast("Please Enter Email", duration: 2.0, position: .bottom)
            return
        }
        viewModel.login(params: userData)
    }
    
    @IBAction func loginWithFaceIDTapped(_ sender: UIButton) {
        retrieveCredentialsWithFaceID { email, password in
            if let email = email, let password = password {
                
                self.userData["email"] = email
                self.userData["password"] = password
                self.viewModel.login(params: self.userData)
                
            } else {
                self.view.makeToast("Unable to retrieve credentials.", duration: 2.0, position: .bottom)
            }
        }
    }
    
    
   

    @IBAction func onTappedSingupButton(_ sender: Any) {
        guard let vc =  AuthVC.instantiateSelf() else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func areCredentialsStored() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "user_credentials",
            kSecAttrService as String: "DON.teebay",
            kSecReturnData as String: false, // Don't return data
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationUI // Don't show Face ID prompt
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)

        return status == errSecSuccess
    }
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextfield {
            if textField.text?.isEmpty == true {
                emailTextfield.placeholder = "Email"
            }
            userData["email"] = textField.text
        }
        if textField == passwordTextField {
            if textField.text?.isEmpty == true {
                passwordTextField.placeholder = "Password"
            }
            userData["password"] = textField.text
        }
    }
}


// MARK: - AuthVC
extension LoginVC: LoginVMDelegate {
    
    func failedWithError(code: Int, message: String) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.hud.isVisible {
                self.hud.show(in: self.view)
            }
            
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.textLabel.text = message
            self.hud.dismiss(afterDelay: 2)
        }
    }
    
    func showSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hud.show(in: self.view)
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hud.dismiss()
        }
    }
    
    func dataLoaded() {
        //Do additional stuff after data fetched
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UserDefaults.standard.isLoggedIn = true
          
            var result = saveCredentialsToKeychain(email: emailTextfield.text ?? "", password: passwordTextField.text ?? "")
            self.goToProductsScreen()
            
        }
    }
    
    func goToProductsScreen() {
       guard let productsVC = ProductVC.instantiateSelf() else { return }
        let navController = UINavigationController(rootViewController: productsVC)

        // Replace the root view controller
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
}


extension LoginVC {
    
    func retrieveCredentialsWithFaceID(completion: @escaping (String?, String?) -> Void) {
        let context = LAContext()
        context.localizedReason = "Authenticate to login with Face ID"

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "user_credentials",
            kSecAttrService as String: "DON.teebay",
            kSecReturnData as String: true,
            kSecUseOperationPrompt as String: "Login using Face ID"
        ]

        var dataTypeRef: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess,
           let data = dataTypeRef as? Data,
           let credentialString = String(data: data, encoding: .utf8) {
            let components = credentialString.split(separator: ":", maxSplits: 1)
            if components.count == 2 {
                let email = String(components[0])
                let password = String(components[1])
                completion(email, password)
                return
            }
        }
        completion(nil, nil)
    }

    func saveCredentialsToKeychain(email: String, password: String) -> Bool {
        let credentialsData = "\(email):\(password)".data(using: .utf8)!

        let access = SecAccessControlCreateWithFlags(nil,
                                                     kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                     .biometryCurrentSet,
                                                     nil)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "user_credentials",
            kSecAttrService as String: "DON.teebay",
            kSecValueData as String: credentialsData,
            kSecAttrAccessControl as String: access,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationUI
        ]

        // Delete if already exists
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}
