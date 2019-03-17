//
//  CommitsVC.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 17.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

class CommitsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1 //количество коммитов
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath)
        //if repoDescriptions.count != 0
        //{
        //    cell.textLabel?.text = repoDescriptions[indexPath.row].repoName
        //}
        return cell
    }
    
    @IBOutlet weak var commitsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        commitsTableView.rowHeight = 60
    }
    
}
