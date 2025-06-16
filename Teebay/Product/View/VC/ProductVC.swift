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
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getProducts()
       // tableView.delegate = self
        tableView.register(ProductTVC.nib, forCellReuseIdentifier: ProductTVC.identifier)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTappedAddButton(_ sender: Any) {
        
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
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
}

extension ProductVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTVC.identifier, for: indexPath) as! ProductTVC
        cell.configureCell(with: viewModel.products[indexPath.row])
        
        return cell
    }
        
    
}
