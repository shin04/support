//
//  ViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/10/31.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var navi: UINavigationBar?
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let appDomain:String = NSBundle.mainBundle().bundleIdentifier!
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
}


