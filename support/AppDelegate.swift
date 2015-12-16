//
//  AppDelegate.swift
//  support
//
//  Created by 梶原大進 on 2015/10/31.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import Parse
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //emailを保存
    var username: NSString?
    
    //時間割の通知時間を保存
    var noticeDic: NSMutableDictionary = ["lessonHour": 10, "lessonMinute": 10, "lessonMg": "hoge", "memoTime": 10, "memoMg": "hoge"]
    var noticeMg: String!
    var noticeHour: Int = 0
    var noticeMinute: Int = 0
    var noticeTime: NSDate?
    
    //メモのデータを保存
    var saveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    //メモのPFObjectを保存
    var memoObjects = [PFObject]()
    
    //メモのタイトルとないようを保存する配列
    var contactTitle: NSMutableArray! = []
    var contactContent: NSMutableArray! = []
    
    //対メーの時間を保存
    var timeLimit: String!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.setApplicationId("6RrWmvlFfkgQDlXr65HAvlHv1nSHpAmah5JSECiH", clientKey: "9hbbjdkZQlIzhevLQQk0HnGJChEY0GdnvdRdeuqs")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //通知の設定
        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // アプリを終了していた際に、通知からの復帰をチェック
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            localPushRecieve(application, notification: notification)
        }
        // バッジをリセット
        application.applicationIconBadgeNumber = 0
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // push設定
        // 登録済みのスケジュールをすべてリセット
        application.cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        notification.alertAction = "アプリに戻る"
        notification.alertBody = noticeMg
        notification.timeZone = NSTimeZone.defaultTimeZone();
        
        let now = NSDate()
        print(now);
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let comps:NSDateComponents = calendar!.components([NSCalendarUnit.Year, .Month, .Day], fromDate: now)
        comps.calendar = calendar
        comps.hour = noticeHour
        comps.minute = noticeMinute
        
        let now2 = comps.date;
        print(now2!);
        
        notification.fireDate = now2
        
        notification.soundName = UILocalNotificationDefaultSoundName
        // アイコンバッジに1を表示
        notification.applicationIconBadgeNumber = 1
        // あとのためにIdを割り振っておく
        notification.userInfo = ["notifyId": "ranking_update"]
        application.scheduleLocalNotification(notification)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //ローカル通知を受け取った時に呼ばれる
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // アプリがActiveな状態で通知を発生させた場合にも呼ばれるのでActiveでない場合のみ実行
        if application.applicationState != .Active {
            localPushRecieve(application, notification: notification)
        }
    }
    
    //ローカル通知を受け取った時の処理
    func localPushRecieve(application: UIApplication, notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            switch userInfo["notifyId"] as? String {
            case .Some("ranking_update"):
                
                break
            default:
                break
            }
            // バッジをリセット
            application.applicationIconBadgeNumber = 0
            // 通知領域からこの通知を削除
            application.cancelLocalNotification(notification)
        }
    }

}

