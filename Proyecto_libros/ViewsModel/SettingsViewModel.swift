//
//  SettingsViewModel.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import UIKit

final class SettingsViewModel {
    func logout() {
        AuthManager.shared.isLoggedIn = false
    }
    
    func toggleTheme(isDark: Bool) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        for window in windowScene?.windows ?? [] {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
    }
}
