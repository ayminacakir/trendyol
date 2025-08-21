import UIKit
import FirebaseAuth
import FirebaseFirestore
import Network

class FavoriteProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var favoriteProducts: [ProductSummary] = []
    private var favoriteListener: ListenerRegistration?  //Firestore gibi bir gerçek zamanlı veri tabanından gelen değişiklikleri dinleyen listener kaydı.
    
    
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet",
                                      message: "Please check your connection and try again.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favoriler"
        
        setupTableView()
        observeFavoriteProducts() // Gerçek zamanlı ürün eklenip çıkarıldığında güncellemyi yakalar
        
        NetworkManager.shared.fetchProducts { products in
            DispatchQueue.main.async {
                if products == nil {
                    self.showNoInternetAlert()
                } else {
                    // ürünleri göster
                }
            }
        }

    }
    
    deinit {
        favoriteListener?.remove() // Memory leak önleme
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteProductCell.self, forCellReuseIdentifier: "FavoriteProductCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteProductCell", for: indexPath) as! FavoriteProductCell
        let product = favoriteProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let user = Auth.auth().currentUser else { return }
            let product = favoriteProducts[indexPath.row]
            let db = Firestore.firestore()
            
            db.collection("users").document(user.uid).collection("favorites").document("\(product.id)").delete { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Favoriden silinemedi: \(error.localizedDescription)")
                } else {
                    // Diziden kaldır ve TableView'i güncelle
                    self.favoriteProducts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedProduct = favoriteProducts[indexPath.row]
        let detailVC = ProductDetailViewController()
        detailVC.productID = selectedProduct.id
        navigationController?.pushViewController(detailVC, animated: true)
    }

    
    //  Real-time Firestore listener
    private func observeFavoriteProducts() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let favRef = db.collection("users").document(user.uid).collection("favorites")
        
        favoriteListener = favRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Favoriler alınamadı: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            // 🔹 addedAt alanına göre sırala (en yeni başta olacak)
            let sortedDocs = documents.sorted { doc1, doc2 in
                let t1 = doc1["addedAt"] as? Timestamp ?? Timestamp()
                let t2 = doc2["addedAt"] as? Timestamp ?? Timestamp()
                return t1.dateValue() > t2.dateValue()
            }
            
            // 🔹 sadece Int ID array oluştur
            let productIDs = sortedDocs.compactMap { Int($0.documentID) }
            
            let group = DispatchGroup()
            var fetchedProducts: [ProductSummary] = []
            
            for id in productIDs {
                group.enter()
                NetworkManager.shared.fetchProductDetail(id: id) { detail in
                    if let detail = detail {
                        let summary = ProductSummary(
                            id: detail.id,
                            title: detail.title,
                            price: detail.price,
                            image: detail.image,
                            rating: detail.rating
                        )
                        fetchedProducts.append(summary)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                // 🔹 Sıra bozulmasın diye ürünleri productIDs sırasına göre diziyoruz
                self.favoriteProducts = productIDs.compactMap { id in
                    fetchedProducts.first(where: { $0.id == id })
                }
                
                self.tableView.reloadData()
            }
        }
    }
}
