//
//  ViewController+Alert.swift
//  RedditPosts
//
//  Created by Raphael Araújo on 2018-08-17.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String?, _ message: String?, _ style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.runOnMainThread {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showNetworkActivity() {
        self.runOnMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func hideNetworkActivity() {
        self.runOnMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func runOnMainThread(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
