//
//  BookTableViewCell.swift
//  Proyecto_libros
//
//  Created by XCODE on 23/08/26.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let isbnLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 4
        thumbnailImageView.backgroundColor = .systemGray6
        thumbnailImageView.tintColor = .systemGray
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        
        isbnLabel.font = .systemFont(ofSize: 13)
        isbnLabel.textColor = .secondaryLabel
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, isbnLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(textStack)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 45),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 65),
            
            textStack.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 85)
        ])
    }
    
    func configure(with book: BookItem) {
        titleLabel.text = book.volumeInfo.title
        
        let isbn = book.volumeInfo.industryIdentifiers?.first?.identifier ?? "Sin ISBN"
        isbnLabel.text = "ISBN: \(isbn)"
        
        thumbnailImageView.image = UIImage(systemName: "book.closed.fill")
        
        if let thumbStr = book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http:", with: "https:"),
           let url = URL(string: thumbStr) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.thumbnailImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
}
