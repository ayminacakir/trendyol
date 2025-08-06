import UIKit

class CustomAlertView: UIView {
    
    private let messageLabel = UILabel()
    private let okButton = UIButton(type: .system)
    
    init(message: String) {
        super.init(frame: UIScreen.main.bounds)
        setupUI(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(message: String) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        let alertBox = UIView()
        alertBox.backgroundColor = .white
        alertBox.layer.cornerRadius = 12
        alertBox.translatesAutoresizingMaskIntoConstraints = false
        addSubview(alertBox)

        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        okButton.setTitle("Tamam", for: .normal)
        okButton.setTitleColor(.systemOrange, for: .normal)
        okButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        alertBox.addSubview(messageLabel)
        alertBox.addSubview(okButton)

        NSLayoutConstraint.activate([
            alertBox.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alertBox.widthAnchor.constraint(equalToConstant: 280),
            
            messageLabel.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -16),
            
            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            okButton.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -16),
            okButton.centerXAnchor.constraint(equalTo: alertBox.centerXAnchor)
        ])
    }

    @objc private func dismissAlert() {
        self.removeFromSuperview()  //"Tamam" butonuna basıldığında alert kapatılır (ekrandan kaldırılır).
    }

    func show(in view: UIView) {
        view.addSubview(self)
    }
}

