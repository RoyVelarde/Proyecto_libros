//
//  NetworkService.swift
//  Dirigida-T2-services
//
//  Created by Jhonatan Chavez on 2/08/26.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func request<Response: Decodable>(
        endpoint: Endpoint,
        responseType: Response.Type
    ) async throws -> Response
}

final class NetworkService: NetworkServiceProtocol {
    
    private let baseURL: String
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        baseURL: String,
        session: URLSession = .shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func request<Response: Decodable>(
        endpoint: Endpoint,
        responseType: Response.Type
    ) async throws -> Response {
        let request = try buildRequest(endpoint: endpoint)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.httpError(
                    statusCode: httpResponse.statusCode,
                    data: data
                )
            }
            
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestError(error)
        }
    }
    
    private func buildRequest(endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(
            string: baseURL + endpoint.path
        ) else {
            throw NetworkError.invalidURL
        }
        
        if !endpoint.queryParameters.isEmpty {
            components.queryItems = endpoint.queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 30
        
        var headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        endpoint.headers.forEach {
            headers[$0.key] = $0.value
        }
        
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let body = endpoint.body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        
        return request
    }
}



