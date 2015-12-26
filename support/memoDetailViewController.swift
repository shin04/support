//
//  memoDetailViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/12/17.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit

class memoDetailViewController: UIViewController {
    @IBOutlet var noticeSwich: UISwitch!
    @IBOutlet var noticeMessage: UITextView!
    @IBOutlet var picker: UIDatePicker!
    
//    var hour: String!
//    var minute: String!
    var date: NSDate!
    
    var selectCell: Int!
    var keyStr: String!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCell = appDelegate.saveData.objectForKey("cellNum") as! Int
        keyStr = "memoState" + String(selectCell)
        print("key is \"\(keyStr)\"")
        
        //appDelegate.saveData.setBool(false, forKey: keyStr)
        
        if appDelegate.saveData.objectForKey(keyStr) as? Bool == true{
            noticeSwich.on = true
            
            let dateKey: String = keyStr + "date"
            
            picker.date = appDelegate.noticeDic[dateKey] as! NSDate
        } else {
            noticeSwich.on = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pickerAc() {
        date = picker.date
        print(date)
    }
    
    @IBAction func swichAc() {
        if noticeSwich.on == true {
            print("noticeSwich is on")
            appDelegate.saveData.setBool(true, forKey: keyStr)
        } else {
            print("noticeSwich is off")
            appDelegate.saveData.setBool(false, forKey: keyStr)
        }
    }
    
    @IBAction func saveAc() {
//        let hourKey: String = keyStr + "hour"
//        let minuteKey: String = keyStr + "minute"
        let dateKey: String = keyStr + "date"
        appDelegate.noticeDic[keyStr] = noticeMessage.text!
//        appDelegate.noticeDic[hourKey] = hour
//        appDelegate.noticeDic[minuteKey] = minute
        appDelegate.noticeDic[dateKey] = date
        print("keyStr = \(keyStr), \(appDelegate.noticeDic[dateKey])")
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
