//
//  ReposListVC.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 16.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

var myIndex = 0

class ReposListVC: UIViewController, RepoDelegate, UITableViewDelegate, UITableViewDataSource
{
    func reloadTableView()
    {
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return repoDescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if repoDescriptions.count != 0
        {
            cell.textLabel?.text = repoDescriptions[indexPath.row].repoName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        myIndex = indexPath.row
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        tableView.delegate = self
        tableView.dataSource = self
        request.repoDelegate = self
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton)
    {
        buttonTapped = true
        navigationController?.popViewController(animated: true)
    }
    
}
