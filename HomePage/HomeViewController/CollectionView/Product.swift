struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let category: String
    let image: String
    let description: String
    let rate: Double
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, category, image, description, rating
    }
    
    private enum RatingKeys: String, CodingKey {
        case rate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(Double.self, forKey: .price)
        category = try container.decode(String.self, forKey: .category)
        image = try container.decode(String.self, forKey: .image)
        description = try container.decode(String.self, forKey: .description)
        
        let ratingContainer = try container.nestedContainer(keyedBy: RatingKeys.self, forKey: .rating)
        rate = try ratingContainer.decode(Double.self, forKey: .rate)
    }
}
