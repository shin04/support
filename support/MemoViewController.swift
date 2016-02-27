//
//  MemoViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/06.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import RealmSwift

class MemoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var contentText: UITextView!
    @IBOutlet var navi: UINavigationBar?
    
    var cellNum: Int = 0
    
    var indicator: UIActivityIndicatorView!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
        
        titleText.delegate = self
        contentText.delegate = self
        
        //textViewに閉じるボタン追加
        let accessoryView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        accessoryView.backgroundColor = UIColor.whiteColor()
        let closeButton = UIButton(frame: CGRectMake(self.view.frame.size.width - 60, 0, 50, 30))
        closeButton.setTitle("完了", forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        closeButton.addTarget(self, action: "onClickCloseButton:", forControlEvents: .TouchUpInside)
        accessoryView.addSubview(closeButton)
        contentText.inputAccessoryView = accessoryView
        
        cellNum = appDelegate.saveData.objectForKey("cellNum") as! Int
        
        //titleText.text = appDelegate.contactTitle[cellNum] as? String
        //contentText.text = appDelegate.contactContent[cellNum] as? String
        
        let realm = try! Realm()
        titleText.text = realm.objects(Memo)[cellNum].title as String
        contentText.text = realm.objects(Memo)[cellNum].content as String
        
        //左スワイプ
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeGesture)
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
        self.makeIndicator()
        
        titleText.resignFirstResponder()
        contentText.resignFirstResponder()
        
        let realm = try! Realm()
        try! realm.write {
            realm.objects(Memo)[cellNum].title = titleText.text!
            realm.objects(Memo)[cellNum].content = contentText.text!
        }
        
        print("\(realm.objects(Memo)[cellNum].title as String)に更新")
        
        indicator.stopAnimating()
        
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
        contentText.resignFirstResponder()
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        print("スワイプ")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makeIndicator() {
        // インジケータを作成する.
        indicator = UIActivityIndicatorView()
        indicator.frame = CGRectMake(0, 0, 50, 50)
        indicator.center = self.view.center
        indicator.color = UIColor.blackColor()
        
        // アニメーションを開始する.
        indicator.startAnimating()
        
        // インジケータをViewに追加する.
        self.view.addSubview(indicator)
    }

}
