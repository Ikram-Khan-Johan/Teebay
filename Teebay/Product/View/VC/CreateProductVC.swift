//
//  CreateProductVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 17/6/25.
//

import UIKit

class CreateProductVC: UIViewController {

    // MARK: - Progress View
    @IBOutlet weak var progreessView: UIProgressView!
    
    // MARK: - Title Section
    @IBOutlet weak var titleStackview: UIStackView!
    @IBOutlet weak var titleTF: UITextField!
    
    // MARK: - Category Section
    @IBOutlet weak var categoryStackview: UIStackView!
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    // MARK: - description Section
    @IBOutlet weak var descriptionStackview: UIStackView!
    
    @IBOutlet weak var descriptionTExtview: UITextView!
    
    // MARK: - Image Upload Section
    @IBOutlet weak var uploadImageStackview: UIStackView!
    @IBOutlet weak var uploadPictureButton: UIButton!
    @IBOutlet weak var takePictureButton: UIButton!
    
    // MARK: - Price Section
    @IBOutlet weak var priceStackview: UIStackView!
    
    @IBOutlet weak var purchasePriceTF: UITextField!
    
    @IBOutlet weak var rentPriceTF: UITextField!
    
    // MARK: - Action
    @IBOutlet weak var perHourButton: UIButton!
    
    @IBOutlet weak var perDayButton: UIButton!
    
    // MARK: - Summary Section
    @IBOutlet weak var summaryStackview: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var toRentLabel: UILabel!
    
    @IBOutlet weak var rentTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    
    @IBAction func titleTF(_ sender: Any) {
        
    }
    
    @IBAction func onTappedTakePictureButton(_ sender: Any) {
        
    }
    
    @IBAction func onTappedUploadPictureButton(_ sender: Any) {
        
    }
    
    @IBAction func onTappedPerHourButton(_ sender: Any) {
        
    }
    
    @IBAction func onTappedPerDayButton(_ sender: Any) {
        
    }
    
    
    @IBAction func onTappedBackButton(_ sender: Any) {
    }
    
    @IBAction func onTappedNextButton(_ sender: Any) {
    }
    
}
