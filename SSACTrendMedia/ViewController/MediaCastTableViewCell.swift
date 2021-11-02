//
//  MediaCastTableViewCell.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit

class MediaCastTableViewCell: UITableViewCell {
    static let identifier = "MediaCastTableViewCell"
    
    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var castActorNameLabel: UILabel!
    @IBOutlet weak var castCharNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
