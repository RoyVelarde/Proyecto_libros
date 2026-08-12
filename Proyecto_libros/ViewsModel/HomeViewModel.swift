//
//  HomeViewModel.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import Foundation

final class HomeViewModel {
    private let bookService: BookServiceProtocol
    
    var searchResults: [BookItem] = []
    var favorites: [BookItem] = [] {
        didSet {
            AuthManager.shared.saveFavorites(favorites)
        }
    }
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(bookService: BookServiceProtocol = BookService()) {
        self.bookService = bookService
        self.favorites = AuthManager.shared.loadFavorites()
    }
    
    func searchBooks(query: String) {
        guard !query.isEmpty else { return }
        Task {
            do {
                let results = try await bookService.searchBooks(query: query)
                DispatchQueue.main.async {
                    self.searchResults = results
                    self.onDataUpdated?()
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?("Error al buscar libros: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func clearSearch() {
        searchResults = []
        onDataUpdated?()
    }
    
    func addFavorite(_ book: BookItem) {
        if !favorites.contains(where: { $0.id == book.id }) {
            favorites.append(book)
            onDataUpdated?()
        }
    }
}
