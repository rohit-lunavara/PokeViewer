//
//  AbilityDetailCell.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 7/1/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

final class AbilityDetailCell: UITableViewCell {

    @IBOutlet var abilityLabel: UILabel!
    @IBOutlet var abilityHiddenImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
