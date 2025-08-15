import UIKit

class ProductDetailViewController: UIViewController {
    
    var productID: Int?
    
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
        
        
        let ratingOverlay = IconLabel(iconName: "star.fill", iconColor: .systemOrange)
        ratingOverlay.translatesAutoresizingMaskIntoConstraints = false
        self.ratingLabel = ratingOverlay
        
      
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(categoryLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(priceLabel)
        view.addSubview(ratingOverlay)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30), // spacing artırıldı
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            
            ratingOverlay.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -10),
            ratingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
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
        
        fetchProductDetail()
    }
    
    func fetchProductDetail() {
        guard let id = productID else { return }
        
        NetworkManager.shared.fetchProductDetail(id: id) { [weak self] product in
            guard let self = self, let product = product else { return }
            DispatchQueue.main.async {
                self.titleLabel.text = product.title
                self.priceLabel.setText(String(format: "$%.2f", product.price))
                self.categoryLabel.setText(product.category)
                self.descriptionLabel.text = product.description
                self.ratingLabel.setText(String(format: "%.1f", product.rating.rate))
                
                if let url = URL(string: product.image) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                
                                
                                // Fade-in animasyon
                                UIView.transition(with: self.imageView,
                                                  duration: 0.2,
                                                  options: .transitionCrossDissolve,
                                                  animations: {
                                    self.imageView.image = UIImage(data: data)
                                }, completion: nil)
                            }
                        }
                    }
                }
            }
        }
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
