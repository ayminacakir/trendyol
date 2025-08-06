import UIKit
import FirebaseAuth

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
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "E-mail"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: "person"))
        icon.tintColor = .gray
        icon.contentMode = .center
        icon.frame = CGRect(x: 0, y: 0, width: 30, height: 24)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        container.addSubview(icon)
        icon.center = container.center // Ortalamak için

        tf.rightView = container
        tf.rightViewMode = .always

        return tf
    }()

    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Şifre"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false

        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.contentMode = .center
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 24)

        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        container.addSubview(button)
        button.center = container.center

        tf.rightView = container
        tf.rightViewMode = .always

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
        forgotPasswordButton.addTarget(self, action: #selector(goToForgotPasswordPage), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

    }
    
    @objc private func goToRegister() {
        let registerVC = RegistrationViewScreen()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }
    
    @objc private func goToForgotPasswordPage() {
        let passwordVC = ForgotPasswordViewController()
        passwordVC.modalPresentationStyle = .fullScreen
        present(passwordVC, animated: true)
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
   
    
    @objc private func loginTapped() { //giriş butonuna tıklandığında çalışır.
        guard let username = emailTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = CustomAlertView(message: "Kullanıcı adı ve şifre boş bırakılamaz.")
            alert.show(in: self.view)
            return
        }
       
        //FireBase ile Giriş
        Auth.auth().signIn(withEmail: username, password: password) { authResult , error in
            
            if let error = error {
                
                let alert = CustomAlertView(message:"Giriş başarısız: \(error.localizedDescription)")
                alert.show(in: self.view)
                return
            }
            let alert = CustomAlertView(message: "Giriş başarılı.Hoş geldiniz!")
            alert.show(in: self.view)
            
        }
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        
        [emailTextField, passwordTextField, loginButton, forgotPasswordButton, signUpPromptLabel, signUpButton].forEach {
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
            emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
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
