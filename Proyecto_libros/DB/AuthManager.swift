//
//  AuthManager.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private let userKey = "registered_app_user"
    private let sessionKey = "is_user_logged_in"
    private let favoritesKey = "user_saved_favorites"
    
    private init() {}
    
    func register(user: User) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: userKey)
    }
    
    func login(username: String, pass: String) -> Bool {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return false
        }
        if user.username == username && user.passwordHash == pass {
            UserDefaults.standard.set(true, forKey: sessionKey)
            return true
        }
        return false
    }
    
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: sessionKey) }
        set { UserDefaults.standard.set(newValue, forKey: sessionKey) }
    }
    
    func saveFavorites(_ favorites: [BookItem]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    
    func loadFavorites() -> [BookItem] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([BookItem].self, from: data) else {
            return []
        }
        return favorites
    }
}
