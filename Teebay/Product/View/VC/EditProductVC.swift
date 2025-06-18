//
//  EditProductVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//

import UIKit
import Toast_Swift
import JGProgressHUD

class EditProductVC: UIViewController,  StoryboardInstantiable {
    static var storyboardName: StoryboardName
    {
        return .product
    } 

  
    
    // MARK: - Title Section
//    @IBOutlet weak var titleStackview: UIStackView!
    @IBOutlet weak var titleTF: UITextField!
    
    // MARK: - Category Section
//    @IBOutlet weak var categoryStackview: UIStackView!
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    // MARK: - description Section
//    @IBOutlet weak var descriptionStackview: UIStackView!
    
    @IBOutlet weak var descriptionTExtview: UITextView!
    
//    // MARK: - Image Upload Section
//    @IBOutlet weak var uploadImageStackview: UIStackView!
//    @IBOutlet weak var uploadPictureButton: UIButton!
//    @IBOutlet weak var takePictureButton: UIButton!
//    
//    @IBOutlet weak var imageName: UILabel!
//    
    // MARK: - Price Section
//    @IBOutlet weak var priceStackview: UIStackView!
    
    @IBOutlet weak var purchasePriceTF: UITextField!
    
    @IBOutlet weak var rentPriceTF: UITextField!
    
    // MARK: - Action
    @IBOutlet weak var perHourButton: UIButton!
    
    @IBOutlet weak var perDayButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    let dropdown = MultiSelectDropdown()
    var renType: String = ""
    var product : AllProductModelElement?
    
    var selectedCategories: [String] = []
    private lazy var viewModel = EditProductVM(self)
    private lazy var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        
        setupData()
        viewModel.getProductCategories()
    }
    
    func setupData() {
        guard let product = product else { return }
        
        titleTF.text = product.title
        descriptionTExtview.text = product.description
        purchasePriceTF.text = product.purchasePrice
        rentPriceTF.text = product.rentPrice
        selectedCategories = product.categories ?? []
        print("Categories : \(selectedCategories)")
        selectCategoryButton.setTitle(selectedCategories.isEmpty ? "Select Category" : selectedCategories.joined(separator: ", "), for: .normal)
        if product.rentOption == "day" {
            perHourButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
            perDayButton.setImage(UIImage(named: "pr_radio_fill"), for: .normal)
            
            renType = "day"
        } else {
            perHourButton.setImage(UIImage(named: "pr_radio_fill"), for: .normal)
            perDayButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
            
            renType = "hour"
        }
        
    }
    
    func setupView() {
        selectCategoryButton.imageToRight()
        perDayButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
        perHourButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
        
        dropdown.frame = CGRect(x: 40, y: 400, width: 240, height: 200)
        dropdown.onSelectionChanged = { selected in
           
            self.selectedCategories = Array(selected)
            print("Selected items: \(self.selectedCategories)")
            if self.selectedCategories.isEmpty == true {
                self.selectCategoryButton.setTitle("Select Categories", for: .normal)
            } else {
               
                self.selectCategoryButton.setTitle( self.selectedCategories.map(\.self).joined(separator: ", "), for: .normal)
            }
            
        }
        dropdown.onDone = {
               self.dropdown.removeFromSuperview()
               // Optionally update UI with selections
           }
       
      
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                   tapGesture.cancelsTouchesInView = false
                   view.addGestureRecognizer(tapGesture)
       
    }
    
    @IBAction func onTappedEditButton(_ sender: Any) {
        
        viewModel.editProduct(title: titleTF.text ?? "", description: descriptionTExtview.text, categories: selectedCategories, imageData: product?.productImage ?? "", purchasePrice: purchasePriceTF.text ?? "", rentPrice: rentPriceTF.text ?? "", rentOption: renType, sellerId: String(product?.seller ?? -1), productId: String(product?.id ?? -1))
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    func showToast(message : String) {
        self.view.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    @IBAction func onTappedCategoryButton(_ sender: Any) {
           
        dropdown.selectedItems = Set(selectedCategories)
        view.addSubview(dropdown)
        
       }
       
       
       @IBAction func onTappedPerHourButton(_ sender: Any) {
           
           perHourButton.setImage(UIImage(named: "pr_radio_fill"), for: .normal)
           perDayButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
           
           renType = "hour"
       
       }
       
       @IBAction func onTappedPerDayButton(_ sender: Any) {
           perHourButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
           perDayButton.setImage(UIImage(named: "pr_radio_fill"), for: .normal)

           renType = "day"
       }
  
}

extension EditProductVC : EditProductVMDelegate {
    
    func categoriesFetched() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dropdown.items = viewModel.productCategories.map({ $0.value ?? "" })
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
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
