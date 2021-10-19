//
//  ViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/18.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnGroup: UIStackView!
    @IBOutlet weak var mediaTableView: UITableView!
    @IBOutlet weak var bookBtn: UIButton!
    
    let tvShowInformation = TvShowInformation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaTableView.delegate = self
        mediaTableView.dataSource = self
        
        btnGroup.layer.cornerRadius = 10
        btnGroup.layer.shadowOpacity = 0.3
        btnGroup.layer.shadowColor = UIColor.black.cgColor
        btnGroup.layer.shadowOffset = CGSize(width: 0, height: 0)
        btnGroup.layer.shadowRadius = 10
        btnGroup.layer.masksToBounds = false
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
        vc.tvShowData = tvShowInformation.tvShow[selectButton.tag]
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .automatic
        self.present(nav, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShowInformation.tvShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier, for: indexPath) as? MediaTableViewCell else {
            return UITableViewCell()
        }
        
        let row = tvShowInformation.tvShow[indexPath.row]
        
        cell.containerView.layer.cornerRadius = 10
        cell.containerView.layer.shadowOpacity = 0.3
        cell.containerView.layer.shadowColor = UIColor.black.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.containerView.layer.shadowRadius = 10
        cell.containerView.layer.masksToBounds = false
        
        cell.genreHashtagLabel.text = row.genre
        cell.titleLabel.text = row.title
        cell.posterImageView.image = UIImage(named: row.title)
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
        let row = tvShowInformation.tvShow[indexPath.row]
        vc.tvShowData = row
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

