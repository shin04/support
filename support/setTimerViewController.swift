//
//  setTimerViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/14.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit

class setTimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet var timePicker: UIPickerView!
    
    var timeArray: NSMutableArray = ["--"]
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker?.delegate = self
        timePicker?.dataSource = self
        
        var a: Int = 5
        
        for(var i = 1; i <= 24; i++) {
            let str: NSString = a.description
            timeArray[i] = str
            print("\(timeArray[i])")
            a += 5
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - picker
    //pickerに表示する列数を返す
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //pickerに表示する行数を返す
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArray.count
    }
    
    
    //pickerに表示する値を返す
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeArray[row] as? String
    }
    
    //pickerが選択された際に呼ばれる
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(timeArray[row])")
        
        appDelegate.timeLimit = timeArray[row] as! String
    }
    
    @IBAction func stert() {
        let segue: timerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("timer") as! timerViewController
        self.presentViewController(segue, animated: true, completion: nil)
    }

}
