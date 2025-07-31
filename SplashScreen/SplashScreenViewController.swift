import UIKit

class SplashScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    private let pages: [SplashScreenData] = [
        SplashScreenData(image: UIImage(), title: "Hoş Geldin", description: "Uygulamayı kullanmaya başla"),
        SplashScreenData(image: UIImage(), title: "Keşfet", description: "Ürünleri incele, favorilere ekle" ),
        SplashScreenData(image: UIImage(), title: "Hazırsın!", description: "Alışverişe başla" )
    ]
    
    
    private let splashCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // yatay kaydırma
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size // tam ekran hücre

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(splashCollectionView)
        
        splashCollectionView.dataSource = self //veriler burdan sağlanıyo
        splashCollectionView.delegate = self
        
        splashCollectionView.register(SplashScreenPage.self, forCellWithReuseIdentifier: SplashScreenPage.identifier)
        
        NSLayoutConstraint.activate([
            splashCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            splashCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return pages.count
      }

      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SplashScreenPage.identifier, for: indexPath) as? SplashScreenPage else {
              return UICollectionViewCell()
          }
          cell.configure(with: pages[indexPath.item])
          return cell
      }
}

