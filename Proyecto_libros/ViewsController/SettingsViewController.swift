//
//  SettingsViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel = SettingsViewModel()
    private let themeSwitch = UISwitch()
    private let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Configuración"
        
        let themeLabel = UILabel()
        themeLabel.text = "Modo Oscuro"
        themeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        themeSwitch.isOn = traitCollection.userInterfaceStyle == .dark
        themeSwitch.addTarget(self, action: #selector(toggleTheme), for: .valueChanged)
        
        let themeStack = UIStackView(arrangedSubviews: [themeLabel, themeSwitch])
        themeStack.axis = .horizontal
        themeStack.distribution = .equalSpacing
        
        logoutButton.setTitle("Cerrar Sesión", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        let mainStack = UIStackView(arrangedSubviews: [themeStack, logoutButton])
        mainStack.axis = .vertical
        mainStack.spacing = 30
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func toggleTheme(_ sender: UISwitch) {
        viewModel.toggleTheme(isDark: sender.isOn)
    }
    
    @objc private func logout() {
        viewModel.logout()
        view.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        view.window?.makeKeyAndVisible()
    }
}
