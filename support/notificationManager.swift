//
//  notificationManager.swift
//  support
//
//  Created by 梶原大進 on 2015/12/17.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import Foundation

class notificationManeger {
    class func settingLs(message: String, hour: Int, minute: Int) -> UILocalNotification {
        // 通知設定
        let notification = UILocalNotification()
        notification.alertAction = "アプリに戻る"
        notification.alertBody = message
        notification.timeZone = NSTimeZone.defaultTimeZone();
        
        let now = NSDate()
        print(now)
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let comps:NSDateComponents = calendar!.components([NSCalendarUnit.Year, .Month, .Day], fromDate: now)
        comps.calendar = calendar
        comps.hour = hour
        comps.minute = minute
        
        if now.compare(comps.date!) != NSComparisonResult.OrderedAscending {
            comps.day++
        }
        
        let now2 = comps.date
        print(now2!)
        
        notification.fireDate = now2
        
        //毎日通知
        notification.repeatInterval = .Day
        //サウンドの設定
        notification.soundName = UILocalNotificationDefaultSoundName
        // アイコンバッジに1を表示
        notification.applicationIconBadgeNumber++
        // あとのためにIdを割り振っておく
        notification.userInfo = ["notifyId": "ranking_update"]
        
        return notification
    }
    
    class func settingMm(message: String, date: NSDate) -> UILocalNotification {
        // 通知設定
        let notification = UILocalNotification()
        notification.alertAction = "アプリに戻る"
        notification.alertBody = message
        notification.timeZone = NSTimeZone.defaultTimeZone();
        
        notification.fireDate = date
        
        notification.soundName = UILocalNotificationDefaultSoundName
        // アイコンバッジに1を表示
        notification.applicationIconBadgeNumber++
        // あとのためにIdを割り振っておく
        notification.userInfo = ["notifyId": "ranking_update"]
        
        return notification
    }
}
