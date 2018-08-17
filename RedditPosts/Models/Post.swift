//
//  Post.swift
//  RedditPosts
//
//  Created by Raphael Araújo on 2018-08-15.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let title: String?
    let thumbnail: String?
    let permalink: String?
    
    func url() -> URL? {
        guard let perma = self.permalink else {
            return nil
        }
        return URL(string: "\(Constants.redditURL.rawValue)\(perma)")
    }
}

struct FetchPostsResults: Decodable {
    let data: DataResult
}

struct DataResult: Decodable {
    let children: [PostDataResult]
}

struct PostDataResult: Decodable {
    let data: Post
}
