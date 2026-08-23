//
//  LoginViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class LoginViewController: UIViewController {

    
    private let viewModel = AuthViewModel()
    private let backgroundView = UIView()
    private let cardView = UIView()
    private let logoView = UIView()
    private let logoLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let userContainer = UIView()
    private let userIcon = UIImageView()
    private let userTextField = UITextField()
    private let passwordContainer = UIView()
    private let passwordIcon = UIImageView()
    private let passTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let goToRegisterButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupKeyboard()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(
            red: 0.95,
            green: 0.96,
            blue: 1.0,
            alpha: 1.0
        )
        
        setupBackground()
        setupCard()
        setupLogo()
        setupLabels()
        setupUserField()
        setupPasswordField()
        setupLoginButton()
        setupRegisterButton()
        setupStack()
    }
    
    private func setupBackground() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = UIColor(
            red: 0.30,
            green: 0.25,
            blue: 0.85,
            alpha: 1.0
        )
        
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            backgroundView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            backgroundView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            backgroundView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.42
            )
        ])
    }
    
    private func setupCard() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 24
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.12
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowRadius = 20
        
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            cardView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),
            cardView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }
    
    private func setupLogo() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        logoView.backgroundColor = UIColor(
            red: 0.30,
            green: 0.25,
            blue: 0.85,
            alpha: 1.0
        )
        
        logoView.layer.cornerRadius = 32
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "P"
        logoLabel.textColor = .white
        logoLabel.font = .systemFont(
            ofSize: 30,
            weight: .bold
        )
        logoLabel.textAlignment = .center
        logoView.addSubview(logoLabel)
        cardView.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: 28
            ),
            logoView.centerXAnchor.constraint(
                equalTo: cardView.centerXAnchor
            ),
            logoView.widthAnchor.constraint(
                equalToConstant: 64
            ),
            logoView.heightAnchor.constraint(
                equalToConstant: 64
            ),
            
            logoLabel.centerXAnchor.constraint(
                equalTo: logoView.centerXAnchor
            ),
            logoLabel.centerYAnchor.constraint(
                equalTo: logoView.centerYAnchor
            )
        ])
    }
    
    private func setupLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Proyecto Final"
        titleLabel.textColor = UIColor(
            red: 0.12,
            green: 0.12,
            blue: 0.18,
            alpha: 1.0
        )
        titleLabel.font = .systemFont(
            ofSize: 28,
            weight: .bold
        )
        titleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Inicia sesión para continuar"
        subtitleLabel.textColor = .systemGray
        subtitleLabel.font = .systemFont(
            ofSize: 15,
            weight: .regular
        )
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: logoView.bottomAnchor,
                constant: 18
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 20
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -20
            ),
            
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 6
            ),
            subtitleLabel.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 20
            ),
            subtitleLabel.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -20
            )
        ])
    }
    
    private func setupUserField() {
        setupTextFieldContainer(userContainer)
        
        userIcon.image = UIImage(
            systemName: "person.fill"
        )
        userIcon.tintColor = UIColor(
            red: 0.30,
            green: 0.25,
            blue: 0.85,
            alpha: 1.0
        )
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        userIcon.contentMode = .scaleAspectFit
        
        userTextField.placeholder = "Usuario"
        userTextField.borderStyle = .none
        userTextField.backgroundColor = .clear
        userTextField.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        userTextField.autocapitalizationType = .none
        userTextField.autocorrectionType = .no
        userTextField.keyboardType = .default
        userTextField.returnKeyType = .next
        userTextField.textColor = .label
        
        userIcon.setContentHuggingPriority(
            .required,
            for: .horizontal
        )
        
        userContainer.addSubview(userIcon)
        userContainer.addSubview(userTextField)
        
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userIcon.leadingAnchor.constraint(
                equalTo: userContainer.leadingAnchor,
                constant: 15
            ),
            userIcon.centerYAnchor.constraint(
                equalTo: userContainer.centerYAnchor
            ),
            userIcon.widthAnchor.constraint(
                equalToConstant: 20
            ),
            userIcon.heightAnchor.constraint(
                equalToConstant: 20
            ),
            
            userTextField.leadingAnchor.constraint(
                equalTo: userIcon.trailingAnchor,
                constant: 12
            ),
            userTextField.trailingAnchor.constraint(
                equalTo: userContainer.trailingAnchor,
                constant: -15
            ),
            userTextField.topAnchor.constraint(
                equalTo: userContainer.topAnchor
            ),
            userTextField.bottomAnchor.constraint(
                equalTo: userContainer.bottomAnchor
            )
        ])
    }
    
    // MARK: - Password Field
    
    private func setupPasswordField() {
        setupTextFieldContainer(passwordContainer)
        
        passwordIcon.image = UIImage(
            systemName: "lock.fill"
        )
        passwordIcon.tintColor = UIColor(
            red: 0.30,
            green: 0.25,
            blue: 0.85,
            alpha: 1.0
        )
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
        passwordIcon.contentMode = .scaleAspectFit
        
        passTextField.placeholder = "Contraseña"
        passTextField.borderStyle = .none
        passTextField.backgroundColor = .clear
        passTextField.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        passTextField.isSecureTextEntry = true
        passTextField.autocapitalizationType = .none
        passTextField.autocorrectionType = .no
        passTextField.returnKeyType = .done
        passTextField.textColor = .label
        
        passwordIcon.setContentHuggingPriority(
            .required,
            for: .horizontal
        )
        
        passwordContainer.addSubview(passwordIcon)
        passwordContainer.addSubview(passTextField)
        
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passwordIcon.leadingAnchor.constraint(
                equalTo: passwordContainer.leadingAnchor,
                constant: 15
            ),
            passwordIcon.centerYAnchor.constraint(
                equalTo: passwordContainer.centerYAnchor
            ),
            passwordIcon.widthAnchor.constraint(
                equalToConstant: 20
            ),
            passwordIcon.heightAnchor.constraint(
                equalToConstant: 20
            ),
            
            passTextField.leadingAnchor.constraint(
                equalTo: passwordIcon.trailingAnchor,
                constant: 12
            ),
            passTextField.trailingAnchor.constraint(
                equalTo: passwordContainer.trailingAnchor,
                constant: -15
            ),
            passTextField.topAnchor.constraint(
                equalTo: passwordContainer.topAnchor
            ),
            passTextField.bottomAnchor.constraint(
                equalTo: passwordContainer.bottomAnchor
            )
        ])
    }
    
    // MARK: - TextField Container
    
    private func setupTextFieldContainer(_ container: UIView) {
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.backgroundColor = UIColor(
            red: 0.96,
            green: 0.96,
            blue: 0.98,
            alpha: 1.0
        )
        
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray5.cgColor
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(
                equalToConstant: 52
            )
        ])
    }
    
    // MARK: - Login Button
    
    private func setupLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.setTitle(
            "Iniciar Sesión",
            for: .normal
        )
        
        loginButton.setTitleColor(
            .white,
            for: .normal
        )
        
        loginButton.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        
        loginButton.backgroundColor = UIColor(
            red: 0.30,
            green: 0.25,
            blue: 0.85,
            alpha: 1.0
        )
        
        loginButton.layer.cornerRadius = 14
        
        loginButton.layer.shadowColor =
            UIColor.systemIndigo.cgColor
        
        loginButton.layer.shadowOpacity = 0.25
        loginButton.layer.shadowOffset =
            CGSize(width: 0, height: 5)
        loginButton.layer.shadowRadius = 8
        
        loginButton.addTarget(
            self,
            action: #selector(handleLogin),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(
                equalToConstant: 52
            )
        ])
    }
    
    // MARK: - Register Button
    
    private func setupRegisterButton() {
        goToRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        
        let text = "¿No tienes cuenta? "
        let registerText = "Regístrate aquí"
        
        let attributedString = NSMutableAttributedString(
            string: text + registerText
        )
        
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.systemGray,
            range: NSRange(
                location: 0,
                length: text.count
            )
        )
        
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor(
                red: 0.30,
                green: 0.25,
                blue: 0.85,
                alpha: 1.0
            ),
            range: NSRange(
                location: text.count,
                length: registerText.count
            )
        )
        
        attributedString.addAttribute(
            .font,
            value: UIFont.systemFont(
                ofSize: 14,
                weight: .medium
            ),
            range: NSRange(
                location: 0,
                length: attributedString.length
            )
        )
        
        goToRegisterButton.setAttributedTitle(
            attributedString,
            for: .normal
        )
        
        goToRegisterButton.addTarget(
            self,
            action: #selector(goToRegister),
            for: .touchUpInside
        )
    }
    
    // MARK: - Stack
    
    private func setupStack() {
        let stack = UIStackView(
            arrangedSubviews: [
                userContainer,
                passwordContainer,
                loginButton,
                goToRegisterButton
            ]
        )
        
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: 28
            ),
            stack.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 24
            ),
            stack.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -24
            ),
            stack.bottomAnchor.constraint(
                equalTo: cardView.bottomAnchor,
                constant: -28
            )
        ])
    }
    
    // MARK: - Keyboard
    
    private func setupKeyboard() {
        userTextField.delegate = self
        passTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Login
    
    @objc private func handleLogin() {
        view.endEditing(true)
        
        let username = userTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let password = passTextField.text ?? ""
        
        // Validación básica
        if username.isEmpty {
            showAlert(
                title: "Campo vacío",
                message: "Por favor ingresa tu usuario."
            )
            return
        }
        
        if password.isEmpty {
            showAlert(
                title: "Campo vacío",
                message: "Por favor ingresa tu contraseña."
            )
            return
        }
        
        setLoading(true)
        
        viewModel.login(
            username: username,
            pass: password
        ) { [weak self] success, message in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                self.setLoading(false)
                
                if success {
                    let homeVC = HomeViewController()
                    let nav = UINavigationController(
                        rootViewController: homeVC
                    )
                    
                    nav.modalPresentationStyle = .fullScreen
                    
                    self.present(
                        nav,
                        animated: true
                    )
                } else {
                    self.showAlert(
                        title: "Error",
                        message: message ?? "Error desconocido"
                    )
                }
            }
        }
    }
    
    // MARK: - Register
    
    @objc private func goToRegister() {
        let registerVC = RegisterViewController()
        
        navigationController?.pushViewController(
            registerVC,
            animated: true
        )
    }
    
    // MARK: - Loading
    
    private func setLoading(_ loading: Bool) {
        loginButton.isEnabled = !loading
        
        if loading {
            loginButton.setTitle(
                "Iniciando sesión...",
                for: .normal
            )
            
            activityIndicator.startAnimating()
        } else {
            loginButton.setTitle(
                "Iniciar Sesión",
                for: .normal
            )
            
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Alert
    
    private func showAlert(
        title: String,
        message: String
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        present(
            alert,
            animated: true
        )
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        
        if textField == userTextField {
            passTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            handleLogin()
        }
        
        return true
    }
}
