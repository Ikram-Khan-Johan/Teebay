//
//  AuthVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//

import UIKit
import Toast_Swift
import JGProgressHUD

class AuthVC: UIViewController, StoryboardInstantiable {
    static var storyboardName: StoryboardName
    {
        return .auth
    }

    var userData : [String :String] = [
        "email": "",
        "first_name": "",
        "last_name": "",
        "address": "",
        "firebase_console_manager_token": "string",
        "password": ""
    ]
    
    private lazy var hud = JGProgressHUD(style: .dark)
    private lazy var viewModel = AuthVM(self)
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var addressErrorLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    var isEmailValid: Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupUI() {
        firstNameErrorLabel.isHidden = true
        lastNameErrorLabel.isHidden = true
        addressErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
//        phoneNumberTF.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
        
        firstNameTF.placeholder = "First Name"
        lastNameTF.placeholder = "Last Name"
        addressTF.placeholder = "Address"
        emailTF.placeholder = "Email"
        phoneNumberTF.placeholder = "Phone Number"
        passwordTF.placeholder = "Password"
        confirmPasswordTF.placeholder = "Confirm Password"
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        addressTF.delegate = self
        emailTF.delegate = self
        phoneNumberTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
    }
    
    @IBAction func onTappedRegisterButton(_ sender: Any) {
        
        let allNonEmpty = userData.values.allSatisfy { !($0.isEmpty) }
        
        if !allNonEmpty {
            self.view.makeToast("Please fillup the required fields", duration: 2.0, position: .bottom)
//            print("Please fillup the required fields")
            return
        }
        
        viewModel.register(params: userData)
    }
    
    @IBAction func onTappedSigninButton(_ sender: Any) {
        guard let vc = LoginVC.instantiateSelf() else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension AuthVC : UITextFieldDelegate {
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
    
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if textField == emailTF {
           if  textField.text?.isValidWith(regexType: .email) == true {
   //            emailVerify.isHidden = false
               emailErrorLabel.isHidden = true
               isEmailValid = true
           } else {
               isEmailValid = false
   //            emailVerify.isHidden = true
               emailErrorLabel.isHidden = false
               emailErrorLabel.text = "Invalid email format"
           }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == firstNameTF {
            
        }
        if textField == lastNameTF {
            
        }
        if textField == addressTF {
          
        }
        if textField == emailTF {
        }
        
        if textField == phoneNumberTF {
            
        }
        if textField == passwordTF {
            
        }
        
        if textField == confirmPasswordTF {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == firstNameTF {
           
            if textField.text?.isEmpty == true  {
                firstNameErrorLabel.text = "First name is required"
                firstNameTF.placeholder = "First name"
                firstNameErrorLabel.isHidden = false
            } else {
                userData["first_name"] = textField.text
                firstNameErrorLabel.isHidden = true
            }
        }
        if textField == lastNameTF {
           
            if textField.text?.isEmpty == true  {
                lastNameErrorLabel.text = "Last name is required"
                lastNameTF.placeholder = "Last name"
                lastNameErrorLabel.isHidden = false
            } else {
                userData["last_name"] = textField.text
                lastNameErrorLabel.isHidden = true
            }
        }
        if textField == addressTF {
            userData["address"] = textField.text
            if textField.text?.isEmpty == true  {
                addressErrorLabel.text = "Address name is required"
                addressTF.placeholder = "Address"
                addressErrorLabel.isHidden = false
            } else {
                addressErrorLabel.isHidden = true
            }
        }
        if textField == emailTF {
            
            if textField.text?.isEmpty == true  {
                emailErrorLabel.text = "Email name is required"
                emailTF.placeholder = "Email"
                emailErrorLabel.isHidden = false
            } else {
                if isEmailValid {
                    userData["email"] = textField.text
                    emailErrorLabel.isHidden = true
                } else {
                    emailErrorLabel.isHidden = false
                }
               
            }
        }
        
        if textField == passwordTF {
            if textField.text?.isEmpty == true  {
                passwordTF.placeholder = "Password"
                passwordErrorLabel.text = "Password is required"
                passwordErrorLabel.isHidden = false
            } else {
                passwordErrorLabel.isHidden = true
            }
        }
        if textField == confirmPasswordTF {
           
            if textField.text?.isEmpty == true  {
                confirmPasswordErrorLabel.text = "Please confirm password"
              
                confirmPasswordErrorLabel.isHidden = false
            } else {
                if confirmPasswordTF.text != passwordTF.text {
                    confirmPasswordErrorLabel.isHidden = false
                    confirmPasswordErrorLabel.text = "Password does not match"
                } else {
                    userData["password"] = textField.text
                    confirmPasswordErrorLabel.isHidden = true
                }
            }
        }
    }
}

    // MARK: - AuthVC
extension AuthVC: AuthVMDelegate {
    
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
    }
    
}
