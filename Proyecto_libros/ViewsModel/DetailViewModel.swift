//
//  DetailViewModel.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import Foundation

final class DetailViewModel {
    let book: BookItem
    private weak var homeViewModel: HomeViewModel?
    
    var title: String { book.volumeInfo.title }
    var authors: String { "Autor(es): " + (book.volumeInfo.authors?.joined(separator: ", ") ?? "Desconocido") }
    var description: String { book.volumeInfo.description ?? "Sin descripción disponible." }
    
    init(book: BookItem, homeViewModel: HomeViewModel) {
        self.book = book
        self.homeViewModel = homeViewModel
    }
    
    func addToFavorites() {
        homeViewModel?.addFavorite(book)
    }
    
    var isAlreadyFavorite: Bool {
        homeViewModel?.favorites.contains(where: { $0.id == book.id }) ?? false
    }
}
