//
//  WebViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/19.
//

import UIKit

class WebViewController: UIViewController {
    
    
    var tvShowData: TvShow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tvShowData?.title ?? "PlaceHolder"
        
    }
    
}
