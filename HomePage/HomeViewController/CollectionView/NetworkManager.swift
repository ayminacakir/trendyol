import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchProducts(completion: @escaping ([Product]?) -> Void){
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error:", error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self,from: data)
                completion(products)
            }catch {
                print("Decoding Error:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    
    
}
    
