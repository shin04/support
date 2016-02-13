//
//  setLessonViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/03.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import RealmSwift

class setLessonViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {

    @IBOutlet var firstLesson: UITextField!
    @IBOutlet var secondLesson: UITextField!
    @IBOutlet var thirdLesson: UITextField!
    @IBOutlet var fourthLesson: UITextField!
    @IBOutlet var fifthLesson: UITextField!
    @IBOutlet var sixthLesson: UITextField!
    @IBOutlet var seventhLesson: UITextField!
    @IBOutlet var navi: UINavigationBar?
    @IBOutlet var setBtn: UIButton!
    
    var activeText: UITextField!
    
    @IBOutlet var dayPicker: UIPickerView!
    let dayArray: NSArray = ["choose", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    //var dayStr: NSString = ""
    var dayNum: Int = 0
    
    //var lessonArray: NSMutableArray!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初期化するかどうか
        if appDelegate.saveData.boolForKey("checkInit") != true {
            //初期化する
            Initialization.lessonInit()
            appDelegate.saveData.setBool(true, forKey: "checkInit")
        }
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
        
        //pickerの設定
        dayPicker.delegate = self
        dayPicker.dataSource = self
        
        //textfieldの設定
        firstLesson.delegate = self
        let label1:UILabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
        label1.text = "1"
        firstLesson.leftView = label1
        firstLesson.leftViewMode = UITextFieldViewMode.Always
        
        secondLesson.delegate = self
        let label2:UILabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
        label2.text = "2"
        secondLesson.leftView = label2
        secondLesson.leftViewMode = UITextFieldViewMode.Always
        
        thirdLesson.delegate = self
        let label3:UILabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
        label3.text = "3"
        thirdLesson.leftView = label3
        thirdLesson.leftViewMode = UITextFieldViewMode.Always
        
        fourthLesson.delegate = self
        let label4:UILabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
        label4.text = "4"
        fourthLesson.leftView = label4
        fourthLesson.leftViewMode = UITextFieldViewMode.Always
        
        fifthLesson.delegate = self
        let label5:UILabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
        label5.text = "5"
        fifthLesson.leftView = label5
        fifthLesson.leftViewMode = UITextFieldViewMode.Always
        
        sixthLesson.delegate = self
        let label6:UILabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
        label6.text = "6"
        sixthLesson.leftView = label6
        sixthLesson.leftViewMode = UITextFieldViewMode.Always
        
        seventhLesson.delegate = self
        let label7:UILabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
        label7.text = "7"
        seventhLesson.leftView = label7
        seventhLesson.leftViewMode = UITextFieldViewMode.Always
        
        //左スワイプ
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        //NotificationCenterクラスに通知を登録
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //NotificationCenterクラスの通知を解除
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func writeLessons(array: NSArray) {
        self.firstLesson.text = array[0] as? String
        self.secondLesson.text = array[1] as? String
        self.thirdLesson.text = array[2] as? String
        self.fourthLesson.text = array[3] as? String
        self.fifthLesson.text = array[4] as? String
        self.sixthLesson.text = array[5] as? String
        self.seventhLesson.text = array[6] as? String
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeText = textField
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //pickerに表示する列数を返す
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //pickerに表示する行数を返す
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayArray.count
    }
    
    //pickerに表示する値を返す
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dayArray[row] as? String
    }
    
    //pickerが選択された際に呼ばれる
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(dayArray[row])")
        dayNum = row
        
        firstLesson.text = nil
        secondLesson.text = nil
        thirdLesson.text = nil
        fourthLesson.text = nil
        fifthLesson.text = nil
        sixthLesson.text = nil
        seventhLesson.text = nil
        
        self.read()
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //データ保存のアクション
    @IBAction func saveAc() {
        self.save()
        
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
    
    //データ読み込み
    func read() {
        let realm = try! Realm()
        switch dayNum {
        case 1:
            firstLesson.text = realm.objects(Monday)[0].first
            secondLesson.text = realm.objects(Monday)[0].second
            thirdLesson.text = realm.objects(Monday)[0].third
            fourthLesson.text = realm.objects(Monday)[0].fourth
            fifthLesson.text = realm.objects(Monday)[0].fifth
            sixthLesson.text = realm.objects(Monday)[0].sixth
            seventhLesson.text = realm.objects(Monday)[0].seventh
        case 2:
            firstLesson.text = realm.objects(Tuesday)[0].first
            secondLesson.text = realm.objects(Tuesday)[0].second
            thirdLesson.text = realm.objects(Tuesday)[0].third
            fourthLesson.text = realm.objects(Tuesday)[0].fourth
            fifthLesson.text = realm.objects(Tuesday)[0].fifth
            sixthLesson.text = realm.objects(Tuesday)[0].sixth
            seventhLesson.text = realm.objects(Tuesday)[0].seventh
        case 3:
            firstLesson.text = realm.objects(Wednesday)[0].first
            secondLesson.text = realm.objects(Wednesday)[0].second
            thirdLesson.text = realm.objects(Wednesday)[0].third
            fourthLesson.text = realm.objects(Wednesday)[0].fourth
            fifthLesson.text = realm.objects(Wednesday)[0].fifth
            sixthLesson.text = realm.objects(Wednesday)[0].sixth
            seventhLesson.text = realm.objects(Wednesday)[0].seventh
        case 4:
            firstLesson.text = realm.objects(Thursday)[0].first
            secondLesson.text = realm.objects(Thursday)[0].second
            thirdLesson.text = realm.objects(Thursday)[0].third
            fourthLesson.text = realm.objects(Thursday)[0].fourth
            fifthLesson.text = realm.objects(Thursday)[0].fifth
            sixthLesson.text = realm.objects(Thursday)[0].sixth
            seventhLesson.text = realm.objects(Thursday)[0].seventh
            
        case 5:
            firstLesson.text = realm.objects(Friday)[0].first
            secondLesson.text = realm.objects(Friday)[0].second
            thirdLesson.text = realm.objects(Friday)[0].third
            fourthLesson.text = realm.objects(Friday)[0].fourth
            fifthLesson.text = realm.objects(Friday)[0].fifth
            sixthLesson.text = realm.objects(Friday)[0].sixth
            seventhLesson.text = realm.objects(Friday)[0].seventh
            
        case 6:
            firstLesson.text = realm.objects(Saturday)[0].first
            secondLesson.text = realm.objects(Saturday)[0].second
            thirdLesson.text = realm.objects(Saturday)[0].third
            fourthLesson.text = realm.objects(Saturday)[0].fourth
            fifthLesson.text = realm.objects(Saturday)[0].fifth
            sixthLesson.text = realm.objects(Saturday)[0].sixth
            seventhLesson.text = realm.objects(Saturday)[0].seventh
            
        default:
            print("エラー")
        }
    }
    
    //データ保存
    func save() {
        let realm = try! Realm()
        try! realm.write {
            switch dayNum {
            case 1:
                realm.objects(Monday)[0].first = firstLesson.text!
                realm.objects(Monday)[0].second = secondLesson.text!
                realm.objects(Monday)[0].third = thirdLesson.text!
                realm.objects(Monday)[0].fourth = fourthLesson.text!
                realm.objects(Monday)[0].fifth = fifthLesson.text!
                realm.objects(Monday)[0].sixth = sixthLesson.text!
                realm.objects(Monday)[0].seventh = seventhLesson.text!
                
            default:
                print("エラー")
            }
        }
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        if activeText == firstLesson || activeText == secondLesson ||
            activeText == thirdLesson || activeText == fourthLesson{
            return
        }
        
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
