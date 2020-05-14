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
    let onlyRealm = false
    
    var sectionNames : [String] = [] //массив с буквами для секций
    var allUserLastNameFirstLetters : [String] = [] //массив первых букв всех юзеров для отслеживания изменений
    var users : ResultsForUser? {
        didSet{
            initUserArrays()
        }
    }
    var usersToken: NotificationToken?
    
    
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
        DataService.getAllFriends(
            completion: {
                [weak self] array in
                self?.users = array!.sorted(byKeyPath: "lastName")
                self?.pairTableAndRealm()
                self?.initSorterControl()
                self?.tableView.reloadData()
            }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbumSegue" {
            let photoAlbumVC = segue.destination as! PhotoListViewController
            if let index = tableView.indexPathForSelectedRow, let user = users?.getUserForIndexPathAndLetter(letter: sectionNames[index.section], row: index.row, section: index.section) {
                photoAlbumVC.userId = user.id
                photoAlbumVC.title = "\(user.firstName) \(user.lastName)"
            }
        }
    }
    
    @objc func sorterBarWasChanged(_ sender: SorterBarControl) {
        let indexPath = IndexPath(row: 0, section: sectionNames.firstIndex(where: {$0 == sender.choosedLetter}) ?? 0)
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func initUserArrays(){
        //инициализация всех дополнительных массивов и сортера
        allUserLastNameFirstLetters = users!.map({
            if let first = $0.lastName.first {
                return String(first)
            } else {
                return ""
            }
        })
        sectionNames = Array<String>(Set(allUserLastNameFirstLetters)).sorted()
        initSorterControl()
    }
    
    func initSorterControl(){
        sorterControl.letters = sectionNames
        sorterControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sorterControl.widthAnchor.constraint(equalToConstant: CGFloat(20)),      sorterControl.heightAnchor.constraint(equalToConstant: CGFloat(30*sorterControl.letters.count)), sorterControl.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            sorterControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    func pairTableAndRealm() {
        guard (try? Realm()) != nil else { return }
        usersToken = users?.observe { (changes: RealmCollectionChange) in
            guard let tableView = self.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ self.calculateIndexPathInTableViewWithUpdateData(for: $0)}), with: .automatic)
                tableView.deleteRows(at: deletions.map({
                    self.calculateIndexPathInTableViewWithUpdateData(from: $0)
                }), with: .automatic)
                
                tableView.reloadRows(at: modifications.map({ modifiedRow in
                    if(self.users![modifiedRow].lastName.first == self.allUserLastNameFirstLetters[modifiedRow].first){
                        return self.calculateIndexPath(for: modifiedRow)
                    } else {
                        let oldPath = self.calculateIndexPath(for: modifiedRow)
                        self.allUserLastNameFirstLetters.remove(at: modifiedRow)
                        if (self.allUserLastNameFirstLetters.filter({$0 == self.sectionNames[oldPath.section]}).isEmpty){
                            self.sectionNames.remove(at: oldPath.section)
                            let indexSet = NSMutableIndexSet()
                            indexSet.add(oldPath.section)
                            self.tableView.deleteSections(indexSet as IndexSet, with: .automatic)
                        }
                        return self.calculateIndexPathInTableViewWithUpdateData(for: modifiedRow)
                    }
                }),with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
    }
    func calculateIndexPath(for x: Int) -> IndexPath {
        //получаем номер секции из которой удалили/изменили юзера. Так как в основном массиве запись ищменилась на лету, используем доп массив с буквами фамилий для вычисления по индексу
        let sec = self.sectionNames.firstIndex(where: {$0 ==  self.allUserLastNameFirstLetters[x]})
        //рассчитываем номер строки в секции
        var row = x
        for i in (0..<x).reversed() {
            if self.allUserLastNameFirstLetters[i] == self.allUserLastNameFirstLetters[x]{
                row-=1
            } else {
                break
            }
        }
        row = x - row
        return IndexPath(row: row, section: sec!)
    }
    
    func calculateIndexPathInTableViewWithUpdateData(for insertedRow : Int) -> IndexPath{
        //получаем первую букву фамилии нового юзера
        let firstLetterOfNewUser = { () -> String in
            if let first = self.users![insertedRow].lastName.first {
                return String(first)
            } else {
                return ""
            }}
        //ищем секцию по букве фамилии
        let nameSection = self.sectionNames.first(where: {$0 == firstLetterOfNewUser()})
        self.initUserArrays()
        let path = self.calculateIndexPath(for: insertedRow)
        //если секция по букве не существует, то надо добавить
        if nameSection == nil {
            tableView.insertSections(IndexSet([self.sectionNames.firstIndex(where: {$0 == firstLetterOfNewUser()})!]), with: .automatic)
        }
        return path
    }
    
    func calculateIndexPathInTableViewWithUpdateData(from deletedRow : Int) -> IndexPath{
        let path = self.calculateIndexPath(for: deletedRow)
        //при удалении юзера нужно удалить запись и из доп массива и из массива секций, если секция пустая
        self.allUserLastNameFirstLetters.remove(at: deletedRow)
        if (self.allUserLastNameFirstLetters.filter({$0 == self.sectionNames[path.section]}).isEmpty){
            self.sectionNames.remove(at: path.section)
            let indexSet = NSMutableIndexSet()
            indexSet.add(path.section)
            self.tableView.deleteSections(indexSet as IndexSet, with: .automatic)
            
        }
        return path
    }
}

extension FriendsController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { self.sectionNames.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let predicate = NSPredicate(format:
            sectionNames[section] == "" ? "lastName == ''" : "lastName BEGINSWITH[c] '\(sectionNames[section])'")
        return users!.filter(predicate).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FriendTableViewCell
        if let user = users?.getUserForIndexPathAndLetter(letter: sectionNames[indexPath.section], row: indexPath.row, section: indexPath.section) {
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
            let params : Parameters = [
                "lastName" : searchText
            ]
            users = DataService.getDataFromRealm(params: params)?.sorted(byKeyPath: "lastName")
        } else {
            users = DataService.getDataFromRealm()?.sorted(byKeyPath: "lastName")
        }
        initUserArrays()
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
