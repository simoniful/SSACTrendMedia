//
//  ViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var btnGroup: UIStackView!
    @IBOutlet weak var mediaTableView: UITableView!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var mapBtn: UIBarButtonItem!
    @IBOutlet weak var boxOfficeBtn: UIButton!
    
    let localRealm = try! Realm()
    
    // let tvShowInformation = TvShowInformation()
    var trendInfoData: [TrendInfo] = []
    var genreData: [GenreModel] = []
    var startPage = 1
    var totalCount = 0
    var targetDate = "20211027"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaTableView.delegate = self
        mediaTableView.dataSource = self
        mediaTableView.prefetchDataSource = self
        
        btnGroup.layer.cornerRadius = 10
        btnGroup.layer.shadowOpacity = 0.3
        btnGroup.layer.shadowColor = UIColor.black.cgColor
        btnGroup.layer.shadowOffset = CGSize(width: 0, height: 0)
        btnGroup.layer.shadowRadius = 10
        btnGroup.layer.masksToBounds = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let yesterday = formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        targetDate = yesterday
        
        print(targetDate)
        
        fetchGenreData()
        fetchTrendInfo()
        fetchBoxOffice ()
        print("Realm is located at", localRealm.configuration.fileURL!)
    }
    
    @objc func fetchGenreData() {
        let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(APIKey.TMDB)&language=ko"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // print("JSON: \(json)")
                self.genreData = json["genres"].arrayValue.map {
                    GenreModel(id: $0["id"].intValue, name: $0["name"].stringValue)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func fetchBoxOffice () {
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
                try! self.localRealm.write { self.localRealm.delete(self.localRealm.objects(BoxOffice.self)) }
                json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue.forEach {
                    let item = BoxOffice(movieTitle: $0["movieNm"].stringValue, ranking: $0["rnum"].stringValue, releaseDate: $0["openDt"].stringValue)
                    
                    try! self.localRealm.write {
                         self.localRealm.add(item)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func fetchTrendInfo() {
        let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(APIKey.TMDB)&language=ko&page=\(self.startPage)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["results"].arrayValue.map({
                    TrendInfo(title: $0["title"].stringValue, releaseDate: $0["release_date"].stringValue, genres: $0["genre_ids"].arrayValue.map({ $0.intValue }) , region: $0["original_language"].stringValue, overview: $0["overview"].stringValue, rate: $0["vote_average"].doubleValue, originalTitle: $0["original_title"].stringValue, backdropImage: $0["backdrop_path"].stringValue, posterImage: $0["poster_path"].stringValue, mediaId: $0["id"].intValue)
                })
                self.trendInfoData = self.trendInfoData + data
                self.mediaTableView.reloadData()
                self.totalCount = json["total_results"].intValue
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func boxOfficeBtnClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BoxOfficeViewController") as! BoxOfficeViewController
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func mapBtnClicked(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CinemaLocationViewController") as! CinemaLocationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bookBtnClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MediaBookCollectionViewController") as! MediaBookCollectionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBtnClicked(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MediaSearchTableViewController") as! MediaSearchTableViewController
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func linkBtnClicked(selectButton: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.tvShowData = trendInfoData[selectButton.tag]
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .automatic
        self.present(nav, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendInfoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier, for: indexPath) as? MediaTableViewCell else {
            return UITableViewCell()
        }
        
        let row = trendInfoData[indexPath.row]
        
        cell.containerView.layer.cornerRadius = 10
        cell.containerView.layer.shadowOpacity = 0.3
        cell.containerView.layer.shadowColor = UIColor.black.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.containerView.layer.shadowRadius = 10
        cell.containerView.layer.masksToBounds = false
        
        
        let convertGenres = row.genres.map { genreId in
            genreData.first{ $0.id == genreId }?.name ?? ""
        }

        cell.genreHashtagLabel.text = convertGenres.joined(separator: ",")
        
        cell.titleLabel.text = row.originalTitle
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(row.posterImage.replacingOccurrences(of: "\\" , with: ""))") {
            cell.posterImageView.kf.setImage(with: url)
        } else {
            cell.posterImageView.image = UIImage(systemName: "star")
        }
        cell.rateLabel.text = String(row.rate)
        cell.korTitleLabel.text = row.title
        cell.releaseDateLabel.text = row.releaseDate
        cell.linkBtn.tag = indexPath.row
        cell.linkBtn.layer.cornerRadius = 22
        cell.linkBtn.addTarget(self, action: #selector(linkBtnClicked(selectButton:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 460
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MediaCastTableViewController") as! MediaCastTableViewController
        vc.titleSpace = "출연/제작"
        let row = trendInfoData[indexPath.row]
        vc.tvShowData = row
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}


extension ViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            // 데이터의 총량을 측정하여 엔드 설정 및
            if trendInfoData.count - 1 == indexPath.row && trendInfoData.count < totalCount {
                startPage += 10
                fetchTrendInfo()
                print("prefetch: \(indexPath)")
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("취소: \(indexPaths)")
    }
}
