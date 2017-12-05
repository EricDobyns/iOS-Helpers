//
//  NetworkResource.swift
//
//  Created by Eric Dobyns & Luis Garcia.
//  Copyright © 2017 Eric Dobyns & Luis Garcia. All rights reserved.
//

import Foundation

// MARK: - Network Result Type
public enum NetworkResult<A> {
    case data(A)
    case error(Error)
}

// MARK: - Network Error Types
public enum NetworkError: Error {
    case invalidResource
    case serverError(Int, String)
    case encodingError
}

// MARK: - Network Data Types
public enum NetworkDataType {
    case generic // Dictionaries & Arrays
    case encoded // Nearly Everything Else
}



// MARK: - APIResource Model
public struct NetworkResource<A: Decodable> {
    public let url: String
    public let headers: [String: String]?
    public let parameters: Decodable?
    public let httpMethod: NetworkHttpMethod
    public let encoding: NetworkParameterEncoding
    public let dataType: NetworkDataType
    public let parse: (Data) throws -> A?
}



// MARK: - APIResource Init
extension NetworkResource {
    
    // Initialize with api endpoint and return data type
    public init(endpoint: APIEndpoints, dataType: NetworkDataType) {
        self.init(baseUrl: API_ENVIRONMENT, endpoint: endpoint.name, parameters: endpoint.parameters, headers: endpoint.headers, httpMethod: endpoint.method, encoding: endpoint.encoding, dataType: dataType)
    }
    
    // Initialize all fields
    private init(baseUrl: APIEnvironment,
                 endpoint: String,
                 parameters: Decodable? = nil,
                 headers: [String: String]? = nil,
                 httpMethod: NetworkHttpMethod = .get,
                 encoding: NetworkParameterEncoding = .json,
                 dataType: NetworkDataType = .generic) {
        
        self.url = baseUrl.rawValue + endpoint
        self.headers = headers
        self.parameters = parameters
        self.httpMethod = httpMethod
        self.encoding = encoding
        self.dataType = dataType
        self.parse = { data in
            if dataType == .generic {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return jsonData as? A
            } else {
                let encodedData = try JSONDecoder().decode(A.self, from: data)
                return encodedData
            }
        }
    }
}


// URLRequest + NetworkResource Extension
extension URLRequest {
    public init?<A>(resource: NetworkResource<A>) {
        
        var endpointUrl = resource.url
        
        let parameters: [String: Any] = ["method" : resource.parameters as Any]
        
        var body: Data? = nil
        
        switch resource.encoding {
        case .json:
            body = parameters.jsonEncodedData
        case .url:
            if let parameters = parameters.urlEncodedString {
                endpointUrl += "?\(parameters)"
            }
        case .body:
            body = parameters.bodyEncodedData
        }
        
        guard let url = URL(string: endpointUrl) else { return nil }
        
        self.init(url: url)
        
        // Set Body
        httpBody = body
        
        // Set HTTP Method
        httpMethod = resource.httpMethod.rawValue
        
        // Set headers
        addValue(resource.encoding.contentType(), forHTTPHeaderField: "Content-Type")
        addValue(resource.encoding.contentType(), forHTTPHeaderField: "Accept")
    }
}

