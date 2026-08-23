//
//  DetailViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//

import UIKit
import SafariServices

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerContainer = UIView()
    private let backgroundImageView = UIImageView()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
    private let gradientOverlay = CAGradientLayer()
    private let transitionGradient = CAGradientLayer()
    
    private let bookImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let ratingStack = UIStackView()
    private let ratingsCountLabel = UILabel()
    private let shareButton = UIButton(type: .system)
    
    private let infoCard = UIView()
    private let metaDataStack = UIStackView()
    private let descriptionLabel = UILabel()
    private let buttonsStack = UIStackView()
    private let previewButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)
    
    private var otherBooksCollectionView: UICollectionView!
    private var similarBooksCollectionView: UICollectionView!
    
    private lazy var descriptionHeader = createSectionHeader(title: "Descripción", icon: "doc.text.fill")
    private lazy var otherBooksHeader = createSectionHeader(title: "Otros libros del autor", icon: "person.2.fill")
    private lazy var similarBooksHeader = createSectionHeader(title: "Te podría interesar", icon: "books.vertical.fill")
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupUI()
        loadData()
        
        viewModel.onDataLoaded = { [weak self] in
            guard let self = self else { return }
            self.otherBooksCollectionView.reloadData()
            self.similarBooksCollectionView.reloadData()
            self.updateSectionsVisibility()
        }
        viewModel.fetchRelatedContent()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientOverlay.frame = headerContainer.bounds
        transitionGradient.frame = CGRect(x: 0, y: headerContainer.frame.height - 120, width: view.frame.width, height: 120)
    }

    private func updateSectionsVisibility() {
        let hasOther = !viewModel.otherBooks.isEmpty
        let hasSimilar = !viewModel.similarBooks.isEmpty
        let descText = viewModel.description
        let hasDesc = !(descText.isEmpty || descText == "Sin descripción disponible.")

        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
            self.bookImageView.transform = .identity
            self.bookImageView.alpha = 1
            
            self.descriptionHeader.alpha = hasDesc ? 1 : 0
            self.descriptionHeader.transform = hasDesc ? .identity : CGAffineTransform(translationX: -20, y: 0)
            self.descriptionLabel.alpha = hasDesc ? 1 : 0
            
            self.otherBooksHeader.alpha = hasOther ? 1 : 0
            self.otherBooksHeader.transform = hasOther ? .identity : CGAffineTransform(translationX: -20, y: 0)
            self.otherBooksCollectionView.alpha = hasOther ? 1 : 0
            
            self.similarBooksHeader.alpha = hasSimilar ? 1 : 0
            self.similarBooksHeader.transform = hasSimilar ? .identity : CGAffineTransform(translationX: -20, y: 0)
            self.similarBooksCollectionView.alpha = hasSimilar ? 1 : 0
            
            self.view.layoutIfNeeded()
        })
    }

    private func setupCollectionViews() {
        let createLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 110, height: 160)
            layout.minimumLineSpacing = 15
            return layout
        }
        
        otherBooksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        similarBooksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        [otherBooksCollectionView, similarBooksCollectionView].forEach { cv in
            cv?.delegate = self
            cv?.dataSource = self
            cv?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            cv?.backgroundColor = .clear
            cv?.showsHorizontalScrollIndicator = false
            cv?.alpha = 0
        }
    }

    private func createSectionHeader(title: String, icon: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fill
        
        stack.alpha = 0
        stack.transform = CGAffineTransform(translationX: -20, y: 0)
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let imageView = UIImageView(image: UIImage(systemName: icon, withConfiguration: config))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        let spacer = UIView()
        stack.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return stack
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        scrollView.contentInsetAdjustmentBehavior = .never
        
        headerContainer.clipsToBounds = true
        backgroundImageView.contentMode = .scaleAspectFill
        gradientOverlay.colors = [UIColor.black.withAlphaComponent(0.1).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        transitionGradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        
        bookImageView.contentMode = .scaleAspectFit
        bookImageView.layer.cornerRadius = 10
        bookImageView.clipsToBounds = true
        bookImageView.alpha = 0
        bookImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        
        authorLabel.font = .systemFont(ofSize: 18, weight: .medium)
        authorLabel.textColor = .lightGray
        
        ratingsCountLabel.font = .systemFont(ofSize: 14, weight: .bold)
        ratingsCountLabel.textColor = .white.withAlphaComponent(0.8)
        
        setupRatingStars()
        
        infoCard.backgroundColor = .systemBackground
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.alpha = 0
        
        setupBadges()
        setupButtons()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerContainer)
        headerContainer.addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurEffectView)
        headerContainer.layer.addSublayer(gradientOverlay)
        headerContainer.layer.addSublayer(transitionGradient)
        headerContainer.addSubview(bookImageView)
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(authorLabel)
        headerContainer.addSubview(ratingStack)
        
        contentView.addSubview(infoCard)
        let mainStack = UIStackView(arrangedSubviews: [
            metaDataStack, buttonsStack, descriptionHeader, descriptionLabel, otherBooksHeader, otherBooksCollectionView, similarBooksHeader, similarBooksCollectionView
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.setCustomSpacing(10, after: descriptionHeader)
        mainStack.setCustomSpacing(10, after: otherBooksHeader)
        mainStack.setCustomSpacing(10, after: similarBooksHeader)
        infoCard.addSubview(mainStack)
        
        [scrollView, contentView, headerContainer, backgroundImageView, blurEffectView, bookImageView, titleLabel, authorLabel, ratingStack, infoCard, mainStack, otherBooksCollectionView, similarBooksCollectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 480),
            
            backgroundImageView.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            
            bookImageView.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            bookImageView.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 65),
            bookImageView.heightAnchor.constraint(equalToConstant: 230),
            
            titleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            ratingStack.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            infoCard.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -20),
            infoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            mainStack.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -30),
            
            otherBooksCollectionView.heightAnchor.constraint(equalToConstant: 170),
            similarBooksCollectionView.heightAnchor.constraint(equalToConstant: 170)
        ])
    }

    private func setupRatingStars() {
        ratingStack.axis = .horizontal
        ratingStack.spacing = 4
        ratingStack.alignment = .center
        for i in 1...5 {
            let star = UIImageView(image: UIImage(systemName: Double(i) <= viewModel.rating ? "star.fill" : "star"))
            star.tintColor = .systemOrange
            ratingStack.addArrangedSubview(star)
        }
        ratingStack.addArrangedSubview(ratingsCountLabel)
    }

    private func setupBadges() {
        metaDataStack.axis = .horizontal
        metaDataStack.spacing = 8
        if !viewModel.categoriesText.isEmpty { metaDataStack.addArrangedSubview(createBadge(text: viewModel.categoriesText, color: .systemBlue)) }
        if !viewModel.languageText.isEmpty { metaDataStack.addArrangedSubview(createBadge(text: viewModel.languageText, color: .systemRed)) }
        if !viewModel.pageCountText.isEmpty { metaDataStack.addArrangedSubview(createBadge(text: viewModel.pageCountText, color: .systemGray5, textColor: .label)) }
        metaDataStack.addArrangedSubview(UIView())
    }

    private func createBadge(text: String, color: UIColor, textColor: UIColor = .white) -> UIView {
        let label = UILabel()
        label.text = " \(text.uppercased()) "
        label.font = .systemFont(ofSize: 11, weight: .black)
        label.backgroundColor = color
        label.textColor = textColor
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }

    private func setupButtons() {
        previewButton.setTitle(" Leer Previa", for: .normal)
        previewButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        previewButton.backgroundColor = .systemBlue
        previewButton.tintColor = .white
        previewButton.layer.cornerRadius = 14
        previewButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        previewButton.addTarget(self, action: #selector(openPreview), for: .touchUpInside)

        favoriteButton.layer.cornerRadius = 14
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        favoriteButton.addTarget(self, action: #selector(handleFavoriteAction), for: .touchUpInside)
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.backgroundColor = .systemGray5
        shareButton.tintColor = .label
        shareButton.layer.cornerRadius = 14
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
    
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 10
        buttonsStack.distribution = .fill
        
        buttonsStack.addArrangedSubview(previewButton)
        buttonsStack.addArrangedSubview(favoriteButton)
        buttonsStack.addArrangedSubview(shareButton)
        
        NSLayoutConstraint.activate([
            buttonsStack.heightAnchor.constraint(equalToConstant: 54),
            shareButton.widthAnchor.constraint(equalToConstant: 54),
            previewButton.widthAnchor.constraint(equalTo: favoriteButton.widthAnchor)
        ])
        
        updateFavoriteButtonStyle()
    }

    private func loadData() {
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.authors
        descriptionLabel.text = viewModel.description
        ratingsCountLabel.text = viewModel.book.volumeInfo.ratingsCount != nil ? "(\(viewModel.book.volumeInfo.ratingsCount!))" : ""
        
        if let url = viewModel.thumbnailURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.bookImageView.image = img
                        self?.backgroundImageView.image = img
                    }
                }
            }.resume()
        }
        updateFavoriteButtonStyle()
        updateSectionsVisibility()
    }

    @objc private func openPreview() {
        guard let url = viewModel.previewURL else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
    
    @objc private func handleShare() {
        guard let url = viewModel.previewURL else { return }
        let activityVC = UIActivityViewController(activityItems: ["Mira este libro: \(viewModel.title)", url], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    @objc private func handleFavoriteAction() {
        let isFav = viewModel.isAlreadyFavorite
        
        if isFav {
            UIView.animate(withDuration: 0.3, animations: {
                self.favoriteButton.backgroundColor = .systemOrange
                self.favoriteButton.setTitle("Quitando", for: .normal)
                self.favoriteButton.setImage(UIImage(systemName: "face.dashed"), for: .normal)
                self.favoriteButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                self.viewModel.toggleFavorite()
                self.updateFavoriteButtonStyle()
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        } else {
            viewModel.toggleFavorite()
            updateFavoriteButtonStyle()
            favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.favoriteButton.transform = .identity
            })
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }

    private func updateFavoriteButtonStyle() {
        let isFav = viewModel.isAlreadyFavorite
        
        UIView.transition(with: favoriteButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.favoriteButton.setTitle(isFav ? " Añadido" : " Añadir", for: .normal)
            self.favoriteButton.setImage(UIImage(systemName: isFav ? "heart.fill" : "heart"), for: .normal)
            self.favoriteButton.backgroundColor = isFav ? .systemGreen : .systemRed
            self.favoriteButton.tintColor = .white
            self.favoriteButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.3) {
            self.shareButton.isHidden = !isFav
            self.buttonsStack.layoutIfNeeded()
        }
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == otherBooksCollectionView ? viewModel.otherBooks.count : viewModel.similarBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let imgView = UIImageView(frame: cell.contentView.bounds)
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        imgView.backgroundColor = .systemGray6
        cell.contentView.addSubview(imgView)
        
        let book = collectionView == otherBooksCollectionView ? viewModel.otherBooks[indexPath.item] : viewModel.similarBooks[indexPath.item]
        if let thumbStr = book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http:", with: "https:"), let url = URL(string: thumbStr) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data { DispatchQueue.main.async { imgView.image = UIImage(data: data) } }
            }.resume()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = collectionView == otherBooksCollectionView ? viewModel.otherBooks : viewModel.similarBooks
        guard let homeVM = viewModel.homeViewModel else { return }
        let nextVC = DetailViewController(viewModel: DetailViewModel(book: items[indexPath.item], homeViewModel: homeVM))
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
