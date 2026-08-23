//
//  SettingsViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel = SettingsViewModel()
    
    private let containerView = UIView()
    private let themeSwitch = UISwitch()
    private let logoutButton = UIButton(type: .system)
    private let versionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateIn()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Configuración"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        containerView.backgroundColor = .secondarySystemGroupedBackground
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let themeIcon = UIImageView(image: UIImage(systemName: "moon.stars.fill"))
        themeIcon.tintColor = .systemPurple
        
        let themeLabel = UILabel()
        themeLabel.text = "Modo Oscuro"
        themeLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        themeSwitch.isOn = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        themeSwitch.addTarget(self, action: #selector(toggleTheme), for: .valueChanged)
        
        let themeStack = UIStackView(arrangedSubviews: [themeIcon, themeLabel, UIView(), themeSwitch])
        themeStack.axis = .horizontal
        themeStack.spacing = 12
        themeStack.alignment = .center
        
        logoutButton.setTitle("Cerrar Sesión", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius = 14
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        containerView.addSubview(themeStack)
        view.addSubview(logoutButton)
        view.addSubview(versionLabel)
        
        themeStack.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            
            themeStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            themeStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            themeStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            themeStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            themeIcon.widthAnchor.constraint(equalToConstant: 24),
            themeIcon.heightAnchor.constraint(equalToConstant: 24),
            
            logoutButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 54),
            
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func animateIn() {
        containerView.transform = CGAffineTransform(translationX: 0, y: 30)
        containerView.alpha = 0
        logoutButton.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.containerView.transform = .identity
            self.containerView.alpha = 1
            self.logoutButton.alpha = 1
        })
    }
    
    @objc private func toggleTheme(_ sender: UISwitch) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        viewModel.toggleTheme(isDark: sender.isOn)
    }
    
    @objc private func logout() {
        let alert = UIAlertController(title: "Cerrar Sesión", message: "¿Estás seguro de que deseas salir?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Salir", style: .destructive, handler: { _ in
            self.viewModel.logout()
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                sceneDelegate.window?.rootViewController = loginVC
                UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}
