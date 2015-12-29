//
//  ParseManager.swift
//  support
//
//  Created by 梶原大進 on 2015/12/13.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import Parse

class ParseManager {
    class func saveData(className: String, username: String, column: String,data: AnyObject) {
        let query = PFQuery(className: className)
        query.whereKey("createBy", equalTo: username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error != nil {
                return
            }
            guard let objects = objects else {
                return
            }
            for object in objects {
                print("ID = \(object.objectId)")
                query.getObjectInBackgroundWithId(object.objectId!) {
                    (object: PFObject?, error: NSError?) -> Void in
                    
                    object![column] = data
                    
                    object!.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            print("save date")
                        } else {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}