import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

class ProfileViewController: UIViewController {
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.setImage(UIImage(systemName: "gearshape.fill", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // ✏️ Kalem butonu
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "pencil.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.addSubview(settingsButton)
        view.addSubview(editButton)
        
        setupLayout()
        loadUserInfo()
        
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            editButton.widthAnchor.constraint(equalToConstant: 24),
            editButton.heightAnchor.constraint(equalToConstant: 24),
            editButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4),
            editButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 120),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
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
            
            if let data = snapshot?.data() {
                // İsim
                let name = data["name"] as? String ?? user.displayName ?? "Kullanıcı"
                DispatchQueue.main.async {
                    self.nameLabel.text = name
                }
                
                // Firestore'daki fotoURL varsa göster
                if let photoURLString = data["photoURL"] as? String, let url = URL(string: photoURLString) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.profileImageView.image = image
                            }
                        } else {
                            DispatchQueue.main.async {
                                let initials = self.getInitials(from: name)
                                self.profileImageView.image = self.initialsToImage(initials: initials)
                            }
                        }
                    }.resume()
                } else {
                    // Foto yoksa baş harfleri göster
                    DispatchQueue.main.async {
                        let initials = self.getInitials(from: name)
                        self.profileImageView.image = self.initialsToImage(initials: initials)
                    }
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
        UIGraphicsBeginImageContext(label.frame.size)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    @objc private func logoutTapped() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true)
        } catch {
            print("Çıkış hatası: \(error.localizedDescription)")
        }
    }
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .overFullScreen
        settingsVC.modalTransitionStyle = .crossDissolve
        present(settingsVC, animated: true)
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let user = Auth.auth().currentUser else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("profileImages/\(user.uid).jpg")
        
        fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                return
            }
            
            fileRef.downloadURL { url, error in
                if let url = url {
                    print("Download URL: \(url.absoluteString)")
                    
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Profil foto güncellenemedi: \(error)")
                        } else {
                            print("Profil foto güncellendi")
                        }
                    }
                    
                    let db = Firestore.firestore()
                    db.collection("users").document(user.uid).updateData([
                        "photoURL": url.absoluteString
                    ])
                }
            }
        }
    }
    
    // ✏️ Kalem butonuna tıklanınca
    @objc private func editButtonTapped() {
        let alert = UIAlertController(title: "Profil Fotoğrafı", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Profil resmini güncelle", style: .default, handler: { _ in
            self.openPhotoPicker()
        }))
        
        alert.addAction(UIAlertAction(title: "Mevcut resmi kaldır", style: .destructive, handler: { _ in
            self.removeProfileImage()
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func removeProfileImage() {
        guard let user = Auth.auth().currentUser else { return }
        let storageRef = Storage.storage().reference().child("profileImages/\(user.uid).jpg")
        
        // Storage'dan sil
        storageRef.delete { error in
            if let error = error {
                print("Storage silme hatası: \(error.localizedDescription)")
            } else {
                print("Profil foto Storage'dan silindi")
            }
        }
        
        // Firestore'daki URL'yi sil
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "photoURL": FieldValue.delete()
        ])
        
        // Firebase Auth profilini temizle
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = nil
        changeRequest.commitChanges { error in
            if let error = error {
                print("Foto silme hatası: \(error.localizedDescription)")
            }
        }
        
        // UI güncelle
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let data = snapshot?.data(), let name = data["name"] as? String {
                let initials = self.getInitials(from: name)
                DispatchQueue.main.async {
                    self.profileImageView.image = self.initialsToImage(initials: initials)
                }
            } else {
                DispatchQueue.main.async {
                    self.profileImageView.image = nil
                }
            }
        }
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func openPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                guard let self = self else { return }
                if let uiImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self.profileImageView.image = uiImage
                        self.uploadProfileImage(uiImage)
                    }
                }
            }
        }
    }
}
