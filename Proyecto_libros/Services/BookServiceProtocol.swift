//
//  BookServiceProtocol.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//

import Foundation

protocol BookServiceProtocol {
    func searchBooks(query: String) async throws -> [BookItem]
}

final class BookService: BookServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let apiKey = "AIzaSyCrPmlgewEJ_vU-iCJisabSxT86hLN7h5E"
    
    init(networkService: NetworkServiceProtocol = NetworkService(baseURL: "https://www.googleapis.com/books/v1")) {
        self.networkService = networkService
    }
    
    func searchBooks(query: String) async throws -> [BookItem] {
        let endpoint = Endpoint(
            path: "/volumes",
            method: .get,
            queryParameters: [
                "q": query,
                "key": apiKey
            ]
        )
        let response = try await networkService.request(endpoint: endpoint, responseType: BookSearchResponse.self)
        return response.items ?? []
    }
}
