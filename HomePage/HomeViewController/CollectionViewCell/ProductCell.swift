import UIKit

class ProductCell: UICollectionViewCell {
    
    static let identifier = "ProductCell"
    
    let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }()
    
    let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textColor = .systemGreen
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }()
    
    let rateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .systemGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(rateLabel)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor ),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor ),
            productImageView.heightAnchor.constraint(equalToConstant: 170),
           
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            rateLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            rateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
            
        ])
           
    }
    required init(coder: NSCoder) {
        fatalError()
    }
    
    
    /*Bir Product modelinden aldığı verileri hücrede göstermek.
     Yani burası hücreyi dolduran yer.*/
    func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        rateLabel.text = "\(product.rating)"
        
        if let url = URL(string: product.image){
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.productImageView.image = UIImage(data: data)
                    }
                }
            }
            
            
        }
    }
    
}
