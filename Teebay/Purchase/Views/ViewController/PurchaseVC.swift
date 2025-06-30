//
//  PurchaseVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//

import UIKit
import JGProgressHUD
import Toast_Swift

class PurchaseVC: UIViewController, StoryboardInstantiable {
    static var storyboardName: StoryboardName
    {
        return .purchase
    }

    var product : AllProductModelElement?
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var catogoryLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var rentButton: UIButton!
    
    @IBOutlet weak var buyButton: UIButton!
    
    private lazy var hud: JGProgressHUD = JGProgressHUD(style: .dark)
    private lazy var viewModel = PurchaseVM(self)
    
    var isFromNotification : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rentButton.layer.cornerRadius = 8
        buyButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
        setupData()
    }
    
    
    @IBAction func onTappedRentButton(_ sender: Any) {
        
        guard let vc = RentalDatePopVC.instantiateSelf() else { return }

     
        vc.confirmRentalDateHandler = { [weak self] (startDate, endDate) in
            guard let self = self else { return }
            let rental = RentalRequestMdoel(renter: product?.seller ?? 0, product: product?.id ?? 0, rent_option: product?.rentOption ?? "", rent_period_start_date: startDate, rent_period_end_date: endDate)
            viewModel.postRental(rental: rental)
        }
        navigationController?.modalPresentationStyle = .fullScreen
     
        self.navigationController?.present(vc, animated: true)
        
      
        
    }
    
    @IBAction func onTappedBuyButton(_ sender: Any) {
        openBuyActionSheet()
    }
    
    func setupData() {
        NameLabel.text = product?.title ?? ""
        catogoryLabel.text = product?.categories?.joined(separator: ", ")
        priceLabel.text = product?.purchasePrice ?? ""
        descriptionLabel.text = product?.description ?? ""
        buyButton.isHidden = isFromNotification
        rentButton.isHidden = isFromNotification
    }
    
    func openBuyActionSheet() {
        
        let alertController = UIAlertController(title: "Are you sure you want to buy this product?", message: nil, preferredStyle: (UIDevice.current.userInterfaceIdiom == .pad)
                                                ? .alert
                                                : .actionSheet)
        
        
        let action1 = UIAlertAction(title: "Yes", style: .destructive) { _ in
            
//            self.viewModel.deleteProduct(productId: productId)
            let buyModel = BuyRequestModel(buyer: self.product?.seller ?? -1, product: self.product?.id ?? -1)
            self.viewModel.buyProduct(buyModel: buyModel)
            
        }

        alertController.addAction(action1)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - PurchaseVMDelegate
extension PurchaseVC: PurchaseVMDelegate {
    
    func rentalCreated() {
        print("Rental Success")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.throwNotification(title: "Rent Successfull", body: "You have rented: \(self.product?.title ?? "")", sound: .default)
            self.view.makeToast("You have successfully rented this item", duration: 2.0, position: .center) { didTap in
                self.navigationController?.popViewController(animated: true)
            }
           
        }
    }
    
    func productPurchased() {
        print("Purchase Success")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.throwNotification(title: "Purchased Successfully", body: "You have purchased: \(self.product?.title ?? "")", sound: .default)
            self.view.makeToast("You have successfully bought this item", duration: 2.0, position: .center) { didTap in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func failedWithError(code: Int, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.hud.isVisible {
                self.hud.show(in: self.view)
            }
            
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.textLabel.text = title
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
        
        print("Rental Success")
    }
    
    
}

