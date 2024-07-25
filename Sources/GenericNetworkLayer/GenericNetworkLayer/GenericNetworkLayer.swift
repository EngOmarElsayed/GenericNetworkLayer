//MIT License
//
//Copyright (c) 2024 Omar Elsayed
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

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
