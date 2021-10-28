//
//  MediaSearchTableViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class MediaSearchTableViewController: UIViewController, UITableViewDataSourcePrefetching {
    // 셀이 화면에 보이기 전에 필요한 리소스를 미리 다운 받는 기능
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            // 데이터의 총량을 측정하여 엔드 설정 및
            if movieData.count - 1 == indexPath.row && movieData.count < totalCount {
                startPage += 10
                fetchMovieData(query: searchText)
                print("prefetch: \(indexPath)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // 사용자가 엄청 빨리 스크롤 해서 다운이 필요 없을 때
        print("취소: \(indexPaths)")
    }
    
    @IBOutlet weak var mediaSearchTableView: UITableView!
    
    var searchText = "가족"
    var startPage = 1
    var totalCount = 0
    var movieData: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaSearchTableView.prefetchDataSource = self
        mediaSearchTableView.delegate = self
        mediaSearchTableView.dataSource = self
        let nibName = UINib(nibName: MediaSearchTableViewCell.identifier, bundle: nil)
        mediaSearchTableView.register(nibName, forCellReuseIdentifier: MediaSearchTableViewCell.identifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(closeBtnClicked))
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 0))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        // fetchMovieData()
        searchBar.delegate = self
    }
    
    @objc func closeBtnClicked () {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 네이버 영화 네트워크 통신
    @objc func fetchMovieData (query: String) {
        if let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&display=10&start=\(startPage)"
            let headers: HTTPHeaders = [
                "X-Naver-Client-Id": "sQo8bKJ97OT7K0a8iOzW",
                "X-Naver-Client-Secret": "Wi8JKjRBvP"
            ]
            AF.request(url, method: .get, headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    for item in json["items"].arrayValue {
                        let title = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                        let image = item["image"].stringValue
                        let link = item["link"].stringValue
                        let userRating = item["userRating"].stringValue
                        let subtitle = item["subtitle"].stringValue
                        let pubData = item["pubDate"].stringValue
                        
                        let data = MovieModel(titleData: title, imageData: image, linkData: link, userRatingData: userRating, subtitleData: subtitle, pubData: pubData)
                        self.movieData.append(data)
                    }
                    // 다시 뷰 리로드 중요!
                    self.mediaSearchTableView.reloadData()
                    self.totalCount = json["total"].intValue
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension MediaSearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaSearchTableViewCell.identifier, for: indexPath) as? MediaSearchTableViewCell else {
            return UITableViewCell()
        }
        let row = movieData[indexPath.row]
        cell.titleLabel.text = row.titleData
        cell.overviewLabel.text = row.subtitleData
        cell.releaseDateLabel.text = row.pubData
        if let url = URL(string: row.imageData) {
            cell.posterImageView.kf.setImage(with: url)
        } else {
            cell.posterImageView.image = UIImage(systemName: "star")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension MediaSearchTableViewController: UISearchBarDelegate {
    // 검색 버튼(키보드 리턴키)을 눌렀을 때 실행
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            movieData.removeAll()
            startPage = 1
            searchText = text
            fetchMovieData(query: text)
            // 프로그래스 바 구현
        }
    }
    // 취소 버튼 눌렀을 때
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        movieData.removeAll()
        mediaSearchTableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    // 서치바에서 커서가 깜박이는 활성화가 시작할 때
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(#function)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
}

