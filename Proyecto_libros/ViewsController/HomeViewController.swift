//
//  HomeViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let viewModel = HomeViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private let emptyStateContainer = UIView()
    private let emptyStateIcon = UIImageView()
    private let emptyStateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
        updateEmptyState(isInitial: true)
    }
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.animateTableReload()
                self?.updateEmptyState(isInitial: false)
            }
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
    }
    
    private func updateEmptyState(isInitial: Bool) {
        let hasResults = !viewModel.searchResults.isEmpty
        let searchText = searchBar.text ?? ""
        
        UIView.animate(withDuration: 0.4, animations: {
            self.emptyStateContainer.alpha = hasResults ? 0 : 1
            self.tableView.alpha = hasResults ? 1 : 0
        })
        
        if !hasResults {
            let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .thin)
            if searchText.isEmpty || isInitial {
                emptyStateIcon.image = UIImage(systemName: "shippingbox", withConfiguration: config)
                emptyStateLabel.text = "¡Busca algo increíble!"
            } else {
                emptyStateIcon.image = UIImage(systemName: "face.dashed", withConfiguration: config)
                emptyStateLabel.text = "No encontramos nada...\nPrueba con otra cosa"
            }
            
            emptyStateIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                self.emptyStateIcon.transform = .identity
            }
        }
    }
    
    private func animateTableReload() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            cell.alpha = 0
            
            UIView.animate(
                withDuration: 0.6,
                delay: 0.05 * Double(index),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: {
                    cell.transform = .identity
                    cell.alpha = 1
                }
            )
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Explorar"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let aboutButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(openAbout))
        navigationItem.rightBarButtonItem = aboutButton
        
        searchBar.delegate = self
        searchBar.placeholder = "Título, autor o ISBN..."
        searchBar.searchBarStyle = .minimal
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.separatorStyle = .none
        
        emptyStateContainer.translatesAutoresizingMaskIntoConstraints = false
        emptyStateIcon.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateIcon.tintColor = .systemGray4
        emptyStateIcon.contentMode = .scaleAspectFit
        
        emptyStateLabel.font = .systemFont(ofSize: 18, weight: .medium)
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        
        emptyStateContainer.addSubview(emptyStateIcon)
        emptyStateContainer.addSubview(emptyStateLabel)
        
        let stack = UIStackView(arrangedSubviews: [searchBar, tableView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        view.addSubview(emptyStateContainer)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateContainer.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateContainer.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -50),
            emptyStateContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emptyStateIcon.topAnchor.constraint(equalTo: emptyStateContainer.topAnchor),
            emptyStateIcon.centerXAnchor.constraint(equalTo: emptyStateContainer.centerXAnchor),
            emptyStateIcon.heightAnchor.constraint(equalToConstant: 100),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateIcon.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateContainer.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateContainer.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateContainer.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95).translatedBy(x: 0, y: 10)
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBooks(query: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.clearSearch()
            updateEmptyState(isInitial: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        let book = viewModel.searchResults[indexPath.row]
        cell.configure(with: book)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.searchResults[indexPath.row]
        let detailVM = DetailViewModel(book: book, homeViewModel: viewModel)
        let detailVC = DetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func openAbout() {
        let message = "\nEQUIPO DE DESARROLLO\n\n Deborah Elena Vela Villamonte\n Kevin Arnold Eca Pilcon\n Cristopher Joau Morales Sajami \n Roy Heberth Velarde Laines"
        let alert = UIAlertController(title: "Acerca de la App", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        alert.view.tintColor = .systemIndigo
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
