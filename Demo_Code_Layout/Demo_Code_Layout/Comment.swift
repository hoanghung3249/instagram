//
//  Comment.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/10/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Comment {
    
    var id:String = ""
    var username:String?
    var avatarUrl:String?
    var comment:String?
    
    init(dataJSON:JSON) {
        self.username = dataJSON["username"].string ?? ""
        self.avatarUrl = dataJSON["avatar"].string ?? ""
        self.comment = dataJSON["comment"].string ?? ""
    }
    
}
