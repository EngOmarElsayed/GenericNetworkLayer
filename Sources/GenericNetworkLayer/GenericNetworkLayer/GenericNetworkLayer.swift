//
//  GenericNetworkLayer.swift
//
//
//  Created by Eng.Omar Elsayed on 23/07/2024.
//

import Foundation

/// This struct contains all the networking functions
public struct GenericNetworkLayer {
  private let urlSession = URLSession.shared
  private let decoder = JSONDecoder()
  
  public typealias urlDataResult = (resultedData: Data, statusCode: Int)
  public init() {}
  
  /// This method takes  endpoint object that conforms to EndPointProtocol, output the result decode to the generic type T and the statusCode in a tuple
  public func data<T: Codable>(for endpoint: EndPointProtocol) async throws -> (result: T, statusCode: Int) where T: Codable {
    let result = try await preformNetworkRequest(for: endpoint)
    return (try decoder.decode(T.self, from: result.resultedData), result.statusCode)
  }
  
  /// This method takes  endpoint object that conforms to EndPointProtocol, and outputs data and the status code. Use this method if you want to have a custom decoding.
  public func data(from endPoint: EndPointProtocol) async throws -> urlDataResult {
    return try await preformNetworkRequest(for: endPoint)
  }
}

//MARK: -  private methods
fileprivate extension GenericNetworkLayer {
  func preformNetworkRequest(for endPoint: EndPointProtocol) async throws -> urlDataResult {
    guard let url = endPoint.url else { throw GenericNetworkLayerError.urlIsInvalid }
    
    let urlResult = if let urlRequest = endPoint.urlRequest {
      try await getData(urlRequest: urlRequest)
    } else {
      try await getData(url: url)
    }
    return urlResult
  }
  
  func getData(urlRequest: URLRequest) async throws -> urlDataResult {
    let (resultedData, response) = try await urlSession.data(for: urlRequest)
    let statusCode = try checkStatusCode(for: response)
    return (resultedData, statusCode)
  }
  
  func getData(url: URL) async throws -> urlDataResult {
    let (resultedData, response) = try await urlSession.data(from: url)
    let statusCode = try checkStatusCode(for: response)
    return (resultedData, statusCode)
  }
  
  func checkStatusCode(for response: URLResponse) throws -> Int {
    guard let response = response as? HTTPURLResponse else { throw  GenericNetworkLayerError.failedToConvertResponse }
    let statusCode = response.statusCode
    
    switch statusCode {
    case 100...103:
      return statusCode
      
    case 200...226:
      return statusCode
      
    case 300...308:
      return statusCode
      
    case 400...451:
      throw GenericNetworkLayerError.clientError(code: statusCode)
      
    case 500...511:
      throw GenericNetworkLayerError.serverError(code: statusCode)
      
    default:
      throw GenericNetworkLayerError.unknownStatusCode(code: statusCode)
    }
  }
}
