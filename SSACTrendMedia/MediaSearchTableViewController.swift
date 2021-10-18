//
//  MediaSearchTableViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit

class MediaSearchTableViewController: UIViewController {
    @IBOutlet weak var mediaSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaSearchTableView.delegate = self
        mediaSearchTableView.dataSource = self
        let nibName = UINib(nibName: MediaSearchTableViewCell.identifier, bundle: nil)
        mediaSearchTableView.register(nibName, forCellReuseIdentifier: MediaSearchTableViewCell.identifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(closeBtnClicked))
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 320, height: 0))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    @objc func closeBtnClicked () {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MediaSearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaSearchTableViewCell.identifier, for: indexPath) as? MediaSearchTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}


