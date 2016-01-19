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
    @IBOutlet var navi: UINavigationBar?
    
    var date: NSDate!
    
    var selectCell: Int!
    var keyStr: String!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
        
        selectCell = appDelegate.saveData.objectForKey("cellNum") as! Int
        keyStr = "memoState" + String(selectCell)
        print("key is \"\(keyStr)\"")
        
        //appDelegate.saveData.setBool(false, forKey: keyStr)
        
        if appDelegate.saveData.objectForKey(keyStr) as? Bool == true{
            noticeSwich.on = true
            noticeMessage.text = appDelegate.noticeDic[keyStr] as! String
            let dateKey: String = keyStr + "date"
            picker.date = appDelegate.noticeDic[dateKey] as! NSDate
        } else {
            noticeSwich.on = false
        }
        
        //左スワイプ
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        //google analyticsの設定
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "memoDetail")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
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
        let dateKey: String = keyStr + "date"
        appDelegate.noticeDic[keyStr] = noticeMessage.text!
        appDelegate.noticeDic[dateKey] = date
        print("keyStr = \(keyStr), \(appDelegate.noticeDic[dateKey])")
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        print("スワイプ")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
