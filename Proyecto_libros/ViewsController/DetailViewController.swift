//
//  DetailViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let favoriteButton = UIButton(type: .system)
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Detalle del Libro"
        
        titleLabel.text = viewModel.title
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.numberOfLines = 0
        
        authorLabel.text = viewModel.authors
        authorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor = .secondaryLabel
        
        descriptionTextView.text = viewModel.description
        descriptionTextView.font = .systemFont(ofSize: 14)
        descriptionTextView.isEditable = false
        
        updateFavoriteButtonStyle()
        favoriteButton.layer.cornerRadius = 12
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        favoriteButton.addTarget(self, action: #selector(handleFavoriteAction), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, descriptionTextView, favoriteButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateFavoriteButtonStyle() {
        if viewModel.isAlreadyFavorite {
            favoriteButton.setTitle("En Favoritos", for: .normal)
            favoriteButton.backgroundColor = .systemGreen
            favoriteButton.setTitleColor(.white, for: .normal)
        } else {
            favoriteButton.setTitle("Agregar a Favoritos", for: .normal)
            favoriteButton.backgroundColor = .systemRed
            favoriteButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc private func handleFavoriteAction() {
        viewModel.addToFavorites()
        updateFavoriteButtonStyle()
    }
}
