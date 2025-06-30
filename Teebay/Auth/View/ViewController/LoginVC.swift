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
   

    
    func setupUI() {
        emailTextfield.delegate = self
        passwordTextField.delegate = self
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordTextField.placeholder = "Password"
        emailTextfield.placeholder = "Email"
        
        if FaceIdLoginManager.shared.areCredentialsStored() {
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
        FaceIdLoginManager.shared.retrieveCredentialsWithFaceID { email, password in
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
          
            var result = FaceIdLoginManager.shared.saveCredentialsToKeychain(email: emailTextfield.text ?? "", password: passwordTextField.text ?? "")
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

