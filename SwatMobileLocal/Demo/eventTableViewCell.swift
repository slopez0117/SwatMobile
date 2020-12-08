//
//  eventTableViewCell.swift
//  Demo
//
//  Created by Saul  Lopez-Valdez on 4/10/20.
//  Copyright © 2020 Saul  Lopez-Valdez. All rights reserved.
//

import UIKit

class eventTableViewCell: UITableViewCell
{
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var cellTimeLabel: UILabel!
    
    func roundImage(){
        //function that customizes the features of the cell image so that the edges appear round
        cellImage.layer.cornerRadius = 10
        cellImage.layer.masksToBounds = true
    }
}
