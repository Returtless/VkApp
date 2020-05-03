//
//  ViewController.swift
//  weatherApp
//
//  Created by Владислав Лихачев on 24.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cloudIndicator: CloudIndicator!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7444930"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        //нужно отключить интерактивность, чтоб кнопки не нажимались под анимацией
        // self.view.isUserInteractionEnabled = false
        //        cloudIndicator.configure()
        //        UIView.animate(withDuration: 1, delay : 5, animations: {
        //            self.cloudIndicator.alpha = 0
        //        })
        
        helloLabel.alpha = 0
        //        UIView.animate(withDuration: 2, delay : 6, animations: {
        //            self.helloLabel.alpha = 1
        //        }, completion : { _ in self.helloLabel.alpha = 0})
        //        scrollView.alpha = 0
        //        UIView.animate(withDuration: 2, delay : 8, animations: {
        //            self.scrollView.alpha = 1
        //        }, completion : { _ in self.view.isUserInteractionEnabled = true})
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "loginSegue":
            
            let isAuth = login()
            
            if !isAuth {
                loginField.text = nil
                passwordField.text = nil
                createDialogWindow(title: "Внимание!", message: "Вы ввели неверную комбинацию логин/пароль")
            }
            
            return isAuth
        default:
            return true
        }
    }
    
    func login() -> Bool {
        let login = loginField.text!
        let password = passwordField.text!
        
        return login == "admin" && password == "123456"
    }
    
    
    @objc func keyboardWasShown(notification: Notification) {
        
        let userInfo = (notification as NSNotification).userInfo as! [String: Any]
        let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        scrollBottomConstraint.constant = -frame.height
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        scrollBottomConstraint.constant = 0
    }
    
    func createDialogWindow(title ttl : String, message msg : String){
        let alert = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        if let unwrappedToken = token, let unwrappedId = params["user_id"] {
            let session = Session.instance
            session.token = unwrappedToken
            session.userId = Int(unwrappedId)!
            print(unwrappedToken)
            print(unwrappedId)
        }
        decisionHandler(.cancel)
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
}

extension UIImage {
    static func getImage(from string: String) -> UIImage? {
        guard let url = URL(string: string)
            else {
                print("Unable to create URL")
                return nil
        }

        var image: UIImage? = nil
        do {
            let data = try Data(contentsOf: url, options: [])
            image = UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
        }
        return image
    }
}
