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
    
    var hour: String!
    var minute: String!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeSwich.on = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pickerAc() {
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
        } else {
            print("noticeSwich is off")
        }
    }
    
    @IBAction func saveAc() {
        appDelegate.noticeMg = noticeMessage.text!
        appDelegate.noticeHour = Int(hour)!
        appDelegate.noticeMinute = Int(minute)!
        print("\(noticeMessage.text!) and \(time) is saved")
    }

}
