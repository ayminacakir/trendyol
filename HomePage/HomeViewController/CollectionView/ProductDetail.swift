struct ProductDetail: Decodable {
    let id: Int
    let title: String
    let price: Double
    let category: String
    let image: String
    let description: String
    let rating: Rating
    
    
}

struct Rating: Decodable {
    let rate: Double
}
