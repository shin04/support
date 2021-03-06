//
//  AppDelegate.swift
//  support
//
//  Created by 梶原大進 on 2015/10/31.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //メモの数を保存
    var saveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
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
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        application.cancelAllLocalNotifications()
        
        let realm = try! Realm()
        
        // 時間割の通知
        if realm.objects(Notice)[0].noticeCheck == true {
            //日曜なら通知なし
            if notificationManeger.checkSun() != 0 {
                application.scheduleLocalNotification(notificationManeger.settingLs(realm.objects(Notice)[0].noticeMg, hour: realm.objects(Notice)[0].noticeHour, minute: realm.objects(Notice)[0].noticeMinute))
            }
        }
        
        // 連絡事項の通知
        for (var i = 0; realm.objects(Memo).count > i; i++) {
            if realm.objects(Memo)[i].noticeCheck == true {
                application.scheduleLocalNotification(notificationManeger.settingMm(realm.objects(Memo)[i].noticeMg, date: realm.objects(Memo)[i].noticeDate, key: "number\(i)"))
            }
        }
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
        // バッジをリセット
        application.applicationIconBadgeNumber = 0
    }
    
    //ローカル通知を受け取った時の処理
    func localPushRecieve(application: UIApplication, notification: UILocalNotification) {
        let realm = try! Realm()
        for (var i = 0; realm.objects(Memo).count > i; i++) {
            if let info = notification.userInfo as! [String: String]! {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                if info["memoId"] == "number\(i)" {
                    try! realm.write {
                        realm.objects(Memo)[i].noticeCheck = false
                        realm.objects(Memo)[i].noticeDate = NSDate()
                        realm.objects(Memo)[i].noticeMg = ""
                    }
                }
            }
        }
    }

}

