//
//  GenericNetworkLayerError.swift
//  
//
//  Created by Eng.Omar Elsayed on 23/07/2024.
//

import Foundation

/// This enum represent the types of error the function may throw
@frozen public enum GenericNetworkLayerError: Error {
  case urlIsInvalid
  case failedToConvertResponse
  case clientError(code: Int)
  case serverError(code: Int)
  case unknownStatusCode(code: Int)
}

public extension GenericNetworkLayerError {
  var localizedDescription: String {
    switch self {
    case .urlIsInvalid:
      return "The given url is invalid"
    case .failedToConvertResponse:
      return "Failed to convert the URLResponse to HTTPUrlResponse"
    case .clientError(let code):
      return "Network request failed due to client error with status code \(code)"
    case .serverError(let code):
      return "Network request failed due to server error with status code \(code)"
    case .unknownStatusCode(let code):
      return "Network request failed unknown status code \(code)"
    }
  }
}
