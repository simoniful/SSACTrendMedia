//
//  BoxOfficeViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON

class BoxOfficeViewController: UIViewController {
    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var boxOfficeTableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    var targetDate = "20211027"
    var boxOfficeData: [BoxOfficeModel] = []
    
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
        
        fetchBoxOffice()
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func fetchBoxOffice () {
        let url = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        let parameters: Parameters = [
            "key": "b794d4fc21c0305e6f7afb1b1e730f83",
            "targetDt": targetDate
        ]
        AF.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                self.boxOfficeData = json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue.map {
                    BoxOfficeModel(title: $0["movieNm"].stringValue, ranking: $0["rnum"].stringValue, releaseDate: $0["openDt"].stringValue)
                }
                self.boxOfficeTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
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
        cell.titleLabel.text = row.title
        cell.rankingLabel.text = row.ranking
        cell.releaseDateLabel.text = row.releaseDate

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


