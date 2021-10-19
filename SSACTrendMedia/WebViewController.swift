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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tvShowData?.title ?? "PlaceHolder"
        searchBar.delegate = self
    }
    
}

extension WebViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let url = URL(string: searchBar.text ?? "") else {
            print("ERROR")
            return
        }
        
        let request = URLRequest(url: url)
        webview.load(request)
    }
}
