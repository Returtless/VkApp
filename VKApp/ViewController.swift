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
    }
    
    @IBAction func loginWasPressed(_ sender: UIButton) {
        let login = loginField.text!
        let password = passwordField.text!
        
        
        if login == "admin" && password == "123456" {
            createDialogWindow(title: "", message: "Вы успешно авторизовались!")
        } else {
            loginField.text = nil
            passwordField.text = nil
            createDialogWindow(title: "Внимание!", message: "Вы ввели неверную комбинацию логин/пароль")
        }
    }
    
    
    @objc func keyboardWasShown(notification: Notification) {
        print("keboard is shown")
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

