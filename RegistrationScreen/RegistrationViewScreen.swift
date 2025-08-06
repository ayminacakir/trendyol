import UIKit

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
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Kullanıcı Adı"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let nameTextField: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Ad Soyad"
            tf.borderStyle = .roundedRect
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
        }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Şifre"
        tf.isSecureTextEntry = true
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
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad() //  //  UIKit sistemi çalıştır
        view.backgroundColor = .orange //  Arka planı hazırla
        setupLayout() // UI bileşenlerini oluştur ve ekrana yerleştir
        
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        alreadyHaveAccountButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

    }
    
    private func setupLayout() {
        view.addSubview(containerView)

        // Alt kısmı yatay olarak grupla
        let bottomStack = UIStackView(arrangedSubviews: [
            registerPromptLabel,
            alreadyHaveAccountButton
        ])
        bottomStack.axis = .horizontal
        bottomStack.spacing = -0
        bottomStack.alignment = .center
        bottomStack.distribution = .fill
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            nameTextField,
            usernameTextField,
            passwordTextField,
            registerButton,
            bottomStack
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 350),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -24),
            
            registerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    
    @objc private func registerTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = CustomAlertView(message: "Ad Soyad, kullanıcı adı ve şifre boş bırakılamaz.")
            alert.show(in: self.view)
            return
        }
        print("Giriş başarılı")
    }
    
    
    @objc private func goToLogin() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
  
        
    
}
