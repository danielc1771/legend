//
//  ExerciseCell.swift
//  Legend
//
//  Created by Daniel Castro on 3/11/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exercisesLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.size.height / 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
