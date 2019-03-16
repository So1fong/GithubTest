//
//  Request.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 15.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import Foundation


protocol RequestDelegate
{
    func reloadTableView()
    //func showAlertController()
    //func showSessionAlertController()
    //func getSession(session: String)
}

class Request
{
    var base64LoginAndPassword = ""
    var reposArray: [String] = []
    var delegate: RequestDelegate?
    
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
                        //self.delegate?.showSessionAlertController()
                    }
                }
                return
            }
            guard let data = data else { return }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                //self.reposArray.append(json.value(forKey: "name") as! String)
                //print(self.reposArray, self.reposArray.count)
                //print("value for key public repos \(json.value(forKey: "public_repos"))")
                //if jsonResult.value(forKey: "status") as! String == "OK",
                //    let routes = jsonResult.value(forKey: "routes") as? NSArray,
                //    let legs = routes.value(forKey: "legs") as? NSArray,
                //    let duration = legs.value(forKey: "duration_in_traffic") as? NSArray {
                    
                //    for i in 0..<duration.count {
                //        let timeDuration = duration[i] as! NSArray
                //        if let time = timeDuration.value(forKey: "value") as? NSArray {
                //            print("Current Time: \(Int(time[0] as! NSNumber)/60) Min")
                //
                //        }
                 //   }
                //}
                
                //let answer = try JSONDecoder().decode(newSessionAnswer.self, from: data)
                //print("Parsed:")
                //print(answer)
                //let str: String = answer.data.session
                //idSession = str
                //print("sessionId = \(idSession)")
                //self.delegate?.getSession(session: idSession)
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
                        //self.delegate?.showSessionAlertController()
                    }
                }
                return
            }
            guard let data = data else { return }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                print(json)
                for i in 0..<json.count
                {
                    let dictResult = json.object(at: i) as! NSDictionary
                    self.reposArray.append(dictResult.value(forKey: "name") as! String)
                }
                self.delegate?.reloadTableView()
                print(self.reposArray, self.reposArray.count)
            }
            catch
            {
                print(error)
            }
            }.resume()
    }
}
