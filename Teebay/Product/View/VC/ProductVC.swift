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
        tableView.separatorStyle = .none
       // tableView.delegate = self
        tableView.register(ProductTVC.nib, forCellReuseIdentifier: ProductTVC.identifier)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTappedAddButton(_ sender: Any) {
        guard let vc = CreateProductVC.instantiateSelf() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func openDeleteActionSheet(productId: String) {
        
        let alertController = UIAlertController(title: "Do you want to delete this product?", message: nil, preferredStyle: (UIDevice.current.userInterfaceIdiom == .pad)
                                                ? .alert
                                                : .actionSheet)
        
        
        let action1 = UIAlertAction(title: "Yes", style: .destructive) { _ in
            
            self.viewModel.deleteProduct(productId: productId)
            
        }

        alertController.addAction(action1)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
  
}


// MARK: - AuthVC
extension ProductVC: ProductVMDelegate {
    func productDeleted() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            viewModel.getProducts()
        }
    }
    
    
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        guard let vc = EditProductVC.instantiateSelf() else { return }
        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProductVC : ProductTVCDelegate {
    
    func didTapDeleteButton(for product: AllProductModelElement) {
       openDeleteActionSheet(productId: "\(product.id ?? -1)")
    }
    
    
}
