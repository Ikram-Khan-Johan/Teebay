//
//  CreateProductVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 17/6/25.
//

import UIKit
import Toast_Swift
import JGProgressHUD

class CreateProductVC: UIViewController, StoryboardInstantiable {
    static var storyboardName: StoryboardName
    {
        return .product
    }

    
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
    
    @IBOutlet weak var imageName: UILabel!
    
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
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let dropdown = MultiSelectDropdown()
    var stepCount: Int = 1
    var categorySelected : Bool = false
    var isImageUploaded : Bool = true
    var renType: String = ""
    var selectedCategories: [String] = []
    
    var fileName = ""
    var imageData: Data?
  
    private lazy var viewModel = CreateProductVM(self)
    private lazy var hud = JGProgressHUD(style: .dark)
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        imageName.text = "No Image Selected"
        backButton.isHidden = true
        titleTF.delegate = self
        perDayButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
        perHourButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
        dropdown.items = ["Math", "English", "Science", "History"]
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
        titleStackview.isHidden = false
        categoryStackview.isHidden = true
        descriptionStackview.isHidden = true
        uploadImageStackview.isHidden = true
        priceStackview.isHidden = true
        summaryStackview.isHidden = true
        progreessView.progress = 0.167
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                   tapGesture.cancelsTouchesInView = false
                   view.addGestureRecognizer(tapGesture)
//        view.addSubview(dropdown)
        imagePicker.delegate = self
    }
    
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    
    func showToast(message : String) {
        self.view.makeToast(message, duration: 2.0, position: .bottom)
    }
  
    
    @IBAction func titleTF(_ sender: Any) {
        
    }
    
    @IBAction func onTappedCategoryButton(_ sender: Any) {
        
        view.addSubview(dropdown)
    }
    
    @IBAction func onTappedTakePictureButton(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func onTappedUploadPictureButton(_ sender: Any) {
        openGallary()
    }
    
    @IBAction func onTappedPerHourButton(_ sender: Any) {
        
        perHourButton.setImage(UIImage(named: "pr_radio_fill"), for: .normal)
        perDayButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
        
        renType = "Hour"
    
    }
    
    @IBAction func onTappedPerDayButton(_ sender: Any) {
        perHourButton.setImage(UIImage(named: "pr_radio_blank"), for: .normal)
        perDayButton.setImage(UIImage(named: "pr_radio_fill"), for: .normal)

        renType = "Day"
    }
    
    @IBAction func onTappedBackButton(_ sender: Any) {
        nextButton.setTitle("Next", for: .normal)
        switch stepCount {
        case 1:
            
            titleStackview.isHidden = true
            categoryStackview.isHidden = false
            
        case 2:
            
            categoryStackview.isHidden = true
            titleStackview.isHidden = false
            backButton.isHidden = true
            
        case 3:
            
            descriptionStackview.isHidden = true
            categoryStackview.isHidden = false
            
        case 4:
            
            uploadImageStackview.isHidden = true
            descriptionStackview.isHidden = false
            
        case 5:
            priceStackview.isHidden = true
            uploadImageStackview.isHidden = false
            
        case 6:
            summaryStackview.isHidden = true
            priceStackview.isHidden = false
            
        default:
            stepCount -= 1
        }
        
        stepCount -= 1
        progreessView.progress -= ( 1.00 / 6.00)
    }
    
    @IBAction func onTappedNextButton(_ sender: Any) {
        nextButton.setTitle("Next", for: .normal)
        switch stepCount {
        case 1:
            if titleTF.text?.isEmpty == true {
                showToast(message: "Enter title Please")
                return
            } else {
                titleStackview.isHidden = true
                categoryStackview.isHidden = false
                backButton.isHidden = false
            }
            stepCount += 1
            
        case 2:
            if selectedCategories.count == 0 {
                showToast(message: "Select Category Please")
                return
            } else {
                self.dropdown.removeFromSuperview()
                categoryStackview.isHidden = true
                descriptionStackview.isHidden = false
                
            }
            stepCount += 1
        case 3:
            if descriptionTExtview.text.isEmpty == true {
                showToast(message: "Please Enter Description")
                return
            } else {
                descriptionStackview.isHidden = true
                uploadImageStackview.isHidden = false
            }
            stepCount += 1
            
        case 4:
            
            if imageData == nil {
                showToast(message: "Please upload a product image")
                return
            } else {
                uploadImageStackview.isHidden = true
                priceStackview.isHidden = false
            }
            stepCount += 1
            
        case 5:
            
            if purchasePriceTF.text?.isEmpty == true || rentPriceTF.text?.isEmpty == true || renType.isEmpty {
                showToast(message: "Please enter all the required fields")
                return
            } else {
                priceStackview.isHidden = true
                summaryStackview.isHidden = false
            }
            stepCount += 1
           
            nextButton.setTitle("Submit", for: .normal)
            
            titleLabel.text = "Title: " + (titleTF.text ?? "")
            descriptionLabel.text = "Description: " + descriptionTExtview.text
            categoryLabel.text = "Categories: " + selectedCategories.map(\.self).joined(separator: ", ")
            priceLabel.text = "Purchase Price: " + (purchasePriceTF.text ?? "")
            toRentLabel.text = "To Rent: " + (rentPriceTF.text ?? "")
            rentTypeLabel.text = "Rent Option: " + renType
            
        case 6:
            // Call Create Product API
            
            let title = titleTF.text ?? ""
            let description = descriptionTExtview.text ?? ""
            let purchasePrice = purchasePriceTF.text ?? ""
            let rentPrice = rentPriceTF.text ?? ""
            let renType = self.renType
            let selectedCats = selectedCategories
            var image : Data = Data()
            
            
            if let selectedImage = imageData {
                image = selectedImage
            }
           
            viewModel.createProduct(title: title, description: description, categories: selectedCats, imageData: image, purchasePrice: purchasePrice, rentPrice: rentPrice , rentOption: renType)
        default:
            stepCount -= 1
        }
        progreessView.progress += ( 1.00 / 6.00)
    }
    
    private func openCamera() {
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                imagePicker.sourceType = .camera
    //            imagePicker.allowsEditing = true
                present(imagePicker, animated: true, completion: nil)
                
            } else {
                
                let alert  = UIAlertController(title: "No Camera", message: "You don't have camera", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "No Camera", style: .default, handler: nil))
                
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                alert.popoverPresentationController?.permittedArrowDirections = []
                
                present(alert, animated: true, completion: nil)
            }
        }
        
        private func openGallary() {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
}

extension CreateProductVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}


extension CreateProductVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
//            profileImage.image = image
            
            if picker.sourceType == UIImagePickerController.SourceType.camera {
                
                let imgName = "\(UUID().uuidString).jpeg"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                
                let data = image.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                fileName = URL.init(fileURLWithPath: localPath).lastPathComponent
                
//                guard let image_data: Data = (image.resizeWithWidth(width: 150)?.pngData()) else { print("no imageData"); return }
                imageData = image.pngData()
                
            } else if let file_name = info[.imageURL] as? URL  {
                fileName = file_name.lastPathComponent
//                guard let image_data: Data = (image.resizeWithWidth(width: 150)?.pngData()) else { print("no imageData"); return }
                imageData = image.pngData()
            }
            
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            profileImage.image = image
            
            if picker.sourceType == UIImagePickerController.SourceType.camera {
                
                let imgName = "\(UUID().uuidString).jpeg"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                
                let data = image.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                fileName = URL.init(fileURLWithPath: localPath).lastPathComponent
                
//                guard let image_data: Data = (image.resizeWithWidth(width: 150)?.pngData()) else { print("no imageData"); return }
                imageData = image.pngData()
                
            } else if let file_name = info[.imageURL] as? URL  {
                fileName = file_name.lastPathComponent
//                guard let image_data: Data = (image.resizeWithWidth(width: 150)?.pngData()) else { print("no imageData"); return }
                imageData = image.pngData()
            }
        }
        
        dismiss(animated: true) {
            [weak self] in
            guard let self = self else { return }
//            self.isSaveEnable = true

            if let imageData = self.imageData {
//                self.hud = JGProgressHUD(style: .dark)
//                self.hud.show(in: self.view)
//                self.viewModel?.updateImage(imgData: imageData, fileName: self.fileName)
                self.imageName.text = "Image Name:" + self.fileName
                
            } else {
                self.imageName.text = "No Image Selected"
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension CreateProductVC : CreateProductVMDelegate {
    
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
            guard let vc = ProductVC.instantiateSelf() else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
