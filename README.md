# GenericNetworkLayer
![example workflow](https://github.com/EngOmarElsayed/GenericNetworkLayer/actions/workflows/swift.yml/badge.svg)
![GitHub License](https://img.shields.io/github/license/EngOmarElsayed/GenericNetworkLayer)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](#swift-package-manager)

## Table of Contents
1. [Introduction](#introduction)
2. [How to use](#section-1)
   - [GenricNetworkLayer](#sub-topic-1.1)
3. [Testing](#section-2)
4. [Future Updates](#section-3) 
5. [Author](#conclusion)

## Introduction <a name="introduction"></a>
This pacakge was created to give you a simple easey to use genric network layer to add to your project. And even if you want to build your own genric network layer this will give
you a good start. Good Luck and enjoy 😉

## How to use <a name="section-1"></a>
Utilizing this API is designed to be straightforward and effortles. first thing you need to do is to create `enum` that conforms to `EndPointProtocol` like this one:
```swift
enum EndpointMock: EndPointProtocol {
    case validUrl
    
    var scheme: APISchemeType {
      switch self {
      case .validUrl:
          .https
      }
    }
    
    var host: String? {
      switch self {
      case .validUrl:
        return ""
      }
    }
    
    var path: String {
      switch self {
      case .validUrl:
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
      case .validUrl:
        return nil
      }
    }
  }
```

At this point every case in the enum will represent a certain api call. The `url` proprty in the `EndPointProtocol` have it's own implementation so you don't have to do it:
```swift
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
```

if you want to make a custome url session or add headers to the request. Use the `urlRequest` property in the `EndPointProtocol` and custome the request based on the enum case. 
Then you are ready to use the `GenricNetworkLayer` struct.

### GenricNetworkLayer <a name="sub-topic-1.1"></a>
`GenricNetworkLayer` is a struct that containes two funcations `public func data<T: Codable>(for endpoint: EndPointProtocol) async throws -> (result: T, statusCode: Int) where T: Codable` 
and `public func data(from endPoint: EndPointProtocol) async throws -> urlDataResult` both of them take instance of `EndPointProtocol` as an input. But the diffrent is the output.

The first one will fetch the data from the api then decode it using the `JsonDecoder` and output the result with the status code in a tuple.
```swift
let resultedData: (result: Int, statusCode: Int) = try! await genericNetworkLayer.data<Int>(for: endPoint)

// This will decode the data after fetching it
// from the api to Int and output
// the result with the status code
```

The second one was made to give you the ablitiy to have your own decoding logic, so it just fetches the data and output it with the status code in a tuple calle `urlDataResult`, which is a typealias.

```swift
let resultedData = try await genericNetworkLayer.data(from: endpoint)

// The resultedData will contain (Data, statuscode) as a tuple
```

### Testing <a name="section-2"></a>
For the testing part all you have to do to test the `GenricNetworkLayer` implementation is to make a subclass of the `URlProtocol` for refrence look at the 

## RemovingStoredObjects <a name="section-3"></a>


## Author <a name="conclusion"></a>
This pacakge was created by [Eng.Omar Elsayed](https://www.deveagency.com/) to help the iOS comuntity and make there life easir. To contact me email me at eng.omar.elsayed@hotmail.com


