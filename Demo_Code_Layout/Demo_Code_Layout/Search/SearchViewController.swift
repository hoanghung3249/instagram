//
//  SearchViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/7/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    lazy var searchBar:UISearchBar = UISearchBar()
    var isSearching = false
    let cellId = "cellId"
    
    
    let ref = FIRDatabase.database().reference()
    var arrUser = [User]()
    var arrFilterUser = [User]()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableview()
        self.getListUser()
    }
    
    
    //MARK:- Support functions
    private func setupTableview() {
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: cellId)
        self.tableView.estimatedRowHeight = 150
        self.tableView.separatorStyle = .none
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    
    //MARK:- Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearching = false
            self.arrFilterUser.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            self.isSearching = true
            self.arrFilterUser = arrUser.filter({ (user) -> Bool in
                let name = user.username
                let searchName = name.lowercased().contains(searchText.lowercased())
                return searchName
            })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    
    //MARK:- Call API get list User
    private func getListUser() {
        let userRef = ref.child("User")
        ProgressHUD.show()
        userRef.observe(.childAdded, with: { [unowned self] (snapshot) in
            guard let value = snapshot.value as? Dictionary<String,AnyObject> else { return }
            var userProfile = User()
            userProfile.uid = snapshot.key
            userProfile.email = value["email"] as? String ?? ""
            userProfile.username = value["username"] as? String ?? ""
            userProfile.avatarUrl = value["avatar"] as? String ?? ""
            self.arrUser.append(userProfile)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }
        }) { (error) in
            ProgressHUD.showError(error.localizedDescription)
        }
    }

}



extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching {
            return arrFilterUser.count
        } else {
            return arrUser.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchCell
        
        if isSearching {
            let userProfile = self.arrFilterUser[indexPath.row]
            cell.user = userProfile
        } else {
            let userProfile = self.arrUser[indexPath.row]
            cell.user = userProfile
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}



