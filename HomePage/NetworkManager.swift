import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchProducts(completion: @escaping ([ProductSummary]?) -> Void){
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
                let products = try JSONDecoder().decode([ProductSummary].self,from: data)
                completion(products)
            }catch {
                print("Decoding Error:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    
    
    func fetchProductDetail(id: Int, completion: @escaping (ProductDetail?) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products/\(id)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
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
                let product = try JSONDecoder().decode(ProductDetail?.self, from: data)
                completion(product)
            } catch {
                print("Decoding Error:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }

    

    
    
}
    
