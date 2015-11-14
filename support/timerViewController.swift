//
//  timerViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/14.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit

class timerViewController: UIViewController {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(appDelegate.timeLimit)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
