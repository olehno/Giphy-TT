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
            guard let query = APIManager.shared.encode(query) else {
                self.errorHandler(observer: observer)
                return Disposables.create()
            }
            
            guard let url = APIManager.shared.createUrl(query: query, offset: offset) else {
                self.errorHandler(observer: observer)
                return Disposables.create()
            }
            
            let request = APIManager.shared.urlRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    self.errorHandler(observer: observer)
                    return
                }
                APIManager.shared.decodeGifsResponse(data: data, observer: observer)
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func errorHandler(observer: AnyObserver<Result<[Gif], any Error>>) {
        observer.onError(APIError.failedToGetData)
        observer.onCompleted()
    }
}
