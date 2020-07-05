//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

typealias ResultsForUser = Results<User>

class FriendsController: UIViewController, UINavigationControllerDelegate {
    var users : ResultsForUser? {
        didSet{
            if users != nil {
            initSorterControl()
            pairTableAndRealm()
            }
        }
    }
    private var photoService: PhotoService?
    
    var usersToken: NotificationToken?
    var sorterControl: SorterBarControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendSearchBar: FriendsSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = CGFloat(70)
        photoService = PhotoService(container: tableView)
        sorterControl = SorterBarControl()
        sorterControl.addTarget(self, action: #selector(sorterBarWasChanged), for: .valueChanged)
        view.addSubview(sorterControl)
        users = RealmService.getData()?.sorted(byKeyPath: "lastName")
        DataService.updateAllFriends()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbumSegue" {
            let photoAlbumVC = segue.destination as! PhotoListViewController
            if let index = tableView.indexPathForSelectedRow, let user = users?.getUserForIndexPathAndLetter(letter: sorterControl.letters[index.section], row: index.row, section: index.section) {
                photoAlbumVC.userId = user.id
                photoAlbumVC.title = "\(user.firstName) \(user.lastName)"
            }
        }
    }
    
    @objc func sorterBarWasChanged(_ sender: SorterBarControl) {
        let indexPath = IndexPath(row: 0, section: sender.letters.firstIndex(where: {$0 == sender.choosedLetter}) ?? 0)
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func calculateSectionNames() -> [String]{
        //инициализация всех дополнительных массивов и сортера
        let allUserLastNameFirstLetters : [String] = users!.map({
            if let first = $0.lastName.first {
                return String(first)
            } else {
                return ""
            }
        })
        return Array<String>(Set(allUserLastNameFirstLetters)).sorted()
    }
    
    func initSorterControl(){
        sorterControl.letters = calculateSectionNames()
        sorterControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sorterControl.widthAnchor.constraint(equalToConstant: CGFloat(20)),      sorterControl.heightAnchor.constraint(equalToConstant: CGFloat(30*sorterControl.letters.count)), sorterControl.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            sorterControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    func pairTableAndRealm() {
        usersToken = users?.observe { (changes: RealmCollectionChange) in
            guard let tableView = self.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_,_,_,_):
                self.initSorterControl()
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}

extension FriendsController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { self.sorterControl.letters.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let predicate = NSPredicate(format:
            sorterControl.letters[section] == "" ? "lastName == ''" : "lastName BEGINSWITH[c] '\(sorterControl.letters[section])'")
        return users!.filter(predicate).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sorterControl.letters[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FriendTableViewCell
        if let user = users?.getUserForIndexPathAndLetter(letter: sorterControl.letters[indexPath.section], row: indexPath.row, section: indexPath.section) {
            cell.userLabel.text = "\(user.firstName) \(user.lastName)"
            cell.userLabel.font = .systemFont(ofSize: CGFloat(16))
            if let image = photoService?.getPhoto(atIndexPath: indexPath, byUrl: user.photo100) {
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
        }
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
        if (!searchText.isEmpty){
            users = RealmService.getData(for: ("lastName", "CONTAINS[c]", "String"), with: searchText)
        } else {
            users = RealmService.getData()?.sorted(byKeyPath: "lastName")
        }
        tableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        friendSearchBar.endEditing(true)
    }
}

extension ResultsForUser {
    
    func getUserForIndexPathAndLetter(letter: String, row: Int, section : Int) -> User? {
        let predicate = NSPredicate(format: letter == "" ? "lastName == ''" : "lastName BEGINSWITH[c] '\(letter)'")
        return self.filter(predicate)[row]
    }
}
