//
//  WebViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/19.
//

import WebKit
import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webview: WKWebView!
    
    var tvShowData: TvShow?
    var baseURL: String = "https://www.naver.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tvShowData?.title ?? "PlaceHolder"
        searchBar.delegate = self
        openWebPage(to: baseURL)
        
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
