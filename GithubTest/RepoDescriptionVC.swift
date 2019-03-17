//
//  RepoDescriptionVC.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 16.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

extension UIImageView
{
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit)
    {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async()
            {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit)
    {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class RepoDescriptionVC: UIViewController
{
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var commitsButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        if let url = URL(string: repoDescriptions[myIndex].authorAvatar)
        {
            ownerAvatarImageView.downloadedFrom(url: url)
        }
        
        authorLabel.text = repoDescriptions[myIndex].authorName
        repoNameLabel.text = repoDescriptions[myIndex].repoName
        if let description = repoDescriptions[myIndex].repoDescription
        {
            repoDescriptionLabel.text = "Описание: " + description
        }
        else
        {
            repoDescriptionLabel.text = "Описание: нет"
        }
        
        watchersLabel.text = "Watchers: " + String(repoDescriptions[myIndex].watchersCount)
        forksCountLabel.text = "Forks: " + String(repoDescriptions[myIndex].forksCount)
    }
    
    @IBAction func commitButtonTapped(_ sender: UIButton)
    {
        request.getCommitsRequest(ownerName: repoDescriptions[myIndex].authorName, repoName: repoDescriptions[myIndex].repoName)
    }
    


}
