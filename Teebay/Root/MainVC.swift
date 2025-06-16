//
//  MainVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 14/6/25.
//

import UIKit
import Alamofire
class MainVC: UIViewController, StoryboardInstantiable {
    static var storyboardName: StoryboardName {
        return .main
    }
    
    private lazy var viewModel = AuthVM(self)
    @IBOutlet weak var mobeBUtton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       let params = [ "email": "johan3@teebay.com",
                   "first_name": "Ikram",
                   "last_name": "Johan",
                   "address": "Dhaka, BD",
                   "firebase_console_manager_token": "DJKHJAHKDJHAKJHDJKHAJKHDJKAHDJK",
                   "password": "123456"
        ]
//        viewModel.registerUser(params: params)
        
//        viewModel.register(params: params)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           guard let vc = AuthVC.instantiateSelf() else {
                return
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
   
    }
    
    
    @IBAction func onTappedMoveButton(_ sender: Any) {
        
        guard let vc = ProductVC.instantiateSelf() else {
            print("No VC found")
            return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
   
    
}

extension MainVC : AuthVMDelegate {
    func dataLoaded() {
        print("Data load success")
    }
    
    func showSpinner() {
        print("")
    }
    
    func hideSpinner() {
        print("")
    }
    
    func failedWithError(code: Int, message: String) {
        print(message)
    }
    
    
}
