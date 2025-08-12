import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        let profileVC = ProfileViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Ana Ekran", image: UIImage(systemName: "house"), tag: 0)
        profileVC.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.circle"), tag: 1)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        viewControllers = [homeNav, profileNav]
        
        // Kullanıcı baş harf ikonu oluştur
        updateProfileTabIcon()
    }
    
    private func updateProfileTabIcon() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            var initialsImage: UIImage?
            
            if let data = snapshot?.data(),
               let name = data["name"] as? String {
                let initials = self.getInitials(from: name)
                initialsImage = self.initialsToImage(initials: initials)
            } else {
                let initials = self.getInitials(from: user.displayName ?? "Kullanıcı")
                initialsImage = self.initialsToImage(initials: initials)
            }
            
            DispatchQueue.main.async {
                if let navControllers = self.viewControllers,
                   navControllers.count > 1,
                   let profileNav = navControllers[1] as? UINavigationController {
                    profileNav.tabBarItem.image = initialsImage?.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
    
    private func getInitials(from name: String) -> String {
        let components = name.split(separator: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.joined()
    }
    
    private func initialsToImage(initials: String) -> UIImage? {
        let label = UILabel()
        label.frame.size = CGSize(width: 30, height: 30) // Tab bar için küçük boyut
        label.text = initials
        label.textAlignment = .center
        label.backgroundColor = .systemGray3
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
