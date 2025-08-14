import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tertiarySystemBackground
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        appearance.stackedLayoutAppearance.normal.iconColor = .systemOrange
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }/*iOS 15 ile gelen scrollEdgeAppearance da ayarlanır.
          
          Böylece sayfa yukarı kayarken bile tasarım tutarlı olur.*/
        
        let homeIcon = UIImage(systemName: "house")
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Ana Ekran", image: homeIcon, selectedImage: homeIcon)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.circle"), tag: 1)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        viewControllers = [homeNav, profileNav]
        
        updateProfileTabIcon(selected: false)
    }
    // Tab değiştiğinde tetiklenir
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let isProfileSelected = (selectedIndex == 1)
        updateProfileTabIcon(selected: isProfileSelected)
    }
    
    private func updateProfileTabIcon(selected: Bool) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            var initialsImage: UIImage?
            
            if let data = snapshot?.data(),
               let name = data["name"] as? String {
                let initials = self.getInitials(from: name)
                initialsImage = self.initialsToImage(initials: initials, selected: selected)
            } else {
                let initials = self.getInitials(from: user.displayName ?? "Kullanıcı")
                initialsImage = self.initialsToImage(initials: initials, selected: selected)
            }
            
            DispatchQueue.main.async {
                if let navControllers = self.viewControllers,
                   navControllers.count > 1,
                   let profileNav = navControllers[1] as? UINavigationController {
                    profileNav.tabBarItem.image = initialsImage?.withRenderingMode(.alwaysOriginal)
                    profileNav.tabBarItem.selectedImage = initialsImage?.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
    
    private func getInitials(from name: String) -> String {
        let components = name.split(separator: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.joined()
    }
    
    // Arka plan rengi profil seçili olup olmamasına göre değişiyor
    private func initialsToImage(initials: String, selected: Bool) -> UIImage? {
        let label = UILabel()
        label.frame.size = CGSize(width: 30, height: 30)
        label.text = initials
        label.textAlignment = .center
        label.backgroundColor = selected ? .systemBlue : .systemOrange
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        
        UIGraphicsBeginImageContextWithOptions(label.frame.size, false, 0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
