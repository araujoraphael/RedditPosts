//
//  RedditAPI.swift
//  RedditPosts
//
//  Created by Raphael Araújo on 2018-08-15.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import Foundation

struct CustomError {
    var localizedDescription: String?
}

enum FetchPostsResult {
    case success([Post])
    case failure(CustomError)
}

class RedditAPI {
    func fetchPosts(completion: @escaping (FetchPostsResult) -> Void) {
        guard let urlRequest = RedditAPI.fetchPostsRequest() else {
            return completion(.failure(CustomError(localizedDescription: "Invalid URL Request")))
        }
        
        let urlSession = URLSession(configuration: .default)
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard let e = error else {
                guard let responseHTTP = response as? HTTPURLResponse else {
                    completion(.failure(CustomError(localizedDescription: "Unknown error")))
                    return
                }
                
                guard let httpError = RedditAPI.errorFrom(httpResponse: responseHTTP) else {
                    let result = RedditAPI.handleFetchPostsRequest(data: data)
                    switch result {
                    case let .success(posts):
                        completion(.success(posts))
                        break
                    case let .failure(error):
                        completion(.failure(error))
                        break
                    }
                    return
                }
                
                completion(.failure(httpError))

                return
            }
            completion(.failure(CustomError(localizedDescription: e.localizedDescription)))
        }
        
        dataTask.resume()
    }
    
    static func fetchPostsRequest() -> URLRequest? {
        guard let url = URL(string: Constants.postsJSONURL.rawValue) else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    static func errorFrom(httpResponse: HTTPURLResponse) -> CustomError? {
        if Array(200...226).contains(httpResponse.statusCode) {
            return nil
        }
        
        if Array(500...599).contains(httpResponse.statusCode) {
            return CustomError(localizedDescription: "Server error")
        }
        
        if Array(400...499).contains(httpResponse.statusCode) {
            return CustomError(localizedDescription: "Access Error")
        }
        
        return nil
    }
    
    static private func handleFetchPostsRequest(data: Data?) -> FetchPostsResult {
        guard let json = data else {
            let error = CustomError(localizedDescription: "Error handling response")
            return .failure(error)
        }
        do {
            let fetchResults = try JSONDecoder().decode(FetchPostsResults.self, from: json)
            let posts = fetchResults.data.children.map({
                (postResult: PostDataResult) -> Post  in
                postResult.data
            })
            return .success(posts)
        } catch(let error){
            return .failure(CustomError(localizedDescription: error.localizedDescription))

        }
    }
}
