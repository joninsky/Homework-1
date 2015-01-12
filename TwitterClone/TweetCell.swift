//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Jon Vogel on 1/5/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

  @IBOutlet weak var lblUser: UILabel!
  @IBOutlet weak var lblTweet: UILabel!
  @IBOutlet weak var btnImageButton: UIButton!
  
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.layoutIfNeeded()
    self.lblTweet.preferredMaxLayoutWidth = self.lblTweet.frame.width
  }

}
