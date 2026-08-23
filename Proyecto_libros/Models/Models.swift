//
//  Models.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//

import Foundation

struct User: Codable {
    let username: String
    let passwordHash: String
}

struct BookSearchResponse: Codable {
    let items: [BookItem]?
}

struct BookItem: Codable, Hashable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable, Hashable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    let publisher: String?
    let publishedDate: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let pageCount: Int?
    let categories: [String]?
    let averageRating: Double?
    let ratingsCount: Int?
    let language: String?
    let previewLink: String?
}

struct IndustryIdentifier: Codable, Hashable {
    let type: String?
    let identifier: String?
}

struct ImageLinks: Codable, Hashable {
    let thumbnail: String?
}
