import UIKit

class ProductDetailViewController: UIViewController {
    
    var productID : Int?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.contentMode = .scaleAspectFit
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17)
        lbl.textColor = .systemGreen
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
        ])
        fetchProductDetail()
    }
    func fetchProductDetail() {
        guard let id = productID else { return }
        
        NetworkManager.shared.fetchProductDetail(id: id) { [weak self] product in
            guard let self = self, let product = product else { return }
            DispatchQueue.main.async {
                self.titleLabel.text = product.title
                self.priceLabel.text = "$\(product.price)"
                if let url = URL(string: product.image) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url){
                            DispatchQueue.main.async {
                                self.imageView.image = UIImage(data: data)
                            }
                        }
                    }
                }
            }
        }
    }
}
