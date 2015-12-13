//
//  setLessonViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/03.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import Parse

class setLessonViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var firstLesson: UITextField!
    @IBOutlet var secondLesson: UITextField!
    @IBOutlet var thirdLesson: UITextField!
    @IBOutlet var fourthLesson: UITextField!
    @IBOutlet var fifthLesson: UITextField!
    @IBOutlet var sixthLesson: UITextField!
    @IBOutlet var seventhLesson: UITextField!
    
    @IBOutlet var dayPicker: UIPickerView!
    let dayArray: NSArray = ["choose","MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY"]
    
    var dayStr: NSString = ""
    var dayNum: Int = 0
    
    var lessonArray: NSMutableArray!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //時間割の読み込み
        let query = PFQuery(className: "Lessons")
        query.whereKey("createBy", equalTo: appDelegate.username as! String)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        query.getObjectInBackgroundWithId(object.objectId!) {
                            (lesson: PFObject?, error: NSError?) -> Void in
                            if lesson![self.dayStr as String] != nil {
                                let array = lesson![self.dayStr as String] as! NSMutableArray
                                self.firstLesson.text = array[0] as? String
                                self.secondLesson.text = array[1] as? String
                                self.thirdLesson.text = array[2] as? String
                                self.fourthLesson.text = array[3] as? String
                                self.fifthLesson.text = array[4] as? String
                                self.sixthLesson.text = array[5] as? String
                                self.seventhLesson.text = array[6] as? String
                            }
                        }
                    }
                }
            } else {
            }
        }
        
//        let query = PFQuery(className:appDelegate.username as! String)
//        //query.whereKey("number", equalTo:dayNum)
//        query.whereKey("kind", equalTo:"lesson")
//        query.findObjectsInBackgroundWithBlock { objects, error in
//            if error == nil {
//                if let objects = objects{
//                    for object in objects {
//                        query.getObjectInBackgroundWithId(object.objectId!) {
//                            (lesson: PFObject?, error: NSError?) -> Void in
//                            if lesson![self.dayStr as String] != nil {
//                                let array = lesson![self.dayStr as String] as! NSMutableArray
//                                self.firstLesson.text = array[0] as? String
//                                self.secondLesson.text = array[1] as? String
//                                self.thirdLesson.text = array[2] as? String
//                                self.fourthLesson.text = array[3] as? String
//                                self.fifthLesson.text = array[4] as? String
//                                self.sixthLesson.text = array[5] as? String
//                                self.seventhLesson.text = array[6] as? String
//                            }
//                        }
//                    }
//                }
//            } else {
//                print("error")
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        dayStr = dayArray[row] as! NSString
        dayNum = row
        
        firstLesson.text = nil
        secondLesson.text = nil
        thirdLesson.text = nil
        fourthLesson.text = nil
        fifthLesson.text = nil
        sixthLesson.text = nil
        seventhLesson.text = nil
        
        self.viewDidLoad()
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //データ保存
    @IBAction func saveAc() {
        lessonArray = [firstLesson.text!, secondLesson.text!, thirdLesson.text!, fourthLesson.text!, fifthLesson.text!, sixthLesson.text!, seventhLesson.text!]
        self.save(lessonArray)
    }
    
    //データ保存
    func save(lessonData: NSArray) {
        let object = PFObject(className: "Lessons")
        object[dayStr as String] = lessonData
        object["createBy"] = appDelegate.username
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("save date")
            } else {
                print(error)
            }
        }
        
//        let query = PFQuery(className:appDelegate.username as! String)
//        query.whereKey("kind", equalTo:"lesson")
//        query.findObjectsInBackgroundWithBlock { objects, error in
//            if error == nil {
//                for object in objects! {
//                    query.getObjectInBackgroundWithId(object.objectId!) {
//                        (lesson: PFObject?, error: NSError?) -> Void in
//                        
//                        print(object.objectId!)
//                        
//                        //let saveData = PFObject(className: self.appDelegate.username as! String)
//                        lesson![self.dayStr as String] = lessonData
//                        lesson!.saveInBackgroundWithBlock {
//                            (success: Bool, error: NSError?) -> Void in
//                            if (success) {
//                                print("sucsess")
//                                print("\(lesson![self.dayStr as String]) is saved")
//                            } else {
//                                print("\(error)")
//                            }
//                        }
//                    }
//                }
//            } else {
//                print("error")
//            }
//        }
    }

}
