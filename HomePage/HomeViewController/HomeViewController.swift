import UIKit
import Network

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var products: [ProductSummary] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
        title = "Home"
        
        setupCollectionView()
        setupNetworkObserver()
        loadProducts()
    }
    
    // 🔹 Ağ değişikliklerini dinle
    private func setupNetworkObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNetworkChange(_:)),
            name: .networkStatusChanged,
            object: nil
        )
    }
    
    @objc private func handleNetworkChange(_ notification: Notification) {
        if let isConnected = notification.userInfo?["isConnected"] as? Bool {
            if isConnected {
                showAlert(title: "Internet Connected", message: "You are back online!")
                loadProducts() // tekrar yükle
            } else {
                showAlert(title: "No Internet", message: "Please check your connection.")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    // 🔹 Ürünleri yükle
    private func loadProducts() {
        NetworkManager.shared.fetchProducts { [weak self] products in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let products = products {
                    self.products = products
                    self.collectionView.reloadData()
                } else {
                    self.showAlert(title: "No Internet", message: "Please check your connection and try again.")
                }
            }
        }
    }
    
    // 🔹 CollectionView kurulumu
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: 270)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // 🔹 CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configure(with: products[indexPath.item])
        return cell
    }
    
    // 🔹 Ürün seçilince detay sayfasına git
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.item]
        let detailVC = ProductDetailViewController()
        detailVC.productID = selectedProduct.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
