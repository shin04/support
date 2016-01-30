//
//  Lessons.swift
//  support
//
//  Created by 梶原大進 on 2016/01/30.
//  Copyright © 2016年 梶原大進. All rights reserved.
//

import RealmSwift

class Lessons: Object {
    dynamic var mondays: NSArray = []
    dynamic var tuesdays: NSArray = []
    dynamic var wednesdays: NSArray = []
    dynamic var thursdays: NSArray = []
    dynamic var fridays: NSArray = []
    dynamic var saturdays: NSArray = []
}
