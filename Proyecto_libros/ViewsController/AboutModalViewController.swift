//
//  AboutModalViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class AboutModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let iconImageView = UIImageView(image: UIImage(systemName: "person.3.fill"))
        iconImageView.tintColor = .systemIndigo
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([iconImageView.heightAnchor.constraint(equalToConstant: 60)])
        
        let titleLabel = UILabel()
        titleLabel.text = "Acerca del Proyecto"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        
        let membersLabel = UILabel()
        membersLabel.text = "Integrantes:\n Kevin Arnold Eca Pilcon\n Jazmin Anabel Herhuay Huamán\n Cristopher Joau Morales Sajami\n Deborah Elena Vela Villamonte\n Roy Heberth Velarde Laines"
        membersLabel.numberOfLines = 0
        membersLabel.font = .systemFont(ofSize: 15)
        membersLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, membersLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}
