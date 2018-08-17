//
//  PostsTableViewController.swift
//  RedditPosts
//
//  Created by Raphael Araújo on 2018-08-15.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Table view controller methods

class PostsTableViewController: UITableViewController {
    var posts: [Post]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "postCell")
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        
        self.loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil {
            return posts.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell

        let post = posts[indexPath.row]
        cell.titleLabel?.text = post.title
        
        cell.thumbnailImageView?.sd_setImage(with: URL(string: post.thumbnail!), placeholderImage: UIImage(named: "placeholder")!, options: [], completed: { (image, error, cache, url) in
            cell.setNeedsLayout()
        })
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.posts[indexPath.row]
        if let url = post.url() {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.showAlert("Sorry", "We couldn't open the post URL")
            }
        } else {
            self.showAlert("Sorry", "We couldn't open the post URL")
        }
    }
    
    

}
// MARK: - View routines

extension PostsTableViewController {
    func loadData() {
        self.showNetworkActivity()
        self.refreshControl?.endRefreshing()
        let redditAPI = RedditAPI()
        redditAPI.fetchPosts { [weak self] (result) in
            self?.hideNetworkActivity()
            switch result {
            case let .success(posts):
                self?.posts = posts
                self?.runOnMainThread {
                    self?.tableView.reloadData()
                }
                break
            case let .failure(error):
                self?.showAlert("Sorry", error.localizedDescription!)
            }
        }
    }
    
    @objc func handleRefresh(_: UIRefreshControl) {
        self.loadData()
    }
}
