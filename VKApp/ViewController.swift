//
//  ViewController.swift
//  weatherApp
//
//  Created by Владислав Лихачев on 24.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var cloudIndicator: CloudIndicator!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.view.isUserInteractionEnabled = false
        cloudIndicator.configure()
        UIView.animate(withDuration: 1, delay : 5, animations: {
            self.cloudIndicator.alpha = 0
        })

      helloLabel.alpha = 0
        UIView.animate(withDuration: 2, delay : 6, animations: {
            self.helloLabel.alpha = 1
        }, completion : { _ in self.helloLabel.alpha = 0})
        scrollView.alpha = 0
        UIView.animate(withDuration: 2, delay : 8, animations: {
            self.scrollView.alpha = 1
        }, completion : { _ in self.view.isUserInteractionEnabled = true})
        
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

