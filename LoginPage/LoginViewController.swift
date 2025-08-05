import UIKit

class LoginViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1) // açık gri ton
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Kullanıcı Adı"
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Şifremi Unuttum?", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Üye değil misin?"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Üye Ol", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let topBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage") // Assets'teki görsel ismi
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(topBackgroundImageView)
        view.sendSubviewToBack(topBackgroundImageView)
        
        setupLayout() //Ekrandaki UI elemanlarını yerleştiren fonksiyonu çağırır.
        
        signUpButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
    }
    
    @objc private func goToRegister() {
        let registerVC = RegistrationViewScreen()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }

    
    private func setupLayout() {
        view.addSubview(containerView)
        
        [usernameTextField, passwordTextField, loginButton, forgotPasswordButton, signUpPromptLabel, signUpButton].forEach {
            containerView.addSubview($0)
        }
        /*view.addSubview(logoImageView)
         view.addSubview(emailTextField)
         view.addSubview(passwordTextField)
         view.addSubview(loginButton)
         view.addSubview(forgotPasswordButton)
         view.addSubview(signUpPromptLabel)
         view.addSubview(signUpButton)*/
        //UI elemanlarını (UIImageView, UITextField, UIButton) ekrana yerleştirmek için view hiyerarşisine ekler.
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            usernameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            usernameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            
            signUpPromptLabel.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 16),
            signUpPromptLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -30),
            
            signUpButton.centerYAnchor.constraint(equalTo: signUpPromptLabel.centerYAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: signUpPromptLabel.trailingAnchor, constant: 5),
            
            signUpButton.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -24),
            
            topBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                topBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                topBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                topBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5) // ekranın yarısı kadar
    
        
        
        ])
        
    }
}
