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
    let storage = FIRStorage.storage().reference(forURL: "gs://instagram-8a16d.appspot.com/")
    
    func getData(_ tableName:String,_ eventType:FIRDataEventType, completion: @escaping (_ data:Dictionary<String,AnyObject>?,_ key:String?,_ error:String?)->()) {
        ref.child(tableName).observe(eventType, with: { (snapshot) in
            completion(snapshot.value as? Dictionary<String, AnyObject>, snapshot.key, nil)
        }) { (error) in
            completion(nil, nil, error.localizedDescription)
        }
    }
    
    func getChildData(_ tableName:String,_ child:String,_ eventType:FIRDataEventType, completion: @escaping (_ data:Dictionary<String,AnyObject>?,_ key:String?,_ error:String?)->()) {
        ref.child(tableName).child(child).observe(eventType, with: { (snapshot) in
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
    
    func addNewData(_ tableName:String,_ child:String?,_ value:[String:AnyObject], completion: @escaping (_ data:AnyObject?,_ error:String?)->()) {
        if child != nil {
            ref.child(tableName).child(child!).childByAutoId().setValue(value, withCompletionBlock: { (error, data) in
                if error == nil {
                    completion(data, nil)
                } else {
                    completion(nil, error?.localizedDescription)
                }
            })
        } else {
            ref.child(tableName).childByAutoId().setValue(value, withCompletionBlock: { (error, data) in
                if error == nil {
                    completion(data, nil)
                } else {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }
    
    func uploadImage(_ imgUpload:UIImage,_ child:String, completion: @escaping (_ imgUrl:String?,_ imgName:String?,_ error:String?)->()) {
        let imageData = UIImagePNGRepresentation(imgUpload)
        let imgName = UUID().uuidString
        let name = imgName + ".jpg"
        let imgStorage = self.storage.child(child)
        let newImg = imgStorage.child(name)
        newImg.put(imageData!, metadata: nil) { (metadata, error) in
            if error == nil {
                guard let urlString = metadata?.downloadURL()?.absoluteString else { return }
                completion(urlString, imgName, nil)
            } else {
                completion(nil, nil,error?.localizedDescription)
            }
        }
    }
}
