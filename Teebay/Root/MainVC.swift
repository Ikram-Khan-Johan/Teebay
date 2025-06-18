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
    private var sideMenuVC: SideMenuViewController?
        private var isMenuShown = false

    private lazy var viewModel = AuthVM(self)
    @IBOutlet weak var mobeBUtton: UIButton!
    
    private var dimmingView: UIView?

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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           guard let vc = AuthVC.instantiateSelf() else {
                return
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
        view.backgroundColor = .white

                let menuButton = UIButton(type: .system)
                menuButton.setTitle("☰", for: .normal)
                menuButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
                menuButton.frame = CGRect(x: 20, y: 60, width: 40, height: 40)
                view.addSubview(menuButton)
    }
    @objc func toggleMenu() {
           if isMenuShown {
               hideSideMenu()
           } else {
               showSideMenu()
           }
       }

    private func showSideMenu() {
        guard sideMenuVC == nil else { return }

        let menuVC = SideMenuViewController()
        addChild(menuVC)

        // Add dimming view
        let dimming = UIView(frame: view.bounds)
        dimming.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimming.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideSideMenu))
        dimming.addGestureRecognizer(tap)
        view.addSubview(dimming)
        self.dimmingView = dimming

        view.addSubview(menuVC.view)
        let width = view.bounds.width * 0.6
        menuVC.view.frame = CGRect(x: -width, y: 0, width: width, height: view.bounds.height)
        menuVC.didMove(toParent: self)

        UIView.animate(withDuration: 0.3) {
            dimming.alpha = 1
            menuVC.view.frame.origin.x = 0
        }

        sideMenuVC = menuVC
        isMenuShown = true
    }

    @objc private func hideSideMenu() {
        guard let menuVC = sideMenuVC else { return }

        UIView.animate(withDuration: 0.3, animations: {
            menuVC.view.frame.origin.x = -menuVC.view.bounds.width
            self.dimmingView?.alpha = 0
        }) { _ in
            menuVC.willMove(toParent: nil)
            menuVC.view.removeFromSuperview()
            menuVC.removeFromParent()
            self.sideMenuVC = nil
            self.dimmingView?.removeFromSuperview()
            self.dimmingView = nil
            self.isMenuShown = false
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
