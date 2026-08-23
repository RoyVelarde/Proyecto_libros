//
//  DetailViewModel.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//

import Foundation

final class DetailViewModel {
    let book: BookItem
    weak var homeViewModel: HomeViewModel?
    private let bookService: BookServiceProtocol
    
    var otherBooks: [BookItem] = []
    var similarBooks: [BookItem] = []
    var onDataLoaded: (() -> Void)?
    
    var title: String { book.volumeInfo.title }
    var authors: String { book.volumeInfo.authors?.joined(separator: ", ") ?? "Autor Desconocido" }
    var description: String { book.volumeInfo.description ?? "Sin descripción disponible." }
    var thumbnailURL: URL? { URL(string: book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http:", with: "https:") ?? "") }
    var previewURL: URL? { URL(string: book.volumeInfo.previewLink ?? "") }
    var rating: Double { book.volumeInfo.averageRating ?? 0.0 }
    var categoriesText: String { book.volumeInfo.categories?.first ?? "" }
    var languageText: String { book.volumeInfo.language?.uppercased() ?? "" }
    var pageCountText: String { book.volumeInfo.pageCount != nil ? "\(book.volumeInfo.pageCount!) pág." : "" }

    var isAlreadyFavorite: Bool {
        AuthManager.shared.loadFavorites().contains(where: { $0.id == book.id })
    }

    init(book: BookItem, homeViewModel: HomeViewModel, bookService: BookServiceProtocol = BookService()) {
        self.book = book
        self.homeViewModel = homeViewModel
        self.bookService = bookService
    }
    
    func fetchRelatedContent() {
        Task {
            do {
                if let author = book.volumeInfo.authors?.first {
                    let authorResults = try await bookService.searchBooks(query: "inauthor:\(author)")
                    self.otherBooks = authorResults.filter { $0.id != book.id }
                }
                
                if let category = book.volumeInfo.categories?.first {
                    let categoryResults = try await bookService.searchBooks(query: "subject:\(category)")
                    self.similarBooks = Array(categoryResults.filter { $0.id != book.id }.prefix(5))
                }
                
                DispatchQueue.main.async { self.onDataLoaded?() }
            } catch {
                print("Error fetching related content")
            }
        }
    }
    
    func toggleFavorite() {
        var favorites = AuthManager.shared.loadFavorites()
        if let index = favorites.firstIndex(where: { $0.id == book.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(book)
        }
        AuthManager.shared.saveFavorites(favorites)
        homeViewModel?.onDataUpdated?()
    }
}
