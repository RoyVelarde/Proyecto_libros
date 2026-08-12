//
//  AuthViewModel.swift
//  Proyecto_libros
//
//  Created by XCODE on 11/08/26.
//


import Foundation

final class AuthViewModel {
    
    func validatePassword(_ pass: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: pass)
    }
    
    func login(username: String, pass: String, completion: (Bool, String?) -> Void) {
        guard !username.isEmpty, !pass.isEmpty else {
            completion(false, "Completa todos los campos.")
            return
        }
        
        if AuthManager.shared.login(username: username, pass: pass) {
            completion(true, nil)
        } else {
            completion(false, "Usuario o contraseña incorrectos.")
        }
    }
    
    func register(username: String, pass: String, completion: (Bool, String?) -> Void) {
        guard !username.isEmpty, !pass.isEmpty else {
            completion(false, "Completa todos los campos.")
            return
        }
        
        if !validatePassword(pass) {
            completion(false, "La contraseña debe tener mín. 6 caracteres, 1 mayúscula, 1 minúscula y 1 número.")
            return
        }
        
        do {
            let newUser = User(username: username, passwordHash: pass)
            try AuthManager.shared.register(user: newUser)
            completion(true, nil)
        } catch {
            completion(false, "No se pudo registrar en la base de datos interna.")
        }
    }
}
