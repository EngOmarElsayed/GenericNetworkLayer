//
//  EndPointProtocol.swift
//
//
//  Created by Eng.Omar Elsayed on 23/07/2024.
//

import Foundation

/// Use this protocol with enum, so every case of the enum will represent api.
public protocol EndPointProtocol {
  var scheme: APISchemeType { get }
  var host: String? { get }
  var path: String { get }
  var queryItems: [URLQueryItem]? { get }
  
  /// Don't override the implementation of the url. if you did make sure you did it correctly.
  var url: URL? { get }
  var urlRequest: URLRequest? { get }
}

public extension EndPointProtocol {
  var url: URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme.rawValue
    urlComponents.host = host
    urlComponents.path = path
    urlComponents.queryItems = queryItems
    
    return urlComponents.url
  }
}
