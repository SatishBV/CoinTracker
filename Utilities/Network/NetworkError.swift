//
//  NetworkError.swift
//  Utilities
//
//  Created by Satish Bandaru on 18/09/21.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case error(Error)
    case invalidResponse
    case statusCodeError(code: Int)
    case parsingError
    
    public var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Please check your request"
        case let .error(error):
            return error.localizedDescription
        case .invalidResponse:
            return "Recieved an empty response"
        case let .statusCodeError(code):
            return "Something went wrong! \(code) Please try again"
        case .parsingError:
            return "Unable to parse the response"
        }
    }
}
