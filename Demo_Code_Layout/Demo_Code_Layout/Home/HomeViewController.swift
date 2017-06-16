//
//  HomeViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 5/31/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import Firebase
import ACProgressHUD_Swift
import Kingfisher

class HomeViewController: UITableViewController {
    deinit {
        print("deinit home")
    }
    
    let aut = FIRAuth.auth()
    let cellId = "cell"
    let ref = FIRDatabase.database().reference()
    var curUser:User?
    
    var arrPost = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.setupNavigation()
        self.tabBarController?.tabBar.isTranslucent = false
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 350.0
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .none
        getCurrentUser()
        getListPost()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Init functions
    func setupNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Billabong", size: 30)!]
        self.navigationItem.title = "Instagram"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    
    
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
        let postRef = ref.child("Post")
        postRef.observe(.childAdded, with: { [unowned self] (snapshot) in
            guard let value = snapshot.value as? Dictionary<String,AnyObject> else { return }
            var post = Post()
            post.id = snapshot.key
            post.status = value["status"] as? String ?? ""
            post.uid = value["uid"] as? String ?? ""
            post.urlStatus = value["url"] as? String ?? ""
            post.avatarUrl = value["urlAvatar"] as? String ?? ""
            post.userName = value["username"] as? String ?? ""
            post.likeCount = value["likeCount"] as? Int ?? 0
            post.likes = value["likes"] as? Dictionary<String,Any>
            if let currentUserID = FIRAuth.auth()?.currentUser?.uid {
                if post.likes != nil {
                    post.isLiked = post.likes![currentUserID] != nil
                }
            }
            self.arrPost.insert(post, at: 0)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }
        }) { (error) in
            ProgressHUD.showError(error.localizedDescription)
        }
    }
    
    private func getCurrentUser() {
        let userRef = ref.child("User").child((aut?.currentUser?.uid)!)
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            guard let value = snapshot.value as? Dictionary<String,AnyObject> else { return }
            var currentUser = User()
            currentUser.avatarUrl = value["avatar"] as? String ?? ""
            currentUser.username = value["username"] as? String ?? ""
            currentUser.email = value["email"] as? String ?? ""
            currentUser.uid = self.aut?.currentUser?.uid ?? ""
            self.curUser = currentUser
        }) { (error) in
            ProgressHUD.showError(error.localizedDescription)
        }
    }
    
    
}

extension HomeViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeTableViewCell
        if arrPost.count != 0 {
            let post = arrPost[indexPath.row]
            cell.post = post
        }
        
        cell.completionShowComment = { [unowned self] sender in
            if sender == cell.btnComment {
                let commentVC = CommentViewController()
                commentVC.curUser = self.curUser
                commentVC.postID = self.arrPost[indexPath.row].id
                commentVC.hidesBottomBarWhenPushed = true
                self.navigationController?.navigationBar.tintColor = .black
                self.navigationController?.pushViewController(commentVC, animated: true)
            }
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}



