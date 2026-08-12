//
//  HTTMethod.swift
//  Dirigida-T2-services
//
//  Created by Jhonatan Chavez on 2/08/26.
//

import Foundation

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data)
    case encodingError(Error)
    case decodingError(Error)
    case requestError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL no es válida."
            
        case .invalidResponse:
            return "La respuesta del servidor no es válida."
            
        case let .httpError(statusCode, data):
            let message = String(data: data, encoding: .utf8) ?? "Sin detalle"
            return "Error HTTP \(statusCode): \(message)"
            
        case let .encodingError(error):
            return "Error al codificar el body: \(error.localizedDescription)"
            
        case let .decodingError(error):
            return "Error al decodificar la respuesta: \(error.localizedDescription)"
            
        case let .requestError(error):
            return "Error de conexión: \(error.localizedDescription)"
        }
    }
}
