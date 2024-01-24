//
//  APICaller.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 27/12/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    func getGifs(with query: String, offset: Int) -> Observable<Result<[Gif], Error>> {
            return Observable.create { observer in
                guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                    observer.onNext(.failure(APIError.failedToGetData))
                    observer.onCompleted()
                    return Disposables.create()
                }
                
                guard let url = URL(string: "\(Constants.API_URL)api_key=\(Constants.API_KEY)&q=\(query)&offset=\(offset)&limit=20") else {
                    observer.onNext(.failure(APIError.failedToGetData))
                    observer.onCompleted()
                    return Disposables.create()
                }
                
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
                
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        observer.onNext(.failure(APIError.failedToGetData))
                        observer.onCompleted()
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(GifsResponse.self, from: data)
                        observer.onNext(.success(result.data))
                        observer.onCompleted()
                    } catch {
                        observer.onNext(.failure(APIError.failedToGetData))
                        observer.onCompleted()
                    }
                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
        }
}
