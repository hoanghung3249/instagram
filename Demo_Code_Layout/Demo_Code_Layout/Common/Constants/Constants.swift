//
//  Constants.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 7/6/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import Foundation
import Firebase


struct Constants {
    
    
    static let ref              = FIRDatabase.database().reference()
    static let refUser          = FIRDatabase.database().reference().child("User")
    static let refPost          = FIRDatabase.database().reference().child("Post")
    static let refComment       = FIRDatabase.database().reference().child("Comment")
    static let refUserPost      = FIRDatabase.database().reference().child("UserPost")
}

struct TableName {
    static let user                 = "User"
    static let post                 = "Post"
    static let comment              = "Comment"
    static let userPost             = "UserPost"
}
