//
//  MemoViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/06.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import Parse

class MemoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var contentText: UITextView!
    
    var cellNum: Int = 0
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.delegate = self
        contentText.delegate = self
        
        cellNum = appDelegate.saveData.objectForKey("cellNum") as! Int
        
        titleText.text = appDelegate.contactTitle[cellNum] as? String
        contentText.text = appDelegate.contactContent[cellNum] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAc() {
        titleText.resignFirstResponder()
        contentText.resignFirstResponder()
        
        appDelegate.contactTitle[cellNum] = titleText.text!
        appDelegate.contactContent[cellNum] = contentText.text
        
        ParseManager.saveDate(appDelegate.contactTitle, contacts: appDelegate.contactContent, username: appDelegate.username!)
        
//        let object = PFObject(className: "memo")
//        object["title"] = self.appDelegate.contactTitle
//        object["contents"] = self.appDelegate.contactContent
//        object["createBy"] = appDelegate.username
//        object.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError?) -> Void in
//            if (success) {
//                print("save date")
//            } else {
//                print(error)
//            }
//        }
        
//        print("\(titleText.text!),\(contentText.text)を保存します")
//        appDelegate.contactTitle[cellNum] = titleText.text!
//        appDelegate.contactContent[cellNum] = contentText.text
//        print("\(appDelegate.contactTitle[cellNum]),\(appDelegate.contactContent[cellNum])を保存しました")
//        
//        appDelegate.saveData.setObject(appDelegate.contactTitle, forKey: "title")
//        appDelegate.saveData.setObject(appDelegate.contactContent, forKey: "content")
//        appDelegate.saveData.synchronize()
//        
//        let saveAlert = UIAlertController(title: "確認", message: "保存しました", preferredStyle: .Alert)
//        let ok:UIAlertAction = UIAlertAction(title: "OK",
//            style: UIAlertActionStyle.Cancel,
//            handler:{
//                (action:UIAlertAction!) -> Void in
//                print("OK")
//        })
//        
//        saveAlert.addAction(ok)
//        presentViewController(saveAlert, animated: true, completion: nil)
    }

}
