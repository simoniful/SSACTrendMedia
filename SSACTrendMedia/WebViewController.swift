//
//  WebViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/19.
//
import Alamofire
import SwiftyJSON
import Kingfisher
import WebKit
import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webview: WKWebView!
    
    var tvShowData: TrendInfo?
    var baseURL: String = "https://www.naver.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tvShowData?.title ?? "PlaceHolder"
        searchBar.delegate = self
        openWebPage(to: baseURL)
        fetchVideoData()
    }
    
    @objc func fetchVideoData() {
        if let mediaId = tvShowData?.mediaId {
            let url = "https://api.themoviedb.org/3/movie/\(mediaId)/videos?api_key=\(APIKey.TMDB)&language=ko"
            AF.request(url, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    let linkKeyArr = json["results"].arrayValue
                    if linkKeyArr.isEmpty {
                        self.openWebPage(to: self.baseURL)
                    } else {
                        let linkKey = linkKeyArr[0]["key"].stringValue
                        self.baseURL = "https://www.youtube.com/watch?v=\(linkKey)"
                        self.openWebPage(to: self.baseURL)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func goBackBtnClicked(_ sender: UIBarButtonItem) {
        if webview.canGoBack {
            webview.goBack()
        }
    }
    
    @IBAction func reloadBtnClicked(_ sender: UIBarButtonItem) {
        webview.reload()
    }
    
    @IBAction func goForwardBtnClicked(_ sender: UIBarButtonItem) {
        if webview.canGoForward {
            webview.goForward()
        }
    }
    
    func openWebPage(to urlStr: String) {
        guard let url = URL(string: urlStr) else {
            print("Invalid URL")
            return
        }
        let requset = URLRequest(url: url)
        webview.load(requset)
    }

}

extension WebViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(to: searchBar.text ?? "")
    }
}
