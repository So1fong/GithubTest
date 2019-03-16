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
}

protocol AlertControllerDelegate
{
    func showAlertController()
    func doSegue()
}

var success: Bool = false

class Request
{
    var base64LoginAndPassword = ""
    var reposArray: [String] = []
    var requestDelegate: RequestDelegate?
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
                let result = self.stringify(json: json, prettyPrinted: false)
                //let badString = "Bad credentials"
                if (result.contains("Bad credentials")) || (result.contains("Requires authentication"))
                    {
                        print("success false")
                        success = false
                        self.alertControllerDelegate?.showAlertController()
                    }
                   else
                   {
                        success = true
                   }
                print("SUCCESS \(success)")
                print("SUCCESS???")
                if success
                {
                    print("SUCCESS???")
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
                        //self.delegate?.showSessionAlertController()
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
                    print(json)
                    for i in 0..<json.count
                    {
                        let dictResult = json.object(at: i) as! NSDictionary
                        self.reposArray.append(dictResult.value(forKey: "name") as! String)
                    }
                    self.requestDelegate?.reloadTableView()
                    print(self.reposArray, self.reposArray.count)
                }

            }
            catch
            {
                print(error)
            }
            }.resume()
    }
}
