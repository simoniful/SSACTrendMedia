//
//  BoxOfficeViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class BoxOfficeViewController: UIViewController {
    let localRealm = try! Realm()
    var boxOfficeData: Results<BoxOffice>!
    
    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var boxOfficeTableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxOfficeTableView.delegate = self
        boxOfficeTableView.dataSource = self
        let nibName = UINib(nibName: BoxOfficeTableViewCell.identifier, bundle: nil)
        boxOfficeTableView.register(nibName, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(closeBtnClicked))
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 0))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        boxOfficeTableView.backgroundColor = UIColor.clear
        
        boxOfficeData = localRealm.objects(BoxOffice.self)
        boxOfficeTableView.reloadData()
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BoxOfficeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxOfficeData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeTableViewCell.identifier, for: indexPath) as? BoxOfficeTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.clear
        let row = boxOfficeData[indexPath.row]
        cell.titleLabel.text = row.movieTitle
        cell.rankingLabel.text = row.ranking
        cell.releaseDateLabel.text = row.releaseDate

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


