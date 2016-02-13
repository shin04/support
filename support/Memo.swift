//
//  Memo.swift
//  support
//
//  Created by 梶原大進 on 2016/01/30.
//  Copyright © 2016年 梶原大進. All rights reserved.
//

import RealmSwift

class Memo: Object {
    dynamic var title: String = ""
    dynamic var content: String = ""
    dynamic var memoCount: Int = 0
    dynamic var noticeCheck: Bool = false
    dynamic var noticeDate: NSDate = NSDate()
    dynamic var noticeMg: String = ""
}
