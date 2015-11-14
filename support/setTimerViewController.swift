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
    
    var timeArray: NSMutableArray = []
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        var a: Int = 5
        
        for(var i = 0; i < 24; i++) {
            let str: NSString = a.description
            timeArray[i] = str
            print("\(timeArray[i])")
            a += 5
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stert() {
        let segue: timerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("timer") as! timerViewController
        self.presentViewController(segue, animated: true, completion: nil)
    }
    
    

}
