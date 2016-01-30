//
//  ViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/10/31.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var navi: UINavigationBar?
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let appDomain:String = NSBundle.mainBundle().bundleIdentifier!
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
//        appDelegate.saveData.setObject(4, forKey: "cellCount")
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
    }
    
    override func viewDidAppear(animated: Bool) {
        //ログインしているかどうか
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            appDelegate.username = currentUser?.username
            
            if appDelegate.saveData.objectForKey("noticeDic") != nil {
                appDelegate.noticeDic = appDelegate.saveData.objectForKey("noticeDic")?.mutableCopy() as! NSMutableDictionary
            }
            
            print("You are a member of the app!")
        } else {
            print("You are not a member of the app.")
            
            let segue: outsetViewController = self.storyboard?.instantiateViewControllerWithIdentifier("outset") as! outsetViewController
            segue.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(segue, animated: true, completion: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signOut() {
        PFUser.logOut()
        print("See you!")
        viewDidAppear(true)
    }
    
}


