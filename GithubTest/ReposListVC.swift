//
//  ReposListVC.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 16.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

class ReposListVC: UIViewController, RequestDelegate, UITableViewDelegate, UITableViewDataSource
{
    func reloadTableView()
    {
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return request.reposArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if request.reposArray.count != 0
        {
            cell.textLabel?.text = request.reposArray[indexPath.row]
        }
        
        return cell
    }
    
    //func numberOfRows(inSection section: Int) -> Int
    //{
    //    return request.reposArray.count
    //}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        request.requestDelegate = self
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
