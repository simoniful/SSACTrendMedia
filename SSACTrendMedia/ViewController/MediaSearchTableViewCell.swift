//
//  MediaSearchTableViewCell.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit

class MediaSearchTableViewCell: UITableViewCell {

    static let identifier = "MediaSearchTableViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
