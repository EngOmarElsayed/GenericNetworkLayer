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

import XCTest
import GenericNetworkLayer

final class GenericNetworkLayerTests: XCTestCase {
  override func setUp() {
    URLProtocolStub.startInterceptingRequest()
  }
  
  override func tearDown() {
    URLProtocolStub.stopInterceptingRequest()
  }
  
  func test_endpoint_withUrlRequest() {
    let endPoint: EndpointMock = .urlRequest
    XCTAssertNotNil(endPoint.urlRequest, "Expected to have a value in the urlRequest but got nil instead")
  }
  
  func test_endpoint_withUrlAndNilUrlRequest() {
    let endPoint: EndpointMock = .validUrl
    let expectedUrl = URL(string: "https://")
    
    let resultedUrl = endPoint.url
    
    XCTAssertNotNil(resultedUrl, "Expected to have a value in the url but got nil instead")
    XCTAssertEqual(resultedUrl, expectedUrl, "Expected to have the same url as \(expectedUrl!) but got \(resultedUrl!) insted")
    XCTAssertNil(endPoint.urlRequest, "Expected to have a value nil value but got instead \(endPoint.urlRequest!)")
  }
  
  func test_dataMethod_withInvalidUrl() async {
    let endPoint: EndpointMock = .invalidUrl
    let expectedError: GenericNetworkLayerError = .urlIsInvalid
    
    let result = await dataResult(for: endPoint,nil, nil)
    
    XCTAssertNil(result.data, "Expected the data to be nil got \(result.data!)")
    XCTAssertEqual(result.error!.localizedDescription, expectedError.localizedDescription, "Expected to have \(expectedError) error got \(result.error!)")
  }
  
  func test_dataMethod_withClientError() async {
    let expectedErrorCode = 401
    let endPoint: EndpointMock = .validUrl
    let expectedError: GenericNetworkLayerError = .clientError(code: expectedErrorCode)
    
    let result = await dataResult(for: endPoint, nil, httpURLResponse(for: expectedErrorCode))
    
    XCTAssertNil(result.data, "Expected the data to be nil got \(result.data!)")
    XCTAssertEqual(result.error!.localizedDescription, expectedError.localizedDescription, "Expected to have \(expectedError) error got \(result.error!)")
  }
  
  func test_dataMethod_withServerError() async {
    let expectedErrorCode = 500
    let endPoint: EndpointMock = .validUrl
    let expectedError: GenericNetworkLayerError = .serverError(code: expectedErrorCode)
    
    let result = await dataResult(for: endPoint, nil, httpURLResponse(for: expectedErrorCode))
    
    XCTAssertNil(result.data, "Expected the data to be nil got \(result.data!)")
    XCTAssertEqual(result.error!.localizedDescription, expectedError.localizedDescription, "Expected to have \(expectedError) error got \(result.error!)")
  }
  
  func test_dataMethod_withSuccess() async {
    let expectedStatusCode = 200
    let endPoint: EndpointMock = .validUrl
    let expectedData = anyData()
    
    let result = await dataResult(for: endPoint, expectedData, httpURLResponse(for: expectedStatusCode))
    
    XCTAssertNotNil(result.data, "Expected the data to have a value got nil instead")
    XCTAssertEqual(result.data, expectedData, "Expected to have \(expectedData) data got \(result.data!) instead")
  }
  
  func test_dataMethod_withoutPutT() async {
    let genericNetworkLayer = GenericNetworkLayer()
    let endPoint: EndpointMock = .validUrl
    let expectedOutput = 10
    let outputData = encode(item: expectedOutput)
    setupStub(outputData, httpURLResponse(for: 200))
    
    let resultedData: (result: Int, statusCode: Int) = try! await genericNetworkLayer.data<Int>(for: endPoint)
    
    XCTAssertEqual(resultedData.result, expectedOutput, "Expected to have \(expectedOutput) data got \(resultedData.result) instead")
  }
  
  //MARK: -  Helpers
  private func dataResult(for endpoint: EndPointProtocol, _ output: Data?, _ response: HTTPURLResponse?) async -> (data: Data?, error: GenericNetworkLayerError?) {
    let genericNetworkLayer = GenericNetworkLayer()
    setupStub(output, response)
    
    do {
      let resultedTuple = try await genericNetworkLayer.data(from: endpoint)
      return (resultedTuple.resultedData, nil)
    } catch {
      guard let error = convertErrorToGenericNetworkLayerError(error) else { return (nil, nil) }
      return (nil, error)
    }
  }
  
  private func setupStub(_ output: Data?, _ response: HTTPURLResponse?) {
    URLProtocolStub.setResponse(with: response)
    URLProtocolStub.setData(with: output)
  }
  
  private func encode<T: Encodable>(item: T) -> Data {
    return try! JSONEncoder().encode(item)
  }
  
  private func anyData() -> Data {
    return Data("Any Data".utf8)
  }
  
  private func convertErrorToGenericNetworkLayerError(_ error: Error) -> GenericNetworkLayerError? {
    guard let error = error as? GenericNetworkLayerError else {
      XCTFail("The request should give me error of type GenericNetworkLayerError instead got \(error)")
      return nil
    }
    return error
  }
  
  private func httpURLResponse(for code: Int) -> HTTPURLResponse {
    let url = EndpointMock.validUrl.url!
    return HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
  }
  
  //MARK: -  URLProtocolStub
  private class URLProtocolStub: URLProtocol {
    private static var httpURLResponse: URLResponse?
    private static var data: Data?
    
    static func startInterceptingRequest() {
      URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequest() {
      URLProtocol.unregisterClass(URLProtocolStub.self)
    }
    
    static func setResponse(with response: URLResponse?) {
      httpURLResponse = response
    }
    
    static func setData(with data: Data?) {
      self.data = data
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
      return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
      return request
    }
    
    override func startLoading() {
      if let data = URLProtocolStub.data {
        client?.urlProtocol(self, didLoad: data)
      }
      
      if let response = URLProtocolStub.httpURLResponse {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      }
      
      client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
  }
  
  //MARK: -  EndpointMock
  private enum EndpointMock: EndPointProtocol {
    case invalidUrl
    case urlRequest
    case validUrl
    
    var scheme: APISchemeType {
      switch self {
      case .invalidUrl:
          .http
      case .urlRequest, .validUrl:
          .https
      }
    }
    
    var host: String? {
      switch self {
      case .invalidUrl, .urlRequest:
        return nil
      case .validUrl:
        return ""
      }
    }
    
    var path: String {
      switch self {
      case .invalidUrl:
        return "//"
      case .urlRequest, .validUrl:
        return ""
      }
    }
    
    var queryItems: [URLQueryItem]? {
      return nil
    }
    
    var urlRequest: URLRequest? {
      guard let url else { return nil }
      let urlRequest = URLRequest(url: url)
      
      switch self {
      case .invalidUrl, .validUrl:
        return nil
      case .urlRequest:
        return urlRequest
      }
    }
  }
}


