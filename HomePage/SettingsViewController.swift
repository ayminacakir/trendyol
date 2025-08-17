import UIKit

class SettingsViewController: UIViewController {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let darkModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark Mode"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let darkModeSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4) // arkayı karartıyor
        
        setupUI()
        loadDarkModeSetting()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(darkModeLabel)
        containerView.addSubview(darkModeSwitch)
        containerView.addSubview(forgotPasswordButton)
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            
                darkModeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 90),
                darkModeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                
                darkModeSwitch.centerYAnchor.constraint(equalTo: darkModeLabel.centerYAnchor),
                darkModeSwitch.leadingAnchor.constraint(equalTo: darkModeLabel.trailingAnchor, constant: 20),
                
                forgotPasswordButton.topAnchor.constraint(equalTo: darkModeSwitch.bottomAnchor, constant: 20),
                   forgotPasswordButton.leadingAnchor.constraint(equalTo: darkModeLabel.leadingAnchor)
        ])
        
        darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged(_:)), for: .valueChanged)
    }
    
    
    @objc private func darkModeSwitchChanged(_ sender: UISwitch) {
        let isDarkMode = sender.isOn
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        applyTheme(isDarkMode: isDarkMode)
    }
   
    private func loadDarkModeSetting() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        darkModeSwitch.isOn = isDarkMode
        applyTheme(isDarkMode: isDarkMode)
    }

    private func applyTheme(isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }

    @objc private func dismissOverlay() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func forgotPasswordTapped() {
        let forgotPasswordVC = ForgotPasswordViewController()
        forgotPasswordVC.modalPresentationStyle = .fullScreen
        self.present(forgotPasswordVC, animated: true, completion: nil)
    }



}
