import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var products: [ProductSummary] = []
    var filteredProducts: [ProductSummary] = []
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
        title = "Home"
        
        setupSearchBar()
        setupCollectionView()
        setupLoadingIndicator()
        fetchData()
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
    
    func setupLoadingIndicator() {
            loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.color = .gray
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loadingIndicator)
            
            NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: 270)
        //ekran genişliğini ikiye bölüp biraz boşluk bırakıyoruz.hücre yüksekliği 250 px
        layout.minimumLineSpacing = 8 //Alt alta olan hücreler arasında 8 px boşluk bırakır.
        layout.minimumInteritemSpacing = 8
        //Yan yana olan hücreler arasında 8 px boşluk bırakır
        
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //CollectionView’in kenarlarından boşluk bırakır

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self //hücreye tıklama gibi olayları yönetir.
        collectionView.dataSource = self // CollectionView’in kaç hücre olacağını ve hücrelerde ne gösterileceğini belirler.
    
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier) //CollectionView’e hangi hücreyi kullanacağını söylüyoruz.
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchData() {
        loadingIndicator.startAnimating() // spinner başlat
        
        NetworkManager.shared.fetchProducts { [weak self] products in
            guard let self = self, let products = products else { return }
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating() // spinner durdur
                self.products = products
                self.filteredProducts = products
                self.collectionView.reloadData()
            }
        }
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }


}
