//
//  LoginViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class LoginViewController: UIViewController {
    private let viewModel = AuthViewModel()
    
    private let titleLabel = UILabel()
    private let userTextField = UITextField()
    private let passTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let goToRegisterButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        titleLabel.text = "Proyecto final"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        
        userTextField.placeholder = "Usuario"
        userTextField.borderStyle = .roundedRect
        userTextField.autocapitalizationType = .none
        
        passTextField.placeholder = "Contraseña"
        passTextField.borderStyle = .roundedRect
        passTextField.isSecureTextEntry = true
        
        loginButton.setTitle("Iniciar Sesión", for: .normal)
        loginButton.backgroundColor = .systemIndigo
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        goToRegisterButton.setTitle("¿No tienes cuenta? Regístrate aquí", for: .normal)
        goToRegisterButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, userTextField, passTextField, loginButton, goToRegisterButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            userTextField.heightAnchor.constraint(equalToConstant: 44),
            passTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func handleLogin() {
        viewModel.login(username: userTextField.text ?? "", pass: passTextField.text ?? "") { [weak self] success, message in
            if success {
                let homeVC = HomeViewController()
                let nav = UINavigationController(rootViewController: homeVC)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
            } else {
                self?.showAlert(title: "Error", message: message ?? "Error desconocido")
            }
        }
    }
    
    @objc private func goToRegister() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
