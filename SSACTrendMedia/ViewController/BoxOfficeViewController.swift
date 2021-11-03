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
    var targetDate = ""
    
    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var boxOfficeTableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var boxOfficeDatePicker: UIDatePicker!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxOfficeTableView.delegate = self
        boxOfficeTableView.dataSource = self
        let nibName = UINib(nibName: BoxOfficeTableViewCell.identifier, bundle: nil)
        boxOfficeTableView.register(nibName, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        boxOfficeTableView.backgroundColor = UIColor.clear
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let yesterday = formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        targetDate = yesterday
        if (localRealm.objects(BoxOffice.self).filter("searchDate == '\(yesterday)'").isEmpty) {
            fetchBoxOffice(dateString: yesterday)
        }

        print("Realm is located at", localRealm.configuration.fileURL!)
        
        boxOfficeData = localRealm.objects(BoxOffice.self).filter("searchDate == '\(yesterday)'")
        boxOfficeTableView.reloadData()
        
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let selectDay = formatter.string(from: Calendar.current.date(byAdding: .day, value: 0, to: boxOfficeDatePicker.date)!)
        targetDate = selectDay
        if (localRealm.objects(BoxOffice.self).filter("searchDate == '\(selectDay)'").isEmpty) {
            fetchBoxOffice(dateString: selectDay)
        }
        boxOfficeData = localRealm.objects(BoxOffice.self).filter("searchDate == '\(selectDay)'")
        boxOfficeTableView.reloadData()
    }
    
    @objc func fetchBoxOffice(dateString: String) {
        let url = Endpoint.boxOfficeURL
        let parameters: Parameters = [
            "key": APIKey.kofic,
            "targetDt": targetDate
        ]
        AF.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // print("JSON: \(json)")
                // try! self.localRealm.write { self.localRealm.delete(self.localRealm.objects(BoxOffice.self)) }
                json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue.forEach {
                    let item = BoxOffice(searchDate: dateString, movieTitle: $0["movieNm"].stringValue, ranking: $0["rnum"].stringValue, releaseDate: $0["openDt"].stringValue)
        
                    try! self.localRealm.write {
                         self.localRealm.add(item)
                    }
                }
                print("Data fetching")
                self.boxOfficeData = self.localRealm.objects(BoxOffice.self).filter("searchDate == '\(dateString)'")
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
        cell.titleLabel.text = row.movieTitle
        cell.rankingLabel.text = row.ranking
        cell.releaseDateLabel.text = row.releaseDate

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


