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
