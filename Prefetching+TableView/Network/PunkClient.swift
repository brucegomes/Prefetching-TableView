//The Legal Stuff
//
// The data in this API is taken directly from BrewDog’s DIY Dog and is therefore free to use, replicate verbatim
// and share, but cannot be used for commercial purposes. All data taken from https://punkapi.com/

//
//  PunkClient.swift
//  Prefetching+TableView
//
//  Created by Bruce Gomes on 4/1/21.
//

import Foundation

final class PunkClient {
    
    private lazy var baseUrl: URL = {
        return URL(string: "https://api.punkapi.com/v2/")!
    }()
    final let requestPath = "beers"
    
    let session : URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchBeers(page: Int, completion : @escaping (Result<Beer, DataResponseError>) -> Void) {
        
        let urlRequest = URLRequest(url: baseUrl.appendingPathComponent(requestPath))
        let parameters = ["page" : "\(page)"]
        let encodedURLRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest) { (Data, URLResponse, Error) in
            
            guard let httpResponse = URLResponse as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                  let data = Data
            else {
                completion(Result.failure(DataResponseError.network))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let decodeResponse = try? decoder.decode([Beer].self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            completion(Result.success(decodeResponse))
            
        }.resume()
    }
}

enum Result<T, U: Error> {
    case success([T])
    case failure(U)
}

enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "A network error occurred while fetching data"
        case .decoding:
            return "An decoding error occurred while parsing data from Punk Servers"
        }
    }
}

typealias Parameters = [String: String]

extension URLRequest {
    func encode(with parameters: Parameters?) -> URLRequest {
        guard let parameters = parameters else {
            return self
        }
        
        var encodedURLRequest = self
        
        if let url = self.url,
           let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            var newUrlComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            newUrlComponents.queryItems = queryItems
            encodedURLRequest.url = newUrlComponents.url
            return encodedURLRequest
        } else {
            return self
        }
    }
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
