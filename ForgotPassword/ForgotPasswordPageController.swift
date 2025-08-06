import UIKit

class ForgotPasswordViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha:1)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifreyi Güncelle"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let currentPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Mevcut Şifreniz"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false

        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.contentMode = .center
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 24)

        button.addTarget(ForgotPasswordViewController.self, action: #selector(toggleCurrentPasswordVisibility(_:)), for: .touchUpInside)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        container.addSubview(button)
        button.center = container.center

        tf.rightView = container
        tf.rightViewMode = .always
            return tf
        }()

    
    private let newPasswordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Yeni Şifre"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false

        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.contentMode = .center
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 24)

        button.addTarget(ForgotPasswordViewController.self, action: #selector(toggleNewPasswordVisibility(_:)), for: .touchUpInside)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        container.addSubview(button)
        button.center = container.center

        tf.rightView = container
        tf.rightViewMode = .always
            return tf
        }()
    
    private let newPasswordAgainField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Yeni Şifre Tekrar"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false

        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.contentMode = .center
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 24)

        button.addTarget(ForgotPasswordViewController.self, action: #selector(toggleNewPasswordAgainVisibility(_:)), for: .touchUpInside)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        container.addSubview(button)
        button.center = container.center

        tf.rightView = container
        tf.rightViewMode = .always
            return tf
        }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kaydet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        setupLayout()
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            currentPasswordTextField,
            newPasswordField,
            newPasswordAgainField,
            saveButton
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
           
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            
            saveButton.heightAnchor.constraint(equalToConstant: 44)
     ])
    }
    
    @objc private func saveTapped() {
        print("Şifre güncellendi")
        
        let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        present(loginVC, animated: true)

    }
    
    @objc private func toggleCurrentPasswordVisibility(_ sender: UIButton) {
        currentPasswordTextField.isSecureTextEntry.toggle()
        let imageName = currentPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func toggleNewPasswordVisibility(_ sender: UIButton) {
        newPasswordField.isSecureTextEntry.toggle()
        let imageName = newPasswordField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func toggleNewPasswordAgainVisibility(_ sender: UIButton) {
        newPasswordAgainField.isSecureTextEntry.toggle()
        let imageName = newPasswordAgainField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    
    
}
