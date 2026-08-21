//
//  HomeViewController.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,
                                UISearchBarDelegate
    {
    
  
    
    private let viewModel = HomeViewModel()
    
    
    private let backgroundView = UIView()
    private let headerView = UIView()
    private let searchContainer = UIView()
    private let searchBar = UISearchBar()
    private let tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    )
    
   
    
    private let primaryColor = UIColor(
        red: 0.30,
        green: 0.25,
        blue: 0.85,
        alpha: 1.0
    )
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupUI()
    }
    
   
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(
                    title: "Error",
                    message: message
                )
            }
        }
    }
    
    
    private func setupUI() {
        view.backgroundColor = UIColor(
            red: 0.95,
            green: 0.96,
            blue: 1.0,
            alpha: 1.0
        )
        
        title = "Mis Libros"
        
        setupNavigationBar()
        setupBackground()
        setupHeader()
        setupSearch()
        setupTableView()
        setupLayout()
    }
    
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = primaryColor
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(
                red: 0.12,
                green: 0.12,
                blue: 0.18,
                alpha: 1.0
            ),
            .font: UIFont.systemFont(
                ofSize: 20,
                weight: .bold
            )
        ]
        
        let aboutButton = UIBarButtonItem(
            image: UIImage(
                systemName: "info.circle"
            ),
            style: .plain,
            target: self,
            action: #selector(openAbout)
        )
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(
                systemName: "gearshape.fill"
            ),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        
        navigationItem.rightBarButtonItems = [
            settingsButton,
            aboutButton
        ]
    }
    
    
    private func setupBackground() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(
            red: 0.95,
            green: 0.96,
            blue: 1.0,
            alpha: 1.0
        )
        
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            backgroundView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            backgroundView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            backgroundView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
    
    
    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = primaryColor
        
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            headerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            headerView.heightAnchor.constraint(
                equalToConstant: 105
            )
        ])
    }
    
    
    private func setupSearch() {
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        
        searchContainer.backgroundColor = .white
        searchContainer.layer.cornerRadius = 14
        
        searchContainer.layer.shadowColor =
            UIColor.black.cgColor
        searchContainer.layer.shadowOpacity = 0.12
        searchContainer.layer.shadowOffset =
            CGSize(width: 0, height: 5)
        searchContainer.layer.shadowRadius = 10
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.delegate = self
        searchBar.placeholder = "Buscar libros..."
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = false
        
        searchBar.tintColor = primaryColor
        
        searchContainer.addSubview(searchBar)
        view.addSubview(searchContainer)
        
        NSLayoutConstraint.activate([
            searchContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            searchContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),
            searchContainer.centerYAnchor.constraint(
                equalTo: headerView.bottomAnchor
            ),
            searchContainer.heightAnchor.constraint(
                equalToConstant: 52
            ),
            
            searchBar.leadingAnchor.constraint(
                equalTo: searchContainer.leadingAnchor,
                constant: 8
            ),
            searchBar.trailingAnchor.constraint(
                equalTo: searchContainer.trailingAnchor,
                constant: -8
            ),
            searchBar.topAnchor.constraint(
                equalTo: searchContainer.topAnchor
            ),
            searchBar.bottomAnchor.constraint(
                equalTo: searchContainer.bottomAnchor
            )
        ])
    }
    
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        
        tableView.separatorStyle = .none
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )
        
        tableView.contentInset = UIEdgeInsets(
            top: 35,
            left: 0,
            bottom: 20,
            right: 0
        )
        
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
    }
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: 25
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
    
    
    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {
        viewModel.searchBooks(
            query: searchBar.text ?? ""
        )
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        if searchText.isEmpty {
            viewModel.clearSearch()
        }
    }
    
    
    @objc private func openAbout() {
        present(
            AboutModalViewController(),
            animated: true
        )
    }
    
    
    @objc private func openSettings() {
        navigationController?.pushViewController(
            SettingsViewController(),
            animated: true
        )
    }
    
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 2
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        
        if section == 0 {
            return "MIS FAVORITOS"
        } else {
            return "RESULTADOS DE BÚSQUEDA"
        }
    }

    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        if section == 0 {
            return viewModel.favorites.count
        } else {
            return viewModel.searchResults.count
        }
    }
    
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )
        
        let book = indexPath.section == 0
            ? viewModel.favorites[indexPath.row]
            : viewModel.searchResults[indexPath.row]
        
        cell.backgroundColor = .white
        
        cell.layer.cornerRadius = 14
        cell.layer.masksToBounds = true
        
        // Espaciado
        cell.layoutMargins = UIEdgeInsets(
            top: 8,
            left: 16,
            bottom: 8,
            right: 16
        )
        
        cell.textLabel?.text = book.volumeInfo.title
        cell.textLabel?.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )
        cell.textLabel?.textColor = UIColor(
            red: 0.12,
            green: 0.12,
            blue: 0.18,
            alpha: 1.0
        )
        
        cell.textLabel?.numberOfLines = 2
    
        cell.imageView?.image = UIImage(
            systemName: "book.fill"
        )
        
        cell.imageView?.tintColor = primaryColor

        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        let book = indexPath.section == 0
            ? viewModel.favorites[indexPath.row]
            : viewModel.searchResults[indexPath.row]
        
        let detailVM = DetailViewModel(
            book: book,
            homeViewModel: viewModel
        )
        
        let detailVC = DetailViewController(
            viewModel: detailVM
        )
        
        navigationController?.pushViewController(
            detailVC,
            animated: true
        )
    }
    
    private func showAlert(
        title: String,
        message: String
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        present(
            alert,
            animated: true
        )
    }
}
