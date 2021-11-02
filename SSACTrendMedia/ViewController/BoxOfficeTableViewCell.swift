//
//  BoxOfficeTableViewCell.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/28.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell {
    static let identifier = "BoxOfficeTableViewCell"
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
