//
//  Post.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/8/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import Foundation
import SwiftyJSON

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
    
    
    init(dataJSON:JSON) {
        self.status = dataJSON["status"].string ?? ""
        self.uid = dataJSON["uid"].string ?? ""
        self.urlStatus = dataJSON["url"].string ?? ""
        self.avatarUrl = dataJSON["urlAvatar"].string ?? ""
        self.userName = dataJSON["username"].string ?? ""
        self.likeCount = dataJSON["likeCount"].int ?? 0
        self.likes = dataJSON["likes"].dictionary ?? [:]
    }
    
}
