//
//  APIManager.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 30/01/2024.
//

import Foundation
import RxSwift

class APIManager {
    
    static let shared = APIManager()
    
    func encode(_ query: String) -> String? {
        return query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    func createUrl(query: String, offset: Int) -> URL? {
        return URL(string: "\(Constants.API_URL)api_key=\(Constants.API_KEY)&q=\(query)&offset=\(offset)&limit=20")
    }
    
    func urlRequest(url: URL) -> URLRequest {
        return URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
    }
    
    func decodeGifsResponse(data: Data, observer: AnyObserver<Result<[Gif], Error>>) {
        do {
            let result = try JSONDecoder().decode(GifsResponse.self, from: data)
            observer.onNext(.success(result.data))
            observer.onCompleted()
        } catch {
            APICaller.shared.errorHandler(observer: observer)
        }
    }
}
