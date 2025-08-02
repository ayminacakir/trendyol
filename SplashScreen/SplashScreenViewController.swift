import UIKit

class SplashScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    private let pages: [SplashScreenData] = [
        SplashScreenData(image: UIImage(named: "logo")!, title: "Hoş Geldin!", description: "Uygulamayı kullanmaya başla.."),
        SplashScreenData(image: UIImage(named: "kesfet")!, title: "Keşfet!", description: "Ürünleri incele, favorilere ekle.." ),
        SplashScreenData(image: UIImage(named: "alışveris-sepeti")!, title: "Hazırsın!", description: "Alışverişe başla.." )
    ]
    
    private let splashCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // kaydırma yönünü yatay olarak ayarlaıd
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size // her hücre tam ekran kaplıyor.

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false //Yatay kaydırma çubuğu görünmez
        collectionView.translatesAutoresizingMaskIntoConstraints = false //AutoLayout kullanımı için otomatik boyutlandırma kapatılır
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3 // Kaç sayfan varsa
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        return button
    }()
    
    private let bottomControlsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() //Bu view, genellikle buton ve sayfa göstergesi gibi alt kısımdaki kontrol elemanlarını bir arada tutmak için kullanıl


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(splashCollectionView)
        view.addSubview(bottomControlsContainer)

        bottomControlsContainer.addSubview(pageControl)
        bottomControlsContainer.addSubview(actionButton)
        
        
        splashCollectionView.dataSource = self //veriler burdan sağlanıyo
        splashCollectionView.delegate = self //davranışlar kontrol ediliyo
        
        splashCollectionView.register(SplashCollectionViewCell.self, forCellWithReuseIdentifier: SplashCollectionViewCell.identifier)  //
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
           
            splashCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            splashCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomControlsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomControlsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomControlsContainer.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.centerYAnchor.constraint(equalTo: bottomControlsContainer.centerYAnchor),
            pageControl.centerXAnchor.constraint(equalTo: bottomControlsContainer.centerXAnchor),
            
            actionButton.centerYAnchor.constraint(equalTo: bottomControlsContainer.centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: bottomControlsContainer.trailingAnchor, constant: -20),
            actionButton.widthAnchor.constraint(equalToConstant: 40),
            actionButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return pages.count
      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SplashCollectionViewCell.identifier, for: indexPath) as? SplashCollectionViewCell else {
            return UICollectionViewCell()
        }

        let isLastPage = indexPath.item == pages.count - 1
        cell.configure(with: pages[indexPath.item], isLastPage: isLastPage)
        return cell
    }//koleksiyon görünümüne her hücre için hangi görünümün (cell) kullanılacağını ve içeriğin nasıl doldurulacağını söyler.

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = scrollView.contentOffset.x / view.frame.width
        let currentPage = Int(round(pageIndex))
        pageControl.currentPage = currentPage
        
        let iconName = currentPage == pages.count - 1 ? "checkmark" : "arrow.right"
        actionButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    
    private func navigateToMainScreen() {
        let mainVC = UIViewController() // kendi ana sayfa viewController’ını kullan
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }

    
    @objc private func actionButtonTapped() {
        let currentPage = pageControl.currentPage
        if currentPage < pages.count - 1 {
            // Bir sonraki sayfaya geç
            let nextIndexPath = IndexPath(item: currentPage + 1, section: 0)
            splashCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        } else {
            // Son sayfada → Ana sayfaya geç
            navigateToMainScreen()
        }
    }


}

