//
//  ParseManager.swift
//  support
//
//  Created by 梶原大進 on 2015/12/13.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import Parse

var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

class ParseManager {
    class func readDate() {
        let query = PFQuery(className: "memo")
        query.orderByAscending("createBy")
        query.findObjectsInBackgroundWithBlock { objects, error in
            if(error == nil){
                appDelegate.memoObjects = [PFObject]()
                appDelegate.memoObjects = objects!
                print("success")
            }else {
                print(error)
            }
            
        }
    }
    
    class func saveDate(titles: NSMutableArray, contacts: NSMutableArray, username: NSString) {
        let object = PFObject(className: "memo")
        object["title"] = titles
        object["contents"] = contacts
        object["createBy"] = username
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("save date")
                // self.appDelegate.memoObjects[number] = object
            } else {
                print(error)
            }
        }
    }

}