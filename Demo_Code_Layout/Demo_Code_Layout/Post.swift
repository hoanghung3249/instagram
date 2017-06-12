//
//  Post.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/8/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import Foundation

struct Post {
    
    var id:String = ""
    var status:String = ""
    var uid:String = ""
    var urlStatus:String = ""
    var avatarUrl:String = ""
    var userName:String = ""
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
}
