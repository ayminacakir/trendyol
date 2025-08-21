import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProductDetailViewController: UIViewController {
    
    var productID: Int?
    
    var isFavorite: Bool = false {
        didSet { updateFavoriteButton() }
    }
    
    private var favoriteButton: UIButton!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.15
        iv.layer.shadowOffset = CGSize(width: 0, height: 4)
        iv.layer.shadowRadius = 6
        iv.layer.masksToBounds = false
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .title2)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let priceLabel = IconLabel(iconName: "tag.fill", iconColor: .systemGreen)
    private let categoryLabel = IconLabel(iconName: "folder.fill", iconColor: .systemBlue)
    private var ratingLabel = IconLabel(iconName: "star.fill", iconColor: .systemOrange)
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        
        setupActivityIndicator()
        setupView()
        setupFavoriteButton()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNetworkChange(_:)),
            name: .networkStatusChanged,
            object: nil
        )//ağ durumu değiştiğinde çalışacak bir gözlemci ekliyoruz
        
        fetchProductDetail()
        fetchFavoriteState()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(categoryLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(priceLabel)
        view.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            
            ratingLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -10),
            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func handleNetworkChange(_ notification: Notification) {
        if let isConnected = notification.userInfo?["isConnected"] as? Bool {
            if isConnected {
                showAutoDismissAlert(title: "Internet Connected", message: "You are back online!")
                fetchProductDetail()
            } else {
                showAutoDismissAlert(title: "No Internet", message: "Please check your connection.")
            }
        }
    }
    
    
    func showAutoDismissAlert(title: String, message: String) {
        if presentedViewController is UIAlertController { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { alert.dismiss(animated: true) }
    }
    
    func fetchProductDetail() {
        guard let id = productID else { return }
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        
        NetworkManager.shared.fetchProductDetail(id: id) { [weak self] product in
            //NetworkManager ile ürün detaylarını çekiyor.
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                guard let product = product else {
                    self.showAutoDismissAlert(title: "Error", message: "Could not load product.")
                    return
                }
                
                self.titleLabel.text = product.title
                self.priceLabel.setText(String(format: "$%.2f", product.price))
                self.categoryLabel.setText(product.category)
                self.descriptionLabel.text = product.description
                self.ratingLabel.setText(String(format: "%.1f", product.rating.rate))
                
                if let url = URL(string: product.image) {
                    URLSession.shared.dataTask(with: url) { data, _, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async {
                            UIView.transition(with: self.imageView, duration: 0.2, options: .transitionCrossDissolve) {
                                self.imageView.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    private func setupFavoriteButton() {
        favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemGray
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    @objc private func toggleFavorite() {
        guard let user = Auth.auth().currentUser,
              let productID = productID else { return }
        let db = Firestore.firestore()
        let favRef = db.collection("users").document(user.uid).collection("favorites").document("\(productID)")
        
        if isFavorite {
            favRef.delete { [weak self] error in
                if error == nil { self?.isFavorite = false }
            }
        } else {
            favRef.setData(["addedAt": Timestamp()]) { [weak self] error in
                if error == nil { self?.isFavorite = true }
            }
        }
    }
    
    private func updateFavoriteButton() {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .systemRed
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .systemGray
        }
    }
    
    private func fetchFavoriteState() {
        guard let user = Auth.auth().currentUser,
              let productID = productID else { return }
        let db = Firestore.firestore()
        let favRef = db.collection("users").document(user.uid).collection("favorites").document("\(productID)")
        
        favRef.getDocument { [weak self] snapshot, _ in
            self?.isFavorite = snapshot?.exists ?? false
        }
    }
    
    class IconLabel: UIView {
        private let iconView: UIImageView = {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .label
            return iv
        }()
        
        private let textLabel: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = .systemFont(ofSize: 15)
            lbl.textColor = .label
            return lbl
        }()
        
        init(iconName: String, iconColor: UIColor = .label) {
            super.init(frame: .zero)
            iconView.image = UIImage(systemName: iconName)
            iconView.tintColor = iconColor
            backgroundColor = iconColor.withAlphaComponent(0.1)
            layer.cornerRadius = 8
            setupViews()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        private func setupViews() {
            translatesAutoresizingMaskIntoConstraints = false
            addSubview(iconView)
            addSubview(textLabel)
            
            NSLayoutConstraint.activate([
                iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
                iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconView.widthAnchor.constraint(equalToConstant: 18),
                iconView.heightAnchor.constraint(equalToConstant: 18),
                
                textLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 6),
                textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
                textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
                textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
            ])
        }
        
        func setText(_ text: String) {
            textLabel.text = text
        }
    }
}
