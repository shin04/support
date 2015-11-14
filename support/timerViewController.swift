//
//  timerViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/14.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit

class timerViewController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel! //残り時間を表示
    @IBOutlet var redLabel: UILabel! //赤色のグラフ
    @IBOutlet var blueLabel: UILabel! //青色のグラフ(減っていく方)
    
    var timeInt: Int = 0 //分
    var timeSecond: Int = 0 //秒
    var timeCount: Int = 0
    var blueLabelTimer:Int = 0
    var widthSize: CGFloat = 300
    
    var timer: NSTimer!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(appDelegate.timeLimit)")
        
        //let timeInt: Int = Int(appDelegate.timeLimit)!
        timeInt = Int(appDelegate.timeLimit)!
        timeSecond = timeInt * 60
        print("\(timeInt)分,\(timeSecond)秒")
        
        timeLabel.text = "残り" + appDelegate.timeLimit + "分"
        
        blueLabelTimer = 300 / (timeInt * 60)
        print("\(blueLabelTimer)")
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDown", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //NSTimerIntervalで指定された秒数毎に呼び出されるメソッド.
    func countDown() {
        timeSecond -= 1
        timeCount += 1
        
        if timeCount == 60 {
            timeLabel.text = "残り" + String(timeInt - 1) + "分"
            timeCount = 0
        }
        
        widthSize -= CGFloat(blueLabelTimer)
        print("\(widthSize)")
        blueLabel.frame = CGRectMake(10, 266, widthSize, 50)
        
        if timeSecond == 0 {
            timer.invalidate()
            
            let alertController = UIAlertController(title: "終了", message: "お疲れ様です", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "終了", style: .Default, handler:{
                (action:UIAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

}
