//
//  ProductVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 14/6/25.
//

import UIKit
import JGProgressHUD

class ProductVC: UIViewController, StoryboardInstantiable {
    static var storyboardName: StoryboardName {
        return .product
    }
    private lazy var hud: JGProgressHUD = JGProgressHUD(style: .dark)
    private lazy var viewModel = ProductVM(self)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getProducts()
        // Do any additional setup after loading the view.
    }
    

  
}


// MARK: - AuthVC
extension ProductVC: ProductVMDelegate {
    
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
