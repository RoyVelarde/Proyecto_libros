//
//  FavoritesViewModel.swift
//  Proyecto_libros
//
//  Created by XCODE on 23/08/26.
//

import Foundation

final class FavoritesViewModel {
    private var allFavorites: [BookItem] = []
    var filteredFavorites: [BookItem] = []
    
    var onDataUpdated: (() -> Void)?

    init() {
        refreshFavorites()
    }
    
    func refreshFavorites() {
        allFavorites = AuthManager.shared.loadFavorites()
        filteredFavorites = allFavorites
        onDataUpdated?()
    }
    
    func filterFavorites(with query: String) {
        if query.isEmpty {
            filteredFavorites = allFavorites
        } else {
            filteredFavorites = allFavorites.filter { book in
                let title = book.volumeInfo.title.lowercased()
                let author = book.volumeInfo.authors?.joined(separator: " ").lowercased() ?? ""
                let isbn = book.volumeInfo.industryIdentifiers?.first?.identifier ?? ""
                return title.contains(query.lowercased()) || author.contains(query.lowercased()) || isbn.contains(query)
            }
        }
        onDataUpdated?()
    }
    
    func removeFavorite(at index: Int) {
        let bookToRemove = filteredFavorites[index]
        allFavorites.removeAll { $0.id == bookToRemove.id }
        filteredFavorites.remove(at: index)
        AuthManager.shared.saveFavorites(allFavorites)
    }
}
