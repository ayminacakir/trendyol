import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var products: [Product] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
        title = "Home"

        fetchData()
        setupCollectionView()
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchData() {
        NetworkManager.shared.fetchProducts { [weak self] products in
            guard let self = self, let products = products else { return }
            DispatchQueue.main.async {
                self.products = products
                self.collectionView.reloadData()
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index: \(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configure(with: products[indexPath.item])
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.item]
        let detailVC = ProductDetailViewController()
        detailVC.productID = selectedProduct.id
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
