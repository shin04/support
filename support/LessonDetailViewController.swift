//
//  LessonDetailViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/23.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import RealmSwift

class LessonDetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var noticeSwich: RAMPaperSwitch!
    @IBOutlet var noticeMessage: UITextView!
    @IBOutlet var picker: UIDatePicker!
    @IBOutlet var navi: UINavigationBar?
    @IBOutlet var backgroundLabel: UILabel!
    
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
        
        //switchの設定
        noticeSwich.animationDidStartClosure = {(onAnimation: Bool) in
            UIView.transitionWithView(self.backgroundLabel, duration: self.noticeSwich.duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.backgroundLabel.textColor = onAnimation ? UIColor.whiteColor() : UIColor(red: 31/255.0, green: 183/255.0, blue: 252/255.0, alpha: 1)
                }, completion:nil)
        }
        
        //左スワイプ
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeGesture)
        
        //textViewに閉じるボタン追加
        let accessoryView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        accessoryView.backgroundColor = UIColor.whiteColor()
        let closeButton = UIButton(frame: CGRectMake(self.view.frame.size.width - 60, 0, 50, 30))
        closeButton.setTitle("完了", forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        closeButton.addTarget(self, action: "onClickCloseButton:", forControlEvents: .TouchUpInside)
        accessoryView.addSubview(closeButton)
        noticeMessage.inputAccessoryView = accessoryView
        
        let realm = try! Realm()
        if realm.objects(Notice)[0].noticeCheck == true {
            noticeSwich.on = true
            
            let now = NSDate()
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let comps:NSDateComponents = calendar!.components([NSCalendarUnit.Year, .Month, .Day], fromDate: now)
            comps.calendar = calendar
            comps.hour = realm.objects(Notice)[0].noticeHour
            comps.minute = realm.objects(Notice)[0].noticeMinute
            let now2 = comps.date
            print(now2!)
            picker.date = now2!
            noticeMessage.text = realm.objects(Notice)[0].noticeMg
        } else {
            noticeSwich.on = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //NotificationCenterクラスに通知を登録
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //NotificationCenterクラスに通知を解除
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let realm = try! Realm()
        if noticeSwich.on == true {
            print("noticeSwich is on")
            try! realm.write {
                realm.objects(Notice)[0].noticeCheck = true
            }
            //appDelegate.saveData.setBool(true, forKey: "lessonState")
        } else {
            print("noticeSwich is off")
            try! realm.write {
                realm.objects(Notice)[0].noticeCheck = false
            }
            //appDelegate.saveData.setBool(false, forKey: "lessonState")
        }
    }
    
    @IBAction func saveAc() {
        noticeMessage.resignFirstResponder()
        let realm = try! Realm()
        if realm.objects(Notice)[0].noticeCheck == true {
            try! realm.write {
                realm.objects(Notice)[0].noticeHour = Int(hour)!
                realm.objects(Notice)[0].noticeMinute = Int(minute)!
                if noticeMessage.text == nil {
                    realm.objects(Notice)[0].noticeMg = "今日の時間割です"
                } else {
                    realm.objects(Notice)[0].noticeMg = noticeMessage.text!
                }
            }
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
    
    func onClickCloseButton(sender: UIButton) {
        noticeMessage.resignFirstResponder()
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        print("スワイプ")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        //通知受け取り
        let userInfo = notification.userInfo!
        
        let duration: NSTimeInterval = ((userInfo[UIKeyboardAnimationDurationUserInfoKey])?.doubleValue)!
        UIView.animateWithDuration(duration) { () -> Void in
            
            //キーボードの高さだけViewをあげる
            let transform: CGAffineTransform = CGAffineTransformMakeTranslation(0, -150)
            self.view.transform = transform
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        //ずらした分だけ戻す
        let userInfo = notification.userInfo!
        let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration: NSTimeInterval = ((userInfo[UIKeyboardAnimationDurationUserInfoKey])?.doubleValue)!
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.transform = CGAffineTransformIdentity
        }
    }
    
}
