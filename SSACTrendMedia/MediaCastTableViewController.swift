//
//  MediaCastViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit

class MediaCastTableViewController: UIViewController {
    var titleSpace: String?
    var tvShowData: TvShow?
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var mediaCastTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleSpace ?? "PlaceHolder"
        mediaCastTableView.delegate = self
        mediaCastTableView.dataSource = self
        let nibName = UINib(nibName: MediaCastTableViewCell.identifier, bundle: nil)
        mediaCastTableView.register(nibName, forCellReuseIdentifier: MediaCastTableViewCell.identifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backBtnClicked))
        titleLabel.text = tvShowData?.title
        posterImageView.image = UIImage(named: tvShowData!.title)
        
    }
    
    @objc func backBtnClicked() {
        // Push - Pop
        // 기본 backBtn을 오버라이드 하면서 엣지슬라이드 기능 불가
        // Push: Dissmiss X, Present: Pop X
        self.navigationController?.popViewController(animated: true)
        // self.dismiss(animated: true)
    }
    
}

extension MediaCastTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaCastTableViewCell.identifier, for: indexPath) as? MediaCastTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}


