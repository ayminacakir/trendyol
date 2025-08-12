import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewScreen: UIViewController {
    
    private let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0.95, alpha: 1)
            view.layer.cornerRadius = 16
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Üye Ol"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "E-mail"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let nameTextField: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Ad Soyad"
            tf.borderStyle = .roundedRect
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.autocapitalizationType = .none
            return tf
        }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Şifre"
        tf.isSecureTextEntry = true
        tf.textContentType = .oneTimeCode 
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    
    private let registerButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Üye Ol", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemOrange
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    private let registerPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Zaten hesabın var mı?"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad() //  //  UIKit sistemi çalıştır
        view.backgroundColor = .orange //  Arka planı hazırla
        setupLayout() // UI bileşenlerini oluştur ve ekrana yerleştir
        
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        alreadyHaveAccountButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)


    }
   
private func setupLayout() {
 view.addSubview(containerView)
 
 [titleLabel,
 nameTextField,
 emailTextField,
 passwordTextField,
 registerButton,
 registerPromptLabel,
 alreadyHaveAccountButton].forEach {
     containerView.addSubview($0)
 }

 
 NSLayoutConstraint.activate([
     containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
     containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
     containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
     containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
 ])
 
 NSLayoutConstraint.activate([
 titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
 titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
 titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
 titleLabel.heightAnchor.constraint(equalToConstant: 44),
     
 nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
 nameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
 nameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
 nameTextField.heightAnchor.constraint(equalToConstant: 44),
 
 emailTextField.topAnchor.constraint(equalTo:  nameTextField.bottomAnchor, constant: 16),
 emailTextField.leadingAnchor.constraint(equalTo:  nameTextField.leadingAnchor),
 emailTextField.trailingAnchor.constraint(equalTo:  nameTextField.trailingAnchor),
 emailTextField.heightAnchor.constraint(equalToConstant: 44),
 
 passwordTextField.topAnchor.constraint(equalTo:  emailTextField.bottomAnchor, constant: 16),
 passwordTextField.leadingAnchor.constraint(equalTo:  emailTextField.leadingAnchor),
 passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
 passwordTextField.heightAnchor.constraint(equalToConstant: 44),
     
 registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
 registerButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
 registerButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
 registerButton.heightAnchor.constraint(equalToConstant: 44),
     
     
 registerPromptLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
 registerPromptLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -30),
     
 alreadyHaveAccountButton.centerYAnchor.constraint(equalTo: registerPromptLabel.centerYAnchor),
 alreadyHaveAccountButton.leadingAnchor.constraint(equalTo: registerPromptLabel.trailingAnchor, constant: 5),
     
 alreadyHaveAccountButton.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -24),

 
 
 ])
 
}
    
    @objc private func registerTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = CustomAlertView(title: "Uyarı!", message: "Ad Soyad, e-mail ve şifre boş bırakılamaz.")
            alert.show(in: self.view)
            return
        }

        // Firebase Authentication ile kullanıcıyı oluştur
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let alert = CustomAlertView(title: "Hata", message: "Kayıt başarısız: \(error.localizedDescription)")
                alert.show(in: self.view)
                return
            }

            guard let uid = result?.user.uid else { return }

            // Firestore'a kullanıcı bilgilerini kaydet
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "uid": uid,
                "name": name,
                "email": email,
                "createdAt": Timestamp()
            ]

            db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    let alert = CustomAlertView(title: "Hata", message: "Veri kaydı başarısız: \(error.localizedDescription)")
                    alert.show(in: self.view)
                } else {
                    // Başarılı kayıt uyarısı göster
                    let alert = CustomAlertView(title: "Başarılı", message: "Kayıt başarılı! Giriş ekranına yönlendiriliyorsunuz.")
                    alert.show(in: self.view)

                    // 1.5 saniye sonra login ekranına geç
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.goToLogin()
                        
                        print("Firestore kayıt başarılı.")

                    }
                }
            }
        }
    }

    
    
    @objc private func goToLogin() {
        print("Giriş ekranına yönlendiriliyor...")
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
}
