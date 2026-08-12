//
//  Endpoint.swift
//  Dirigida-T2-services
//
//  Created by Jhonatan Chavez on 2/08/26.
//

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryParameters: [String: String]
    let body: AnyEncodable?
    
    // Para GET u otras peticiones sin body
    init(
        path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:]
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = nil
    }
    
    // Para POST u otras peticiones con body
    init<Body: Encodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:],
        body: Body
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = AnyEncodable(body)
    }
}

struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void
    
    init<T: Encodable>(_ value: T) {
        encodeClosure = value.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
