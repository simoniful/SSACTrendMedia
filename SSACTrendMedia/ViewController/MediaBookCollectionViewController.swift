//
//  MediaBookCollectionViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/19.
//

import UIKit

class MediaBookCollectionViewController: UIViewController {
    
    let tvShowInformation = TvShowInformation()

    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        
        let nibName = UINib(nibName: MediaBookCollectionViewCell.identifier, bundle: nil)
        bookCollectionView.register(nibName, forCellWithReuseIdentifier: MediaBookCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: width / 2, height: (width / 2))
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
        
        bookCollectionView.collectionViewLayout = layout
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

}

extension MediaBookCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShowInformation.tvShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaBookCollectionViewCell.identifier, for: indexPath) as? MediaBookCollectionViewCell else { return UICollectionViewCell()}
        
        let item = tvShowInformation.tvShow[indexPath.item]
        
        cell.backgroundColor = getRandomColor()
        cell.layer.cornerRadius = 10
        cell.bookCoverImageView.image = UIImage(named: item.title)
        cell.bookTitleLabel.text = item.title
        cell.bookRateLabel.text = String(item.rate)
        
        return cell
    }
    
    
}
