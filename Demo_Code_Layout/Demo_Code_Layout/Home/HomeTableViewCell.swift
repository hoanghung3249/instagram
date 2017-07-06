//
//  HomeTableViewCell.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/7/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Firebase
import SwiftyJSON

class HomeTableViewCell: UITableViewCell {
    
    
    let labelName:UILabel = {
        let label:UILabel = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewBound:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgAvatar:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = false
        let imagePlaceHolder = UIImage(named: "placeholder")
        image.image = imagePlaceHolder
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    let imgStatus:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = false
        let imagePlaceHolder = UIImage(named: "placeholder")
        image.image = imagePlaceHolder
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var btnLike:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
        button.setImage(UIImage(named: "like"), for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(updateLike), for: .touchUpInside)
        return button
    }()
    
    lazy var btnComment:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
        button.setImage(UIImage(named: "Comment"), for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showComment(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var btnShare:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()
    
    lazy var btnShowLike:UIButton = { [unowned self] in
        let button:UIButton = UIButton()
//        button.setImage(UIImage(named: "share"), for: .normal)
        button.setTitle("Be the first to like!", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 13)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()
    
    let separatorView:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelStatus:UILabel = {
        let label:UILabel = UILabel()
        label.text = "Hello welcome to the Instagram"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var post:Post?
    
    var completionShowComment:((_ sender:UIButton)->())?
    
    //MAKR:- Init functions
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- Function support
    func addSubview() {
        self.contentView.addSubview(labelName)
        self.contentView.addSubview(imgAvatar)
        self.contentView.addSubview(imgStatus)
        self.contentView.addSubview(btnLike)
        self.contentView.addSubview(btnComment)
        self.contentView.addSubview(btnShare)
        self.contentView.addSubview(separatorView)
        self.contentView.addSubview(btnShowLike)
        self.contentView.addSubview(labelStatus)
    }
    
    
    func setupUI() {
        
        self.imgAvatar.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.leading.equalTo(self.contentView.snp.leading).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        
        self.labelName.snp.makeConstraints { (make) in
            make.top.equalTo(imgAvatar.snp.top)
            make.left.equalTo(imgAvatar.snp.right).offset(10)
            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(20)
        }
        
        self.imgStatus.snp.makeConstraints { (make) in
            make.top.equalTo(imgAvatar.snp.bottom).offset(10)
            make.right.equalTo(self.contentView.snp.right)
            make.left.equalTo(self.contentView.snp.left)
            make.height.equalTo(200)
        }
        
        self.btnLike.snp.makeConstraints { (make) in
            make.top.equalTo(imgStatus.snp.bottom).offset(10)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        self.btnComment.snp.makeConstraints { (make) in
            make.top.equalTo(btnLike.snp.top)
            make.left.equalTo(btnLike.snp.right).offset(20)
            make.width.equalTo(btnLike.snp.width)
            make.height.equalTo(btnLike.snp.height)
        }
        
        self.btnShare.snp.makeConstraints { (make) in
            make.top.equalTo(btnLike.snp.top)
            make.left.equalTo(btnComment.snp.right).offset(20)
            make.width.equalTo(btnLike.snp.width)
            make.height.equalTo(btnLike.snp.height)
        }
        
        self.separatorView.snp.makeConstraints { (make) in
            make.top.equalTo(btnLike.snp.bottom).offset(10)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.right.equalTo(self.contentView.snp.right)
            make.height.equalTo(0.5)
        }
        
        self.btnShowLike.snp.makeConstraints { (make) in
            make.top.equalTo(separatorView.snp.bottom).offset(5)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-40)
        }
        
        self.labelStatus.snp.makeConstraints { (make) in
            make.top.equalTo(btnShowLike.snp.bottom).offset(10)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.width.equalTo(self.contentView.snp.width)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        
    }
    
    
    func configCell(post:Post) {
        self.post = post
        self.labelName.text = post.userName
        self.labelStatus.text = post.status
        let urlAvatar = URL(string: post.avatarUrl)
        let urlStatus = URL(string: post.urlStatus)
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        btnLike.setImage(UIImage(named:imageName), for: .normal)
        guard let count = post.likeCount else {
            return
        }
        
        if count != 0 {
            btnShowLike.setTitle("\(count) Likes", for: .normal)
        } else if post.likeCount == 0 {
            btnShowLike.setTitle("Be the first to Like this", for: .normal)
        }
        DispatchQueue.main.async {
            self.imgAvatar.kf.setImage(with: urlAvatar)
            self.imgStatus.kf.setImage(with: urlStatus)
        }
    }
    
    
    
    func updateLike() {
        let postRef = Constants.refPost.child((post?.id)!)
        handleLike(postRef)
    }
    
    
    func showComment(_ sender:UIButton) {
        guard let completion = completionShowComment else { return }
        completion(sender)
    }
    
    private func handleLike(_ ref: FIRDatabaseReference) {
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unlike the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let postDictionary = snapshot?.value as? [String:Any] {
                let dataJSON = JSON(postDictionary)
                var postUpdate = Post(dataJSON: dataJSON)
                postUpdate.id = (snapshot?.key)!
                if let currentUserID = FIRAuth.auth()?.currentUser?.uid {
                    if postUpdate.likes != nil {
                        postUpdate.isLiked = postUpdate.likes![currentUserID] != nil
                    }
                }
                self.updateLikeState(post: postUpdate)
            }
        }
    }
    
    
    private func updateLikeState(post: Post) {
        self.post = post
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        btnLike.setImage(UIImage(named:imageName), for: .normal)
        
        // display a message for Likes
        guard let count = post.likeCount else {
            return
        }
        
        if count != 0 {
            btnShowLike.setTitle("\(count) Likes", for: .normal)
        } else if post.likeCount == 0 {
            btnShowLike.setTitle("Be the first to Like this", for: .normal)
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
