//
//  ProductTVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 17/6/25.
//

import UIKit

protocol ProductTVCDelegate: AnyObject {
    func didTapDeleteButton(for product: AllProductModelElement)
}
class ProductTVC: UITableViewCell {

    public static let identifier = "\(#function)"
    public static let nib = UINib(nibName: "\(#function)", bundle: nil)
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var parentStackview: UIStackView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLAbel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    
    weak var delegate: ProductTVCDelegate?
    @IBOutlet weak var deleteButton: UIButton!
    var product: AllProductModelElement?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewLabel.isHidden = true
        self.parentStackview.layer.cornerRadius = 8
        self.parentStackview.layer.borderColor = UIColor.systemGray4.cgColor
        self.parentStackview.layer.borderWidth = 2
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onTappedDeleteButton(_ sender: Any) {
        if let product = self.product {
            self.delegate?.didTapDeleteButton(for: product)
        }
       
        
    }
    func configureCell(with product: AllProductModelElement) {
        self.product = product
        productNameLabel.text = product.title
        descriptionLAbel.text = product.description
        priceLabel.text = "Price: $\(product.purchasePrice ?? "") Rent: $\(product.rentPrice ?? "") \(product.rentOption ?? "")"
        categoryLabel.text = product.categories?.joined(separator: ", ")
        
        dateLabel.text = product.datePosted?.toFormattedDate()
    }
}
