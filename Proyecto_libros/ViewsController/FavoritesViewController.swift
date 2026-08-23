//
//  FavoritesViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 23/08/26.
//

import UIKit

final class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let viewModel = FavoritesViewModel()
    private let homeViewModel = HomeViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private let emptyStateContainer = UIView()
    private let emptyStateIcon = UIImageView()
    private let emptyStateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshFavorites()
        animateTableReload()
        updateEmptyState()
    }
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
    }

    private func updateEmptyState() {
        let hasResults = !viewModel.filteredFavorites.isEmpty
        let isSearching = !(searchBar.text?.isEmpty ?? true)
        
        UIView.animate(withDuration: 0.4) {
            self.emptyStateContainer.alpha = hasResults ? 0 : 1
            self.tableView.alpha = hasResults ? 1 : 0
        }
        
        if !hasResults {
            let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .thin)
            
            if isSearching {
                emptyStateIcon.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
                emptyStateLabel.text = "No hay coincidencias en tu biblioteca"
            } else {
                emptyStateIcon.image = UIImage(systemName: "heart.circle", withConfiguration: config)
                emptyStateLabel.text = "Tu lista está vacía\nAgrega libros para verlos aquí"
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
        
        for (index, cell) in cells.enumerated() {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: -20, y: 0)
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0.04 * Double(index),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseOut,
                animations: {
                    cell.alpha = 1
                    cell.transform = .identity
                }
            )
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Mis Libros"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsButton
        
        searchBar.delegate = self
        searchBar.placeholder = "Buscar en mis favoritos..."
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
        cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterFavorites(with: searchText)
        updateEmptyState()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.filteredFavorites[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.filteredFavorites[indexPath.row]
        let detailVM = DetailViewModel(book: book, homeViewModel: homeViewModel)
        navigationController?.pushViewController(DetailViewController(viewModel: detailVM), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFavorite(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateEmptyState()
        }
    }
    
    @objc private func openSettings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
