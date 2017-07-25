//
//  HomeCell.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 7/13/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Firebase
import SwiftyJSON

protocol LikePostDelegate: class {
    func updateLike(postUpdate:Post, row:Int)
    func showComment(post:Post)
}

class HomeCell: ASCellNode {
    
    weak var delegate:LikePostDelegate!
    
    fileprivate var labelName:ASTextNode!
    fileprivate var imgAvatar:ASNetworkImageNode!
    fileprivate var imgStatus:ASNetworkImageNode!
    fileprivate var btnLike:ASButtonNode!
    fileprivate var btnComment:ASButtonNode!
    fileprivate var btnShare:ASButtonNode!
    fileprivate var separatorView:ASDisplayNode!
    fileprivate var labelStatus:ASTextNode!
    fileprivate var btnShowLike:ASButtonNode!

    
    
    var post:Post?
    var row:Int?
    
    init(post:Post) {
        super.init()
        self.post = post
        //Setup Data
        self.labelName = ASTextNode()
        self.labelName.attributedText = NSAttributedString(string: post.userName, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)])
        
        self.imgAvatar = ASNetworkImageNode()
        imgAvatar.cornerRadius = 25
        imgAvatar.clipsToBounds = true
        imgAvatar.contentMode = .scaleAspectFill
        imgAvatar?.url = URL(string: post.avatarUrl)
        imgAvatar.shouldRenderProgressImages = true
        
        
        self.imgStatus = ASNetworkImageNode()
        imgStatus.contentMode = .scaleAspectFill
        imgStatus?.url = URL(string: post.urlStatus)
        imgStatus.shouldRenderProgressImages = true
        
        self.btnLike = ASButtonNode()
        btnLike.addTarget(self, action: #selector(updateLike), forControlEvents: .touchUpInside)
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        btnLike.setImage(UIImage(named:imageName), for: .normal)
        btnLike.imageNode.contentMode = .scaleAspectFit
        
        
        self.btnComment = ASButtonNode()
        btnComment.setImage(UIImage(named: "Comment"), for: .normal)
        btnComment.imageNode.contentMode = .scaleAspectFit
        btnComment.addTarget(self, action: #selector(showComment(_:)), forControlEvents: .touchUpInside)
        
        self.btnShare = ASButtonNode()
        btnShare.setImage(UIImage(named: "share"), for: .normal)
        btnShare.imageNode.contentMode = .scaleAspectFit
        
        self.separatorView = ASDisplayNode()
        separatorView.backgroundColor = .lightGray
        
        self.labelStatus = ASTextNode()
        labelStatus.attributedText = NSAttributedString(string: post.status, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
        
        
        guard let count = post.likeCount else {
            return
        }
        self.btnShowLike = ASButtonNode()
        btnShowLike.contentHorizontalAlignment = .left
        if count != 0 {
            var countString = ""
            if count == 1 {
                countString = "\(count) Like"
            } else {
                countString = "\(count) Likes"
            }
            btnShowLike.setTitle(countString, with: UIFont.italicSystemFont(ofSize: 13), with: .black, for: .normal)
        } else if post.likeCount == 0 {
            btnShowLike.setTitle("Be the first to Like this", with: UIFont.italicSystemFont(ofSize: 13), with: .black, for: .normal)
        }
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        labelName.style.flexShrink = 1.0
        let lblNameInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 20)
        let lblNameInset = ASInsetLayoutSpec(insets: lblNameInsets, child: labelName)
        
        
        imgAvatar.style.preferredSize = CGSize(width: 50, height: 50)
        let avatarInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 5)
        let avatarInset = ASInsetLayoutSpec(insets: avatarInsets, child: imgAvatar)
        
        let headerStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10.0, justifyContent: .start, alignItems: .baselineFirst, children: [avatarInset,lblNameInset])
        
        let headerInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let headerWithInset = ASInsetLayoutSpec(insets: headerInsets, child: headerStackSpec)
        
        //Get cell width
        let cellWidth = constrainedSize.max.width
        imgStatus.style.preferredSize = CGSize(width: cellWidth, height: 250)
        let photoImageViewAbsolute = ASAbsoluteLayoutSpec(children: [imgStatus])
        
        //Layout for button
        btnLike.style.preferredSize = CGSize(width: 20, height: 20)
        btnComment.style.preferredSize = CGSize(width: 20, height: 20)
        btnShare.style.preferredSize = CGSize(width: 20, height: 20)
        
        let buttonInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        let buttonLikeInset = ASInsetLayoutSpec(insets: buttonInsets, child: btnLike)
        let buttonComInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let buttonCommentInset = ASInsetLayoutSpec(insets: buttonComInsets, child: btnComment)
        let buttonShareInset = ASInsetLayoutSpec(insets: buttonComInsets, child: btnShare)
        let buttonStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .center, children: [buttonLikeInset,buttonCommentInset,buttonShareInset])
        
        //Layout for separator view
        separatorView.style.preferredSize = CGSize(width: cellWidth, height: 0.5)
        let separatorInsets = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 0)
        let separatorInset = ASInsetLayoutSpec(insets: separatorInsets, child: separatorView)
        
        //Layout for button show like
        let buttonShowLikeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        let btnShowLikeInset = ASInsetLayoutSpec(insets: buttonShowLikeInsets, child: btnShowLike)
        
        //Layout for status 
        labelStatus.style.flexShrink = 1.0
        let lblStatusInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        let lblStatusInset = ASInsetLayoutSpec(insets: lblStatusInsets, child: labelStatus)
        let lblStatusStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .center, children: [lblStatusInset])
        
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.alignItems = .stretch
        verticalStack.children = [headerWithInset, photoImageViewAbsolute, buttonStack, separatorInset,btnShowLikeInset,lblStatusStack]

        return verticalStack
    }
    
    
    func updateLike() {
        let postRef = Constants.refPost.child((post?.id)!)
        handleLike(postRef)
    }
    
    
    func showComment(_ sender:UIButton) {
        delegate.showComment(post: self.post!)
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
            var countString = ""
            if count == 1 {
                countString = "\(count) Like"
            } else {
                countString = "\(count) Likes"
            }
            btnShowLike.setTitle(countString, with: UIFont.italicSystemFont(ofSize: 13), with: .black, for: .normal)
        } else if post.likeCount == 0 {
            btnShowLike.setTitle("Be the first to Like this", with: UIFont.italicSystemFont(ofSize: 13), with: .black, for: .normal)
        }
        guard let row = self.row else { return }
        delegate.updateLike(postUpdate: post, row: row)
    }
    
    
}
