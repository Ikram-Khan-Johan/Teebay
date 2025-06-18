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
    
    var selectedCategories: [String] = []
//    private lazy var viewModel = CreateProductVM(self)
    private lazy var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        selectCategoryButton.imageToRight()
    }
    
  
  
    
    func setupView() {
       
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
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    func showToast(message : String) {
        self.view.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    @IBAction func onTappedCategoryButton(_ sender: Any) {
           
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
