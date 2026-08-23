//
//  SettingsViewModel.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//

import UIKit

final class SettingsViewModel {
    private let themeKey = "isDarkModeEnabled"
    
    var isCurrentThemeDark: Bool {
        return UserDefaults.standard.bool(forKey: themeKey)
    }
    
    func logout() {
        AuthManager.shared.isLoggedIn = false
    }
    
    func toggleTheme(isDark: Bool) {
        UserDefaults.standard.set(isDark, forKey: themeKey)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        for window in windowScene?.windows ?? [] {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
    }
}
