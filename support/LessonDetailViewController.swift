//
//  LessonDetailViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/23.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit

class LessonDetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var noticeSwich: UISwitch!
    @IBOutlet var noticeMessage: UITextView!
    @IBOutlet var picker: UIDatePicker!
    @IBOutlet var navi: UINavigationBar?
    
    var hour: String!
    var minute: String!
    var date: NSDate!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
        
        //左スワイプ
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeGesture)
        
        //appDelegate.saveData.setBool(false, forKey: "lessonState")
        
        if appDelegate.saveData.objectForKey("lessonState") as? Bool == true{
            noticeSwich.on = true
            //picker.date = appDelegate.noticeDic["lessonDate"] as! NSDate
            let now = NSDate()
            print(now)
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let comps:NSDateComponents = calendar!.components([NSCalendarUnit.Year, .Month, .Day], fromDate: now)
            comps.calendar = calendar
            comps.hour = appDelegate.noticeDic["lessonHour"] as! Int
            comps.minute = appDelegate.noticeDic["lessonMinute"] as! Int
            let now2 = comps.date
            print(now2!)
            
            picker.date = now2!
            noticeMessage.text = appDelegate.noticeDic["lessonMg"] as! String
        } else {
            noticeSwich.on = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //google analyticsの設定
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "lessonDetail")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickerAc() {
        date = picker.date
        print("date")
        
        let hourFormatter: NSDateFormatter = NSDateFormatter()
        hourFormatter.dateFormat = "HH"
        hour = hourFormatter.stringFromDate(picker.date)
        
        let minuteFormatter: NSDateFormatter = NSDateFormatter()
        minuteFormatter.dateFormat = "mm"
        minute = minuteFormatter.stringFromDate(picker.date)
        
        print("\(hour):\(minute)")
    }
    
    @IBAction func swichAc() {
        if noticeSwich.on == true {
            print("noticeSwich is on")
            appDelegate.saveData.setBool(true, forKey: "lessonState")
        } else {
            print("noticeSwich is off")
            appDelegate.saveData.setBool(false, forKey: "lessonState")
        }
    }
    
    @IBAction func saveAc() {
        noticeMessage.resignFirstResponder()
        
        if appDelegate.saveData.objectForKey("lessonState") as! Bool == true{
            appDelegate.noticeDic["lessonMg"] = noticeMessage.text!
            appDelegate.noticeDic["lessonHour"] = Int(hour)!
            appDelegate.noticeDic["lessonMinute"] = Int(minute)!
            appDelegate.noticeDic["lessonDate"] = date
        print("\(noticeMessage.text!) and \(hour):\(minute) is saved")
        }
        
        let saveAlert = UIAlertController(title: "確認", message: "保存しました", preferredStyle: .Alert)
        let ok:UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                print("OK")
        })
        
        saveAlert.addAction(ok)
        presentViewController(saveAlert, animated: true, completion: nil)
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        print("スワイプ")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
