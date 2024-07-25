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
