//
//  PostTableViewCell.swift
//  RedditPosts
//
//  Created by Raphael Araújo on 2018-08-16.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import UIKit
class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
    // sample code
        self.imageView?.image = nil
    }
}
