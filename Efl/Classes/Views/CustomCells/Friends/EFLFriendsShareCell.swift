//
//  EFLFriendsShareCell.swift
//  Efl
//
//  Created by vishnu vijayan on 10/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

public let friendsShareCellIdentifier = "FriendsShareCellIdentifier"
class EFLFriendsShareCell: UITableViewCell {
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
