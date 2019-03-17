//
//  Request.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 15.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import Foundation


protocol RepoDelegate
{
    func reloadTableView()
}

protocol CommitDelegate
{
    func reloadTableView()
}

protocol AlertControllerDelegate
{
    func showAuthenticationAlertController()
    func showConnectionAlertController()
    func doSegue()
}

struct RepoDescription
{
    var repoName: String = ""
    var repoDescription: String? = ""
    var authorName = ""
    var authorAvatar = ""
    var forksCount: Int = 0
    var watchersCount: Int = 0
}

struct CommitDescription
{
    var sha: String = ""
    var message: String = ""
    var author: String = ""
    var date: String = ""
}

func nullToNil(value : AnyObject?) -> AnyObject?
{
    if value is NSNull
    {
        return nil
    }
    else
    {
        return value
    }
}

var repoDescriptions: [RepoDescription] = [RepoDescription()]
var commit: [CommitDescription] = [CommitDescription()]
var success: Bool = false

class Request
{
    var base64LoginAndPassword = ""
    var repoDelegate: RepoDelegate?
    var commitDelegate: CommitDelegate?
    var alertControllerDelegate: AlertControllerDelegate?
    
    func stringify(json: Any, prettyPrinted: Bool = false) -> String
    {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted
        {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        do
        {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8)
            {
                return string
            }
        } catch
        {
            print(error)
        }
        
        return ""
    }
    
    func authenticationRequest(username: String, password: String)
    {
        guard let url = URL(string: "https://api.github.com/user") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let combinedString = username + ":" + password
        if let encodingString = combinedString.data(using: .utf8)?.base64EncodedString()
        {
            request.setValue("Basic " + encodingString, forHTTPHeaderField: "Authorization")
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            base64LoginAndPassword = encodingString
        }
        session.dataTask(with: request) { (data, response, error)  in
            if error != nil
            {
                if let error = error as NSError?
                {
                    if error.domain == NSURLErrorDomain || error.code == NSURLErrorCannotConnectToHost
                    {
                        print("error")
                        self.alertControllerDelegate?.showConnectionAlertController()
                    }
                }
                return
            }
            guard let data = data else { return }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                //print(json)
                let result = self.stringify(json: json, prettyPrinted: false)
                if (result.contains("Bad credentials")) || (result.contains("Requires authentication"))
                    {
                        success = false
                        self.alertControllerDelegate?.showAuthenticationAlertController()
                    }
                   else
                   {
                        success = true
                   }
                if buttonTapped
                {

                }
                if success
                {
                    self.alertControllerDelegate?.doSegue()
                }
            }
            catch
            {
                print(error)
            }
            }.resume()

    }
    
    func getReposRequest()
    {
        guard let url = URL(string: "https://api.github.com/user/repos") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic " + base64LoginAndPassword, forHTTPHeaderField: "Authorization")
        session.dataTask(with: request) { (data, response, error)  in
            if error != nil
            {
                if let error = error as NSError?
                {
                    if error.domain == NSURLErrorDomain || error.code == NSURLErrorCannotConnectToHost
                    {
                        print("error")
                        self.alertControllerDelegate?.showConnectionAlertController()
                    }
                }
                return
            }
            guard let data = data else { return }
            do
            {
                if success
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                    repoDescriptions = []
                    for i in 0..<json.count
                    {
                        repoDescriptions.append(RepoDescription())
                        let dictResult = json.object(at: i) as! NSDictionary
                        repoDescriptions[i].repoName = dictResult.value(forKey: "name") as! String
                        let value = dictResult.value(forKey: "description")
                        repoDescriptions[i].repoDescription = nullToNil(value: value as AnyObject) as? String
                        repoDescriptions[i].watchersCount = dictResult.value(forKey: "watchers_count") as! Int
                        repoDescriptions[i].forksCount = dictResult.value(forKey: "forks_count") as! Int
                        let ownerDict = dictResult.value(forKey: "owner") as! NSDictionary
                        repoDescriptions[i].authorName = ownerDict.value(forKey: "login") as! String
                        repoDescriptions[i].authorAvatar = ownerDict.value(forKey: "avatar_url") as! String
                    }
                    self.repoDelegate?.reloadTableView()
                }

            }
            catch
            {
                print(error)
            }
            }.resume()
    }
    
    func getCommitsRequest(ownerName: String, repoName: String)
    {
        guard let url = URL(string: "https://api.github.com/repos/" + ownerName + "/" + repoName + "/commits") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic " + base64LoginAndPassword, forHTTPHeaderField: "Authorization")
        session.dataTask(with: request) { (data, response, error)  in
            if error != nil
            {
                if let error = error as NSError?
                {
                    if error.domain == NSURLErrorDomain || error.code == NSURLErrorCannotConnectToHost
                    {
                        print("error")
                        self.alertControllerDelegate?.showConnectionAlertController()
                    }
                }
                return
            }
            guard let data = data else { return }
            do
            {
                if success
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                    commit = []
                    for i in 0..<json.count
                    {
                        
                        commit.append(CommitDescription())
                        let dictResult = json.object(at: i) as! NSDictionary
                        commit[i].sha = dictResult.value(forKey: "sha") as! String
                        let commitDict = dictResult.value(forKey: "commit") as! NSDictionary
                        let authorDict = commitDict.value(forKey: "author") as! NSDictionary
                        commit[i].author = authorDict.value(forKey: "name") as! String
                        commit[i].date = authorDict.value(forKey: "date") as! String
                        commit[i].message = commitDict.value(forKey: "message") as! String
                    }
                    self.commitDelegate?.reloadTableView()
                }
            }
            catch
            {
                print(error)
            }
            }.resume()
    }
}
