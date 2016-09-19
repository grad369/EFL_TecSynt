//
//  EFLSelectCompetitionCell.swift
//  Efl
//
//  Created by vishnu vijayan on 24/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

public let selectCompetitionCellIdentifier = "SelectCompetitionCellIdentifier"
class EFLSelectCompetitionCell: UITableViewCell {
    @IBOutlet weak var competitionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
