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
    }
    
    override func viewWillAppear(animated: Bool) {
        //キーボードのだあ仕入れのの時に呼び出す通知をNotificationCenterクラスに登録
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
        noticeMessage.resignFirstResponder()
        
        let dateKey: String = keyStr + "date"
        appDelegate.noticeDic[keyStr] = noticeMessage.text!
        appDelegate.noticeDic[dateKey] = date
        print("keyStr = \(keyStr), \(appDelegate.noticeDic[dateKey])")
        
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
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
