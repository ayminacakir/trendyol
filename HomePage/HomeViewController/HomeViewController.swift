import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var allProducts: [ProductSummary] = []     // tüm ürünler
    var products: [ProductSummary] = []        // ekranda gösterilen ürünler (sayfa bazlı)
    var filteredProducts: [ProductSummary] = []// arama için filtrelenmiş ürünler
    
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var loadingIndicator: UIActivityIndicatorView!
    
    // Pagination
    var currentPage = 0
    let limit = 10 // her sayfada kaç ürün yüklenecek
    var isLoading = false // yeni ürün yüklenirken tekrar yükleme yapılmasını engelliyoruz
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
        title = "Home"
        
        setupSearchBar()
        setupCollectionView()
        setupLoadingIndicator()
        fetchAllProducts()
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search products"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
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
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.color = .gray
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // Tüm ürünleri bir defa çekiyoruz
    func fetchAllProducts() {
        isLoading = true
        loadingIndicator.startAnimating()
        
        NetworkManager.shared.fetchProducts { [weak self] products in
            guard let self = self, let products = products else { return }
            DispatchQueue.main.async {
                self.allProducts = products
                self.loadNextPage()
                self.isLoading = false
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    // Sayfa sayfa ekrana basıyoruz
    func loadNextPage() {
        let startIndex = currentPage * limit
        let endIndex = min(startIndex + limit, allProducts.count)
        
        guard startIndex < endIndex else { return } // daha ürün yok
        
        let nextProducts = Array(allProducts[startIndex..<endIndex])
        products.append(contentsOf: nextProducts)
        filteredProducts = products
        collectionView.reloadData()
        
        currentPage += 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configure(with: filteredProducts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = filteredProducts[indexPath.item]
        let detailVC = ProductDetailViewController()
        detailVC.productID = selectedProduct.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if position > (contentHeight - frameHeight - 100) && !isLoading { //Burada kontrol ediyoruz: kullanıcı içeriğin sonuna 100 px kala scroll yapmış mı?
            isLoading = true
            loadingIndicator.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // küçük delay simülasyonu
                self.loadNextPage()
                self.isLoading = false
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
