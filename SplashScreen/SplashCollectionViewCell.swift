import UIKit

class SplashScreenPage: UICollectionViewCell {
    // SplashScreenPage, UICollectionViewCell sınıfından türetilmiş özel bir hücre sınıfıdır.Bu hücre, koleksiyon görünümünde (CollectionView) her bir sayfayı temsil eder.
    
    static let identifier = "SplashScreenPage" //hücreyi collectionview da tanımlamak için benzersiz bir kimlik sunar
    
    private let titleLabel = UILabel() //private çünkü sadece hücre içinde kullanılacak
    
    override init (frame: CGRect) { //genişliğini, yüksekliğini, konumunu
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6 //hücreyi görmen için geçici bir arka plan.
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    func configure(with data: SplashScreenData){
        titleLabel.text = data.title //Hücreye dışarıdan veri                                   aktarımı yapabilmeni sağlar.
    }
    
    private func setupViews(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false //Auto Layout sistemini kullanacağımızı belirtir false yazmak şarttır.
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center //metni otaya hizalar
        contentView.addSubview(titleLabel) //Label’ı ekranda gösterir
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
          
        ])

    }
    
    
    
    
    
    
}


