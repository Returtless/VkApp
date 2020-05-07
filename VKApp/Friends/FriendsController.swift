//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import Alamofire

class FriendsController: UIViewController, UINavigationControllerDelegate {
    
    var usersBySections: [(letter: String, users: [User])] = []
    var users : [User] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendSearchBar: FriendsSearchBar!
    
    var sorterControl: SorterBarControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = CGFloat(70)
        sorterControl = SorterBarControl()
        sorterControl.addTarget(self, action: #selector(sorterBarWasChanged), for: .valueChanged)
        view.addSubview(sorterControl)
        
        let params: Parameters = [
            "fields": "nickname, domain, sex, photo_100"
        ]
        
        VKServerFactory.getServerData(
            method: VKServerFactory.Methods.getFriends,
            with: params, typeName: User.self,
            completion: {
                [weak self] array in
                self?.users = array as! [User]
                self?.usersBySections = Database.getSortedUsersData(self!.users)
                self?.sorterControl.letters = self!.usersBySections.map({$0.letter})
                self?.sorterControl.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    self!.sorterControl.widthAnchor.constraint(equalToConstant: CGFloat(20)),      self!.sorterControl.heightAnchor.constraint(equalToConstant: CGFloat(30*self!.sorterControl.letters.count)), self!.sorterControl.centerYAnchor.constraint(equalTo: self!.tableView.centerYAnchor),
                    self!.sorterControl.trailingAnchor.constraint(equalTo: self!.view.trailingAnchor)
                ])
                self?.tableView.reloadData()
            }
        )
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbumSegue" {
            let photoAlbumVC = segue.destination as! PhotoListViewController
            if let index = tableView.indexPathForSelectedRow {
                let user = usersBySections[index.section].users[index.row]
                
                photoAlbumVC.userId = user.id
                photoAlbumVC.title = "\(user.firstName) \(user.lastName)"
            }
        }
    }
    
    @objc func sorterBarWasChanged(_ sender: SorterBarControl) {
        let indexPath = IndexPath(row: 0, section: usersBySections.firstIndex(where: {$0.letter == sender.choosedLetter}) ?? 0)
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension FriendsController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { self.usersBySections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  self.usersBySections[section].users.count }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(self.usersBySections[section].letter)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FriendTableViewCell
        let user = usersBySections[indexPath.section].users[indexPath.row]
        cell.userLabel.text = "\(user.firstName) \(user.lastName)"
        cell.userLabel.font = .systemFont(ofSize: CGFloat(16))
        if let image = UIImage.getImage(from: user.photo100) {
            cell.photoView.imageView.image = image
        }
        
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options:.curveEaseInOut,
            animations: {
                cell.frame.origin.x+=70
        })
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8,
                       animations: {
                        cell.alpha = 1
                        
        })
    }
}
extension FriendsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        usersBySections = Database.getSortedUsersData(users)
        if (!searchText.isEmpty){
            for i in 0..<usersBySections.count {
                usersBySections[i].users = usersBySections[i].users.filter({$0.lastName.range(of:  searchText, options: .caseInsensitive) != nil || $0.firstName.range(of:  searchText, options: .caseInsensitive) != nil })
            }
            usersBySections.removeAll(where: {$0.users.isEmpty})
        }
        sorterControl.letters = usersBySections.map({$0.letter})
        tableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        friendSearchBar.endEditing(true)
    }
}

