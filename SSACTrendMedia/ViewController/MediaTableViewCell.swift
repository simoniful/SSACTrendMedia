//
//  MediaTableViewCell.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    static let identifier = "MediaTableViewCell"
    
   
    @IBOutlet weak var genreHashtagLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var korTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var linkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
