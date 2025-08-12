import UIKit
import Lottie

class SplashCollectionViewCell: UICollectionViewCell { //splash screen'deki her bir sayfanın nasıl görüneceğini tanımlar

    static let identifier = "SplashScreenPage"

    private let animationView: LottieAnimationView = {
        let animView = LottieAnimationView()
        animView.translatesAutoresizingMaskIntoConstraints = false
        animView.contentMode = .scaleAspectFill
        animView.loopMode = .loop
        return animView
    }()

    
    private let titleLabel: UILabel = {
        let label = UILabel()  //UILabel sınıfından bir nesne oluşturuluyor.
        label.font = .boldSystemFont(ofSize: 24) // Yazı tipi kalın (bold) ve boyutu 24 punto olarak ayarlanıyor.
        label.textAlignment = .center //Yazı yatayda ortalanarak hizalanıyor
        label.textColor = .black
        label.numberOfLines = 0 //Satır sayısı sınırsız (yani içerik kaç satır ise o kadar yer kaplar).
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()  //Apple’ın UIKit kütüphanesinde tanımlı olan bir sınıf
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    //UIStackView,iOS’ta birden fazla view’ı (örneğin UILabel, UIButton, UIImageView gibi) dikey veya yatay olarak düzenli bir şekilde sıralamak için kullanılan bir bileşendir.
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical //Alt elemanlar dikey olarak (üstten aşağıya) yerleştirilecek.
        sv.spacing = 25
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.20
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 10
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 1.0, green: 0.48, blue: 0.0, alpha: 1.0) // Açık turuncu
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: SplashScreenData, isLastPage: Bool) {
        animationView.animation = LottieAnimation.named(data.animationName)
            animationView.play()
        titleLabel.text = data.title
        descriptionLabel.text = data.description
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageContainerView.layer.cornerRadius = imageContainerView.frame.size.width / 2
        animationView.layer.cornerRadius = animationView.frame.size.width / 2
        //Aynı şekilde, içinde bulunan imageView da yuvarlatılıyor, tam bir çember oluyor.
        animationView.clipsToBounds = true //Yuvarlatılan köşelerin dışındaki görüntülerin kesilmesini sağlar.
    }

    private func setupViews() {
        contentView.addSubview(stackView)  //contentView, bir hücre (UITableViewCell veya UICollectionViewCell) içinde yer alan asıl içerik alanıdır.
        stackView.addArrangedSubview(imageContainerView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.setCustomSpacing(40, after: imageContainerView) //imageContainerView ile sonraki öğe (titleLabel) arasında 40 puanlık özel boşluk ayarlanıyor.

        
        imageContainerView.addSubview(animationView)
        
        
    }

    private func setupConstraints() {
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true

        
        NSLayoutConstraint.activate([
            // StackView tam ortada
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -30),
            
            
            // Görsel kare ve yuvarlak olacak şekilde
            imageContainerView.widthAnchor.constraint(equalToConstant: 180),
            imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            
            animationView.topAnchor.constraint(equalTo: imageContainerView.topAnchor), //imageView'in üst kenarı, imageContainerView'in üst kenarına eşit olacak.Yani, imageView tam olarak imageContainerView'in en üstünden başlayacak.


            animationView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            

        ])
        contentView.layoutIfNeeded() //Bunları yaparsan imageView ve imageContainerView ilk görünüşte yuvarlak olur.
    }
}
