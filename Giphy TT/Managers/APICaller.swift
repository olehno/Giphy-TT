//
//  APICaller.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 27/12/2023.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    func getGifs(with query: String, offset: Int, completion: @escaping (Result<[Gif], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.API_URL)api_key=\(Constants.API_KEY)&q=\(query)&offset=\(offset)&limit=20") else { return }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(GifsResponse.self, from: data)
                completion(.success(result.data))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
