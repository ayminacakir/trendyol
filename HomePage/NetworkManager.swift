import Foundation
import UIKit
import Network

class NetworkManager {
    static let shared = NetworkManager()
        private let monitor = NWPathMonitor()
        private let queue = DispatchQueue(label: "NetworkMonitor")
        
    private(set) var isConnected: Bool = true {
        didSet {
            if oldValue != isConnected {
                DispatchQueue.main.async {
                    NotificationCenter.default.post( //tüm uygulamaya int durumunun değiştiğini bildirir
                        name: .networkStatusChanged,
                        object: nil,
                        userInfo: ["isConnected": self.isConnected]
                    )
                }
            }
        }
        willSet {
            print("isConnected about the changes")
        }
    }
        
        var didChangeStatus: ((Bool) -> Void)?
        
        private init() {
            monitor.pathUpdateHandler = { path in
                self.isConnected = path.status == .satisfied //Eğer cihaz internete bağlıysa true, değilse false.
            }
            monitor.start(queue: queue)
        }


    
    func fetchProducts(completion: @escaping ([ProductSummary]?) -> Void){
        guard isConnected else {
            print("No Internet Connection")
            completion(nil)
            return
        }
        
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
                completion(nil) // bu istekte veri yok veya hata oluştu.
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
        guard isConnected else {
            print("No Internet Connection")
            completion(nil)
            return
        }
        
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
                let product = try JSONDecoder().decode(ProductDetail.self, from: data)
                completion(product)
            } catch {
                print("Decoding Error:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}


    

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
