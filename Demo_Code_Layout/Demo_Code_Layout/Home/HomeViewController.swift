//
//  HomeViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 5/31/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift
import Kingfisher
import SwiftyJSON
import AsyncDisplayKit

class HomeViewController: ASViewController<ASDisplayNode> {
    deinit {
        print("deinit home")
    }
    
    let cellId = "cell"
    var curUser:User?
    
    var arrPost = [Post]()
    
    var tableNode:ASTableNode
    
    init() {
        tableNode = ASTableNode()
        super.init(node: tableNode)
        tableNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.setupNavigation()
        self.tabBarController?.tabBar.isTranslucent = false
//        self.registerCell()
        getCurrentUser()
        getListPost()
        tableNode.view.separatorStyle = .none
    }
    
    
    //MARK:- Init functions
    func setupNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Billabong", size: 30)!]
        self.navigationItem.title = "Instagram"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    
//    func registerCell() {
//        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: cellId)
//        tableView.estimatedRowHeight = 350.0
//        tableView.separatorInset = UIEdgeInsets.zero
//        tableView.separatorStyle = .none
//    }
    
    
    //MARK:- Action functions
    
    func logOut() {
        ProgressHUD.show("Waiting...")
        do {
            try aut?.signOut()
            ProgressHUD.showSuccess()
            let loginVC = ViewController()
            self.present(loginVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            ProgressHUD.showError(signOutError.localizedDescription)
        }
    }
    
    
    //MARK:- Support functions
    func getListPost() {
        ProgressHUD.show()
        var arrPostTmp = [Post]()
        Firebase.shared.getData(TableName.post, .childAdded) { [weak self] (data, key, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                guard let data = data else { return }
                let dataJSON = JSON(data)
                var post = Post(dataJSON: dataJSON)
                post.id = key!
                if let currentUserID = aut?.currentUser?.uid {
                    if post.likes != nil {
                        post.isLiked = post.likes![currentUserID] != nil
                    }
                }
                strongSelf.arrPost.insert(post, at: 0)
//                arrPostTmp.insert(post, at: 0)

                strongSelf.tableNode.insertRows(at: [IndexPath(row:0, section:0)], with: .none)
                DispatchQueue.main.async {
//                    strongSelf.tableView.reloadData()
//                    strongSelf.insertDataInTableView(arrPostTmp)
                    ProgressHUD.dismiss()
                }
            } else {
                ProgressHUD.showError(error!)
            }
        }
    }
    
    private func getCurrentUser() {
        Firebase.shared.getCurUser(TableName.user, (aut?.currentUser?.uid)!, .value) { [weak self] (data, key, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                guard let value = data else { return }
                var currentUser = User()
                currentUser.avatarUrl = value["avatar"] as? String ?? ""
                currentUser.username = value["username"] as? String ?? ""
                currentUser.email = value["email"] as? String ?? ""
                currentUser.uid = aut?.currentUser?.uid ?? ""
                strongSelf.curUser = currentUser
            } else {
                ProgressHUD.showError(error!)
            }
        }
    }
    
    
    private func insertDataInTableView(_ arrPost:[Post]) {
        self.arrPost = arrPost
        tableNode.reloadData()
//        let section = 0
//        var indexPaths = [IndexPath]()
//        arrPost.enumerated().forEach { (row, post) in
//            let path = IndexPath(row: row, section: section)
//            indexPaths.append(path)
//        }
//        tableNode.insertRows(at: indexPaths, with: .none)
    }
    
    
}

//extension HomeViewController {
//    
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrPost.count
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeTableViewCell
//        if arrPost.count != 0 {
//            let post = arrPost[indexPath.row]
//            cell.configCell(post: post)
//        }
//        
//        cell.completionShowComment = { [unowned self] sender in
//            if sender == cell.btnComment {
//                let commentVC = CommentViewController()
//                commentVC.curUser = self.curUser
//                commentVC.postID = self.arrPost[indexPath.row].id
//                commentVC.hidesBottomBarWhenPushed = true
//                self.navigationController?.navigationBar.tintColor = .black
//                self.navigationController?.pushViewController(commentVC, animated: true)
//            }
//        }
//        cell.completionUpdatePost = { [unowned self] post in
//            self.arrPost[indexPath.row] = post
//        }
//        
//        cell.selectionStyle = .none
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//}


extension HomeViewController:ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count 
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let post = self.arrPost[indexPath.row]
        let cellNode:ASCellNodeBlock = { _ in
            let cellNode = HomeCell(post: post)
            cellNode.selectionStyle = .none
            cellNode.row = indexPath.row
            cellNode.delegate = self
            return cellNode
        }
        return cellNode
    }
}

extension HomeViewController: LikePostDelegate {
    
    func updateLike(postUpdate: Post, row: Int) {
        self.arrPost[row] = postUpdate
    }
    
    func showComment(post: Post) {
        let commentVC = CommentViewController()
        commentVC.curUser = self.curUser
        commentVC.postID = post.id
        commentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
}



