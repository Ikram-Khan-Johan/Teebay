//
//  ProductTVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 17/6/25.
//

import UIKit

class ProductTVC: UITableViewCell {

    public static let identifier = "\(#function)"
    public static let nib = UINib(nibName: "\(#function)", bundle: nil)
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLAbel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    
    var product: AllProductModelElement?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewLabel.isHidden = true
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with product: AllProductModelElement) {
        self.product = product
        productNameLabel.text = product.title
        priceLabel.text = "Price: $\(product.purchasePrice ?? "") Rent: $\(product.rentPrice ?? "") \(product.rentOption ?? "")"
        categoryLabel.text = product.categories?.joined(separator: ", ")
        
        dateLabel.text = product.datePosted?.toFormattedDate()
    }
}
