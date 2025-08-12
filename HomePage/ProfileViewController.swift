import UIKit
import FirebaseAuth
import FirebaseFirestore


class ProfileViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill // Resmi en-boy oranını koruyarak görünümü dolduracak şekilde büyütür.
        iv.clipsToBounds = true //UIImageView'in sınırları dışında kalan kısımların görünmesini engeller.
        iv.layer.cornerRadius = 40
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Çıkış Yap", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profil"
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(logoutButton)
        
        setupLayout()
        loadUserInfo()
       
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 120),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        let userRef = db.collection("users").document(user.uid)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Firestore kullanıcı verisi okunamadı: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.nameLabel.text = user.displayName ?? "Kullanıcı"
                }
                return
            }
            
            if let data = snapshot?.data(), let name = data["name"] as? String {
                DispatchQueue.main.async {
                    self.nameLabel.text = name
                    
                    if let photoURL = user.photoURL {
                        URLSession.shared.dataTask(with: photoURL) { data, _, _ in
                            if let data = data {
                                DispatchQueue.main.async {
                                    self.profileImageView.image = UIImage(data: data)
                                }
                            }
                        }.resume()
                    } else {
                        let initials = self.getInitials(from: name)
                        self.profileImageView.image = self.initialsToImage(initials: initials)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.nameLabel.text = user.displayName ?? "Kullanıcı"
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
            label.frame.size = CGSize(width: 80, height: 80)
            label.text = initials
            label.textAlignment = .center
            label.backgroundColor = .systemGray3
            label.font = UIFont.boldSystemFont(ofSize: 32)
            label.textColor = .white
            UIGraphicsBeginImageContext(label.frame.size) //Bir görsel çizim alanı başlatır.
            label.layer.render(in: UIGraphicsGetCurrentContext()!) //Label’in görünümünü mevcut grafik context içine çizer.
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext() //Grafik çizim işlemini kapatır (bellek temizliği için gerekli)
            return img
        }
    
    @objc private func logoutTapped() {
            do {
                try Auth.auth().signOut()
                dismiss(animated: true) // giriş ekranına dön
            } catch {
                print("Çıkış hatası: \(error.localizedDescription)")
            }
        }
}

