//
//  MediaCastOverviewTableViewCell.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/19.
//

import UIKit

class MediaCastOverviewTableViewCell: UITableViewCell {
    // 버튼을 고정하고 레이블 4면 constraint
    // 이미지인 경우 너비 설정 주의 
    static let identifier = "MediaCastOverviewTableViewCell"
    
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var expansionToggleBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
