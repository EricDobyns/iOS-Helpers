//
//  APIManager.swift
//
//  Created by Eric Dobyns & Luis Garcia.
//  Copyright © 2017 Eric Dobyns & Luis Garcia. All rights reserved.
//

// MARK: - API Environment Type
public enum APIEnvironment: String {
    case local       = "http://localhost:3000"
    case staging     = "https://randomuser.me/api/"
    case production  = "https://<insert production url>"
}


// MARK: - API Manager
public class APIManager {
    public func fetch<A: Decodable>(endpoint: APIEndpoints, dataType: NetworkDataType, completion: @escaping (NetworkResult<A>) -> ()) {
        NetworkService().load(resource: NetworkResource<A>(endpoint: endpoint, dataType: dataType)) { result in
            switch result {
            case .data(let result):
                completion(NetworkResult<A>.data(result))
            case .error(let error):
                completion(NetworkResult<A>.error(error))
            }
        }
    }
}


// MARK: - API Endpoints
public enum APIEndpoints {
    
    // General
    case status
    
    // Users
    case getUser
    
    // Other
    
}


// MARK: - Endpoint Names
extension APIEndpoints {
    public var name: String {
        switch self {
        case .status:       return "status"
        case .getUser:      return ""
        }
    }
}


// MARK: - Endpoint HTTP Methods
extension APIEndpoints {
    public var method: NetworkHttpMethod {
        switch self {
        case .status, .getUser:
            return .get
        }
    }
}


// MARK: - Endpoint Headers - (without Content-Type or Accept)
extension APIEndpoints {
    public var headers: [String: String] {
        switch self {
        case .status, .getUser:
            return [:]
        }
    }
}


// MARK: - Endpoint Encoding Types
extension APIEndpoints {
    public var encoding: NetworkParameterEncoding {
        switch self {
        case .status, .getUser:
            return .json
        }
    }
}


// MARK: - Endpoint Parameters
extension APIEndpoints {
    public var parameters: Decodable? {
        switch self {
        case .status, .getUser:
            return nil
        }
    }
}


// MARK: - Endpoint Responses
extension APIManager {

    // Get User As Dictionary
    public func getUserAsDictionary(completion: @escaping (NetworkResult<[String: Any]>) -> ()) {
        fetch(endpoint: .getUser, dataType: .generic) { (result: NetworkResult<[String: Any]>) in
            completion(result)
        }
    }
}


