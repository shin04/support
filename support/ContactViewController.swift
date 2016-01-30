//
//  ContactViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/06.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import Parse
import RealmSwift

class ContactViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var editBtn: UIBarButtonItem!
    @IBOutlet var navi: UINavigationBar?
    
    var cellCount: Int = 0 //セル数を保存
    var selectCell: Int = 0 //選択されたセルを保存
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
        
        //appDelegate.saveData.removeObjectForKey("cellCount")
        
        let myLongPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressGesture:")
        table.addGestureRecognizer(myLongPressGesture)
        
        table.delegate = self
        table.dataSource = self
        
        //左スワイプ
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        //データ読み込み
//        let query = PFQuery(className: "memo")
//        query.whereKey("createBy", equalTo: appDelegate.username as! String)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error != nil {
//                return
//            }
//            guard let objects = objects else {
//                return
//            }
//            for object in objects {
//                query.getObjectInBackgroundWithId(object.objectId!) {
//                    (memo: PFObject?, error: NSError?) -> Void in
//                    if memo?["checkRow"] as? Bool != true {
//                        return
//                    }
//                    self.appDelegate.contactTitle = memo?["title"] as! NSMutableArray
//                    self.appDelegate.contactContent = memo?["contents"] as! NSMutableArray
//                    self.cellCount = memo?["cellCount"] as! Int
//                
//                    self.table.reloadData()
//                }
//            }
//        }
        
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
    
    //長押ししたときの処理
    func longPressGesture(sender: UILongPressGestureRecognizer) {
        // 押された位置でcellのPathを取得
        let point = sender.locationInView(table)
        let indexPath = table.indexPathForRowAtPoint(point)
        
        if indexPath == nil {
            
        } else if sender.state == UIGestureRecognizerState.Began  {
            print("長押し")
            selectCell = (indexPath?.row)!
            self.makeAlert(appDelegate.contactTitle[selectCell] as! String, messages: appDelegate.contactContent[selectCell] as! String)
        }
    }
    
    //長押ししたときに表示する
    func makeAlert(titles: String, messages: String) {
        let alertController = UIAlertController(title: titles, message: messages, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        let calcelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(calcelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func newContent() {
        print("newContent")
        let memos = Memo()
//        memos.title = "題名"
//        memos.content = "内容"
//        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(memos)
//        }
        
//        if cellCount == 0 {
//            ParseManager.saveData("memo", username: appDelegate.username as! String, column: "checkRow", data: true)
//        }
//        
//        appDelegate.contactTitle?.insertObject("title", atIndex: cellCount)
//        appDelegate.contactContent?.insertObject("contents", atIndex: cellCount)
//        
//        self.saveDate(cellCount)
//        
//        cellCount++
//        
//        ParseManager.saveData("memo", username: appDelegate.username as! String, column: "cellCount", data: cellCount)
////        appDelegate.saveData.setObject(cellCount, forKey: "cellCount")
////        appDelegate.saveData.synchronize()
//        print("cellcount = ",cellCount)
        
        table.reloadData()
    }
    
    @IBAction func edit() {
        if table.editing == false {
            editBtn.title = "done"
            editBtn.image = nil
            super.setEditing(true, animated: true)
            table.editing = true
        } else {
            //editBtn.title = "edit"
            let btnImg = UIImage(named: "edit.png")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 10, 10, 10))
            editBtn.image = btnImg
            super.setEditing(false, animated: false)
            table.editing = false
        }
    }
    
    func saveDate(number: Int) {
        appDelegate.saveData.setObject(cellCount, forKey: "cellCount")
        appDelegate.saveData.synchronize()
        
        ParseManager.saveData("memo", username: appDelegate.username as! String, column: "cellCount", data: cellCount)
        ParseManager.saveData("memo", username: appDelegate.username as! String, column: "title",
            data: appDelegate.contactTitle)
        ParseManager.saveData("memo", username: appDelegate.username as! String, column: "contents",
            data: appDelegate.contactContent)
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        print("スワイプ")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        let realm = try! Realm()
        cell.textLabel?.text = realm.objects(Memo)[indexPath.row].title as String
        
//        if(appDelegate.contactTitle.count != 0){
//            cell.textLabel?.text = appDelegate.contactTitle![indexPath.row] as? String
//        }
        
        return cell
    }
    
    //セルが押されたときの処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectCell = indexPath.row
        print("\(selectCell)行が選択されました")
        
        appDelegate.saveData.setObject(selectCell, forKey: "cellNum")
        
        let segue: MemoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Memo") as! MemoViewController
        segue.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(segue, animated: true, completion: nil)
    }
    
    //全ての説を編集可能に
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //全てのセルを並び替え可能に
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //並び替え終了時に呼び出される
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let targetTitle = appDelegate.contactTitle[sourceIndexPath.row]
        if let index: Int = appDelegate.contactTitle.indexOfObject(targetTitle) {
            appDelegate.contactTitle.removeObjectAtIndex(index)
            appDelegate.contactTitle.insertObject(targetTitle, atIndex: destinationIndexPath.row)
        }
        
        let targetContent = appDelegate.contactContent[sourceIndexPath.row]
        if let index: Int = appDelegate.contactContent.indexOfObject(targetContent) {
            appDelegate.contactContent.removeObjectAtIndex(index)
            appDelegate.contactContent.insertObject(targetContent, atIndex: destinationIndexPath.row)
        }
        
        self.saveDate(destinationIndexPath.row)
    }
    
    //編集終了時の処理
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // データを更新
        appDelegate.contactTitle.removeObjectAtIndex(indexPath.row)
        appDelegate.contactContent.removeObjectAtIndex(indexPath.row)
        cellCount -= 1
        
        self.saveDate(indexPath.row)
        
        // テーブルの更新
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
            withRowAnimation: UITableViewRowAnimation.Fade)
    }
}
