//
//  MediaCastViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit
import Kingfisher

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
        
        let overviewNibName = UINib(nibName: MediaCastOverviewTableViewCell.identifier, bundle: nil)
        mediaCastTableView.register(overviewNibName, forCellReuseIdentifier: MediaCastOverviewTableViewCell.identifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backBtnClicked))
        let url = URL(string: tvShowData?.backdropImage ?? "")
        bgImageView.kf.setImage(with: url)
        titleLabel.text = tvShowData?.title
        titleLabel.textColor = .white
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let overviewCell = tableView.dequeueReusableCell(withIdentifier: MediaCastOverviewTableViewCell.identifier, for: indexPath) as? MediaCastOverviewTableViewCell else {
                return UITableViewCell()
            }
            return overviewCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaCastTableViewCell.identifier, for: indexPath) as? MediaCastTableViewCell else {
                return UITableViewCell()}
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 130 : 90
    }
    
    
}


