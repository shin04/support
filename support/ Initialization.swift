//
//   Initialization.swift
//  support
//
//  Created by 梶原大進 on 2016/02/02.
//  Copyright © 2016年 梶原大進. All rights reserved.
//

import RealmSwift

class Initialization {
    class func lessonInit() {
        let monday = Monday()
        monday.first = ""
        monday.second = ""
        monday.third = ""
        monday.fourth = ""
        monday.fifth = ""
        monday.sixth = ""
        monday.seventh = ""
        
        let tuesday = Tuesday()
        tuesday.first = ""
        tuesday.second = ""
        tuesday.third = ""
        tuesday.fourth = ""
        tuesday.fifth = ""
        tuesday.sixth = ""
        tuesday.seventh = ""
        
        let wednesday = Wednesday()
        wednesday.first = ""
        wednesday.second = ""
        wednesday.third = ""
        wednesday.fourth = ""
        wednesday.fifth = ""
        wednesday.sixth = ""
        wednesday.seventh = ""
        
        let thursday = Thursday()
        thursday.first = ""
        thursday.second = ""
        thursday.third = ""
        thursday.fourth = ""
        thursday.fifth = ""
        thursday.sixth = ""
        thursday.seventh = ""
        
        let friday = Friday()
        friday.first = ""
        friday.second = ""
        friday.third = ""
        friday.fourth = ""
        friday.fifth = ""
        friday.sixth = ""
        friday.seventh = ""
        
        let saturday = Saturday()
        saturday.first = ""
        saturday.second = ""
        saturday.third = ""
        saturday.fourth = ""
        saturday.fifth = ""
        saturday.sixth = ""
        saturday.seventh = ""
        
        let notice = Notice()
        notice.noticeCheck = false
        notice.noticeHour = 0
        notice.noticeMinute = 0
        notice.noticeMg = ""
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(monday)
            realm.add(tuesday)
            realm.add(wednesday)
            realm.add(thursday)
            realm.add(friday)
            realm.add(saturday)
            realm.add(notice)
        }
    }
}
