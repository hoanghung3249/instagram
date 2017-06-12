//
//  CommentViewController.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/9/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class CommentViewController: UIViewController {
    
    let cellId = "cellId"
    
    var postID:String?
    var arrComment:[Comment] = []
    
    let ref = FIRDatabase.database().reference()
    let aut = FIRAuth.auth()?.currentUser
    var curUser:User?
    
    let viewInput:UIView =  {
        let view:UIView = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var btnSend:UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Send", for: .normal)
//        button.layer.cornerRadius = 2
//        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let txtComment:UITextField = {
        let textField:UITextField = UITextField()
        textField.placeholder = "Add a comment..."
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let tableView:UITableView = {
        let tbv:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tbv.backgroundColor = .white
        tbv.translatesAutoresizingMaskIntoConstraints = false
        return tbv
    }()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comment"
        self.addSubView()
        self.setupUI()
        self.setupTableView()
        self.loadComment()
    }
    
    //MARK:- Support functions
    private func addSubView() {
        self.view.addSubview(tableView)
        self.view.addSubview(viewInput)
        self.viewInput.addSubview(txtComment)
        self.viewInput.addSubview(btnSend)
    }
    
    private func setupUI() {
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.width.equalTo(self.view.snp.width)
        }
        
        self.viewInput.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(0)
            make.left.equalTo(tableView.snp.left)
            make.width.equalTo(tableView.snp.width)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        self.txtComment.snp.makeConstraints { (make) in
            make.top.equalTo(viewInput.snp.top).offset(5)
            make.left.equalTo(viewInput.snp.left).offset(5)
            make.bottom.equalTo(viewInput.snp.bottom).offset(-5)
        }
        
        self.btnSend.snp.makeConstraints { (make) in
            make.top.equalTo(txtComment.snp.top)
            make.left.equalTo(txtComment.snp.right).offset(1)
            make.right.equalTo(viewInput.snp.right).offset(-5)
            make.bottom.equalTo(txtComment.snp.bottom)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
    
    private func loadComment() {
        ProgressHUD.show()
        let postComment = ref.child("Comment").child(postID!)
        postComment.observe(.childAdded, with: { [unowned self] (snapshot) in
            guard let value = snapshot.value as? Dictionary<String,AnyObject> else {
                ProgressHUD.dismiss()
                return
            }
            var comment = Comment()
            comment.avatarUrl = value["avatar"] as? String ?? ""
            comment.comment = value["comment"] as? String ?? ""
            comment.username = value["username"] as? String ?? ""
            self.arrComment.append(comment)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }
        }) { (error) in
            ProgressHUD.showError(error.localizedDescription)
        }
        ProgressHUD.dismiss()
    }
    
    
    //MARK:- Action function
    func sendComment() {
        if txtComment.text == "" {
            ProgressHUD.showError("Please input your comment for this post!")
            return
        } else {
            guard let commentString = txtComment.text else { return }
            uploadComment(commentString)
        }
        
    }
    
    
    private func uploadComment(_ commentString:String) {
        ProgressHUD.show()
        let commentRef = ref.child("Comment").child(postID!).childByAutoId()
        var param:Dictionary<String,AnyObject> = Dictionary()
        param.updateValue(commentString as AnyObject, forKey: "comment")
        param.updateValue(curUser?.avatarUrl as AnyObject, forKey: "avatar")
        param.updateValue(curUser?.username as AnyObject, forKey: "username")
        commentRef.setValue(param) { [unowned self] (error, data) in
            if error == nil {
                self.txtComment.text = ""
                ProgressHUD.dismiss()
            } else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    

}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentCell
        if arrComment.count != 0 {
            let userComment = self.arrComment[indexPath.row]
            cell.comment = userComment
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}




