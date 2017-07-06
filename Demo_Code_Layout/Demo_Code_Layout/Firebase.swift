//
//  Firebase.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 7/6/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import Foundation
import Firebase

let aut = FIRAuth.auth()

struct Firebase {
    
    static let shared = Firebase()
    let ref = FIRDatabase.database().reference()
    
    func getData(_ tableName:String,_ eventType:FIRDataEventType, completion: @escaping (_ data:Dictionary<String,AnyObject>?,_ key:String?,_ error:String?)->()) {
        ref.child(tableName).observe(eventType, with: { (snapshot) in
            completion(snapshot.value as? Dictionary<String, AnyObject>, snapshot.key, nil)
        }) { (error) in
            completion(nil, nil, error.localizedDescription)
        }
    }
    
    func getCurUser(_ tableName:String,_ uid:String,_ eventType:FIRDataEventType, completion: @escaping (_ data:Dictionary<String,AnyObject>?,_ key:String?,_ error:String?)->()) {
        ref.child(tableName).child(uid).observeSingleEvent(of: eventType, with: { (snapshot) in
            completion(snapshot.value as? Dictionary<String,AnyObject>, snapshot.key, nil)
        }) { (error) in
            completion(nil, nil, error.localizedDescription)
        }
    }
    
}
