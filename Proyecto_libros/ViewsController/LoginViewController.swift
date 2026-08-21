//
//  LoginViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//
import UIKit

final class RegisterViewController: UIViewController {
    
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
    
    private let registerButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
 
    private let primaryColor = UIColor(
        red: 0.30,
        green: 0.25,
        blue: 0.85,
        alpha: 1.0
    )
    
  
    
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
        
        title = "Registro de Usuario"
        
        setupBackground()
        setupCard()
        setupLogo()
        setupLabels()
        setupUserField()
        setupPasswordField()
        setupRegisterButton()
        setupBackButton()
        setupStack()
    }
    
    
    private func setupBackground() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = primaryColor
        
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
        cardView.layer.shadowOffset = CGSize(
            width: 0,
            height: 8
        )
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
        
        logoView.backgroundColor = primaryColor
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
        
        titleLabel.text = "Crear Cuenta"
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
        
        subtitleLabel.text = "Completa los datos para registrarte"
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
        userIcon.tintColor = primaryColor
        userIcon.contentMode = .scaleAspectFit
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        
        userTextField.placeholder = "Nuevo Usuario"
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
        
        userContainer.addSubview(userIcon)
        userContainer.addSubview(userTextField)
        
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
    

    
    private func setupPasswordField() {
        setupTextFieldContainer(passwordContainer)
        
        passwordIcon.image = UIImage(
            systemName: "lock.fill"
        )
        passwordIcon.tintColor = primaryColor
        passwordIcon.contentMode = .scaleAspectFit
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
        
        passTextField.placeholder =
            "Contrasena"
        
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
        
        passwordContainer.addSubview(passwordIcon)
        passwordContainer.addSubview(passTextField)
        
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
    
    
    private func setupTextFieldContainer(
        _ container: UIView
    ) {
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.backgroundColor = UIColor(
            red: 0.96,
            green: 0.96,
            blue: 0.98,
            alpha: 1.0
        )
        
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor =
            UIColor.systemGray5.cgColor
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(
                equalToConstant: 52
            )
        ])
    }
    
    
    private func setupRegisterButton() {
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        registerButton.setTitle(
            "Registrarse",
            for: .normal
        )
        
        registerButton.setTitleColor(
            .white,
            for: .normal
        )
        
        registerButton.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        
        registerButton.backgroundColor = primaryColor
        registerButton.layer.cornerRadius = 14
        
        registerButton.layer.shadowColor =
            UIColor.systemIndigo.cgColor
        
        registerButton.layer.shadowOpacity = 0.25
        registerButton.layer.shadowOffset =
            CGSize(width: 0, height: 5)
        registerButton.layer.shadowRadius = 8
        
        registerButton.addTarget(
            self,
            action: #selector(handleRegister),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([
            registerButton.heightAnchor.constraint(
                equalToConstant: 52
            )
        ])
    }
    
    
    private func setupBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        let text = "¿Ya tienes una cuenta? "
        let loginText = "Inicia sesión"
        
        let attributedString = NSMutableAttributedString(
            string: text + loginText
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
            value: primaryColor,
            range: NSRange(
                location: text.count,
                length: loginText.count
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
        
        backButton.setAttributedTitle(
            attributedString,
            for: .normal
        )
        
        backButton.addTarget(
            self,
            action: #selector(goBackToLogin),
            for: .touchUpInside
        )
    }

    
    private func setupStack() {
        let stack = UIStackView(
            arrangedSubviews: [
                userContainer,
                passwordContainer,
                registerButton,
                backButton
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
    

    
    @objc private func handleRegister() {
        view.endEditing(true)
        
        let username = userTextField.text?
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""
        
        let password = passTextField.text ?? ""
        
        if username.isEmpty {
            showAlert(
                title: "Campo vacío",
                message: "Por favor ingresa un usuario."
            )
            return
        }
        
        if password.isEmpty {
            showAlert(
                title: "Campo vacío",
                message: "Por favor ingresa una contraseña."
            )
            return
        }
        
        viewModel.register(
            username: username,
            pass: password
        ) { [weak self] success, message in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                if success {
                    let alert = UIAlertController(
                        title: "Éxito",
                        message: "Usuario registrado correctamente.",
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default
                        ) { [weak self] _ in
                            self?.navigationController?
                                .popViewController(
                                    animated: true
                                )
                        }
                    )
                    
                    self.present(
                        alert,
                        animated: true
                    )
                } else {
                    self.showAlert(
                        title: "Validación",
                        message: message ?? "Error"
                    )
                }
            }
        }
    }
    
    
    @objc private func goBackToLogin() {
        navigationController?.popViewController(
            animated: true
        )
    }
    
    
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


extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        
        if textField == userTextField {
            passTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            handleRegister()
        }
        
        return true
    }
}
