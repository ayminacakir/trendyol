import UIKit
import Lottie

class SplashScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    private let pages: [SplashScreenData] = [
        SplashScreenData(animationName: "welcome", title: "Hoş Geldin!", description: "Sana özel fırsatlar ve eşsiz bir alışveriş deneyimi için uygulamayı hemen keşfetmeye başla."),
        SplashScreenData(animationName: "explore", title: "Keşfet!", description: "Binlerce ürünü kolayca incele, dilediğini favorilerine ekle ve ihtiyaçlarına en uygun seçenekleri bul." ),
        SplashScreenData(animationName: "ready", title: "Hazırsın!", description: "Favorilerini sepetine ekle, kampanyaları kaçırmadan alışverişini güvenle tamamla.         Şimdi başlama zamanı!" )
    ]

    private let splashCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3
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

    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let bottomControlsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let selectedPage = sender.currentPage
        let indexPath = IndexPath(item: selectedPage, section: 0)
        splashCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }


    private var currentPageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        splashCollectionView.backgroundColor = .orange
        splashCollectionView.bounces = false
        splashCollectionView.alwaysBounceHorizontal = false

        view.addSubview(splashCollectionView)
        view.addSubview(bottomControlsContainer)

        bottomControlsContainer.addSubview(pageControl)
        bottomControlsContainer.addSubview(actionButton)
        bottomControlsContainer.addSubview(skipButton)

        splashCollectionView.dataSource = self
        splashCollectionView.delegate = self

        splashCollectionView.register(SplashCollectionViewCell.self, forCellWithReuseIdentifier: SplashCollectionViewCell.identifier)

        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        actionButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)

        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            self?.goToNextPage()
        }

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
            actionButton.heightAnchor.constraint(equalToConstant: 40),

            skipButton.centerYAnchor.constraint(equalTo: bottomControlsContainer.centerYAnchor),
            skipButton.leadingAnchor.constraint(equalTo: bottomControlsContainer.leadingAnchor, constant: 20),
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
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = pageIndex
        updateActionButtonIcon(for: pageIndex)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = pageIndex
        updateActionButtonIcon(for: pageIndex)
    }

    // ✅ Bu fonksiyon animasyon bitmeden hedef sayfayı verir
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                    withVelocity velocity: CGPoint,
                                    targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageIndex = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageIndex
        updateActionButtonIcon(for: pageIndex)
    }

    private func updateActionButtonIcon(for page: Int) {
        let iconName = page == pages.count - 1 ? "checkmark" : "arrow.right"
        actionButton.setImage(UIImage(systemName: iconName), for: .normal)
    }

    private func navigateToMainScreen() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }

    @objc private func actionButtonTapped() {
        let currentPage = pageControl.currentPage
        if currentPage < pages.count - 1 {
            let nextIndexPath = IndexPath(item: currentPage + 1, section: 0)
            splashCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        } else {
            navigateToMainScreen()
        }
    }

    @objc private func skipButtonTapped() {
        navigateToMainScreen()
    }

    private func goToNextPage() {
        let totalPages = pages.count

        if currentPageIndex < totalPages - 1 {
            currentPageIndex += 1
            let indexPath = IndexPath(item: currentPageIndex, section: 0)
            splashCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
                self?.goToNextPage()
            }
        }
    }
}
