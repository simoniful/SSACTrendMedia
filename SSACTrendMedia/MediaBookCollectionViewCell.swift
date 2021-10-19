//
//  MediaBookCollectionViewCell.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/19.
//

import UIKit

class MediaBookCollectionViewCell: UICollectionViewCell {

    static let identifier = "MediaBookCollectionViewCell"
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookRateLabel: UILabel!
    @IBOutlet weak var bookCoverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
