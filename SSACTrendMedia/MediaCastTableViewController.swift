//
//  MediaCastViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class MediaCastTableViewController: UIViewController {
    var titleSpace: String?
    var tvShowData: TrendInfo?
    var isOpened = false
    var castData: [CastModel] = []
    var crewData: [CrewModel] = []
    
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
        
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(tvShowData?.backdropImage.replacingOccurrences(of: "\\" , with: "") ?? "")") {
            bgImageView.kf.setImage(with: url)
        } else {
            bgImageView.image = UIImage(systemName: "star")
        }
        
        titleLabel.text = tvShowData?.title
        titleLabel.textColor = .white
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(tvShowData?.posterImage.replacingOccurrences(of: "\\" , with: "") ?? "")") {
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(systemName: "star")
        }
        
        fetchCastData()
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func expansionToggleBtnClicked(selectButton: UIButton) {
        isOpened = !isOpened
        mediaCastTableView.reloadSections(IndexSet(0...0), with: .automatic)
        // mediaCastTableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
    }
    
    @objc func fetchCastData() {
        if let mediaId = tvShowData?.mediaId {
            print(mediaId)
            let url = "https://api.themoviedb.org/3/movie/\(mediaId)/credits?api_key=\(APIKey.TMDB)&language=ko"
            AF.request(url, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    self.castData = json["cast"].arrayValue.map({
                        CastModel(name: $0["name"].stringValue, profile: $0["profile_path"].stringValue, character: $0["character"].stringValue)
                    })
                    self.crewData = json["crew"].arrayValue.map({
                        CrewModel(name: $0["name"].stringValue, profile: $0["profile_path"].stringValue, job: $0["job"].stringValue)
                    })
                    self.mediaCastTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}

extension MediaCastTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return castData.count
        } else {
            return crewData.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Cast"
        } else if section == 2 {
            return "Crew"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let overviewCell = tableView.dequeueReusableCell(withIdentifier: MediaCastOverviewTableViewCell.identifier, for: indexPath) as? MediaCastOverviewTableViewCell else {
                return UITableViewCell()
            }
            let lines = isOpened ? 0 : 3
            overviewCell.overViewLabel.text = tvShowData?.overview
            overviewCell.overViewLabel.numberOfLines = lines
            let image = isOpened ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
            overviewCell.expansionToggleBtn.setImage(image, for: .normal)
            overviewCell.expansionToggleBtn.addTarget(self, action: #selector(expansionToggleBtnClicked), for: .touchUpInside)
            return overviewCell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaCastTableViewCell.identifier, for: indexPath) as? MediaCastTableViewCell else {
                return UITableViewCell()}
            let row = castData[indexPath.row]
            cell.castActorNameLabel.text = row.name
            cell.castCharNameLabel.text = row.character
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(row.profile.replacingOccurrences(of: "\\" , with: ""))") {
                cell.castImageView.kf.setImage(with: url)
            } else {
                cell.castImageView.image = UIImage(systemName: "star")
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaCastTableViewCell.identifier, for: indexPath) as? MediaCastTableViewCell else {
                return UITableViewCell()}
            let row = crewData[indexPath.row]
            cell.castActorNameLabel.text = row.name
            cell.castCharNameLabel.text = row.job
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(row.profile.replacingOccurrences(of: "\\" , with: ""))") {
                cell.castImageView.kf.setImage(with: url)
            } else {
                cell.castImageView.image = UIImage(systemName: "star")
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}


