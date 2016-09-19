//
//  EFLLogoutCell.swift
//  Efl
//
//  Created by vishnu vijayan on 28/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

public let logoutCellIdentifier = "LogoutCellIdentifier"
class EFLLogoutCell: UITableViewCell {
    @IBOutlet weak var labelText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
