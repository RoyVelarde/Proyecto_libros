//
//  RegisterViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class RegisterViewController: UIViewController {
    private let viewModel = AuthViewModel()
    
    private let titleLabel = UILabel()
    private let userTextField = UITextField()
    private let passTextField = UITextField()
    private let registerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Registro de Usuario"
        
        titleLabel.text = "Crear Cuenta"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textAlignment = .center
        
        userTextField.placeholder = "Nuevo Usuario"
        userTextField.borderStyle = .roundedRect
        userTextField.autocapitalizationType = .none
        
        passTextField.placeholder = "Mín. 6 car., 1 Mayús, 1 minús, 1 núm"
        passTextField.borderStyle = .roundedRect
        passTextField.isSecureTextEntry = true
        
        registerButton.setTitle("Registrarse", for: .normal)
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, userTextField, passTextField, registerButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            userTextField.heightAnchor.constraint(equalToConstant: 44),
            passTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func handleRegister() {
        viewModel.register(username: userTextField.text ?? "", pass: passTextField.text ?? "") { [weak self] success, message in
            if success {
                let alert = UIAlertController(title: "Éxito", message: "Usuario registrado correctamente.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self?.navigationController?.popViewController(animated: true)
                })
                self?.present(alert, animated: true)
            } else {
                self?.showAlert(title: "Validación", message: message ?? "Error")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
