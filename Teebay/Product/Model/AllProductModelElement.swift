// MARK: - AllProductModelElement
struct AllProductModelElement: Codable {
    let id: Int?
    let seller: Int?
    let title: String?
    let description: String?
    let categories: [String]?
    let productImage: String?
    let purchasePrice: String?
    let rentPrice: String?
    let rentOption: String?
    let datePosted: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case seller = "seller"
        case title = "title"
        case description = "description"
        case categories = "categories"
        case productImage = "product_image"
        case purchasePrice = "purchase_price"
        case rentPrice = "rent_price"
        case rentOption = "rent_option"
        case datePosted = "date_posted"
    }
}

typealias AllProductModel = [AllProductModelElement]