//
//  CommitsVC.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 17.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

class CommitsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CommitDelegate
{
    func reloadTableView()
    {
        DispatchQueue.main.async
        {
            self.commitsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return commit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath) as! CommitTableViewCell
        if commit.count != 0
        {
            cell.hashLabel.text = commit[indexPath.row].sha
            cell.messageLabel.text = commit[indexPath.row].message
            cell.authorLabel.text = commit[indexPath.row].author
            cell.dateLabel.text = commit[indexPath.row].date
        }
        return cell
    }
    
    @IBOutlet weak var commitsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        commitsTableView.delegate = self
        commitsTableView.dataSource = self
        request.commitDelegate = self
        commitsTableView.rowHeight = 150
    }
}
