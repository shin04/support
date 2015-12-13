//
//  ContactViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/06.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import Parse

class ContactViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var editBtn: UIBarButtonItem!
    
    var cellCount: Int = 0 //セル数を保存
    var selectCell: Int = 0 //選択されたセルを保存
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.saveData.removeObjectForKey("cellCount")
        print(cellCount)
//        appDelegate.saveData.removeObjectForKey("title")
//        appDelegate.saveData.removeObjectForKey("content")
        
        let myLongPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressGesture:")
        table.addGestureRecognizer(myLongPressGesture)
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if appDelegate.saveData.objectForKey("cellCount") != nil {
            cellCount = appDelegate.saveData.objectForKey("cellCount") as! Int
            print("行数は\(cellCount)です")
            
            ParseManager.readDate()
            
//            let query = PFQuery(className: "memo")
//            query.whereKey("createBy", equalTo: appDelegate.username as! String)
//            query.findObjectsInBackgroundWithBlock { objects, error in
//                if error == nil {
//                    if let objects = objects{
//                        var count:Int = 0
//                        for object in objects {
//                            query.getObjectInBackgroundWithId(object.objectId!) {
//                                (memo: PFObject?, error: NSError?) -> Void in
//                                print("called1 \(self.cellCount)")
//                                if(self.cellCount != 0) {
//                                    print("called2")
//                                    
//                                    self.appDelegate.memoObjects[count] = memo!
//                                    count++
//                                    
//                                    print("ID = \(object.objectId)")
//                                    
//                                    let array = memo!["title"] as! NSMutableArray
//                                    self.appDelegate.contactTitle = array
//                                    let array2 = memo!["content"] as? NSMutableArray
//                                    self.appDelegate.contactContent = array2
//                                    self.table.reloadData()
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    print("error")
//                }
//            }
            
            appDelegate.contactTitle = appDelegate.saveData.objectForKey("title")?.mutableCopy() as! NSMutableArray
            appDelegate.contactContent = appDelegate.saveData.objectForKey("content")?.mutableCopy() as! NSMutableArray
            
            print("\(cellCount),\(appDelegate.contactTitle),\(appDelegate.contactContent)")
            
            
        }
        
        //table.reloadData()
    }

    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
    
    //長押ししたときの処理
    func longPressGesture(sender: UILongPressGestureRecognizer) {
        // 指が離れたことを検知
        if(sender.state == UIGestureRecognizerState.Ended){
            print("長押し")
            self.makeAlert(selectCell)
        }
    }
    
    
    //長押ししたときに表示する
    func makeAlert(number: Int) {
        let alertController = UIAlertController(title: appDelegate.contactTitle[number] as? String, message: appDelegate.contactContent[number] as? String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "戻る", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func newContent() {
        appDelegate.contactTitle?.insertObject("title", atIndex: cellCount)
        appDelegate.contactContent?.insertObject("contents", atIndex: cellCount)
        print("\(appDelegate.contactTitle![cellCount]),\(appDelegate.contactContent![cellCount]),\(cellCount)")
        
        self.saveDate(cellCount)
        
        cellCount++
        //save data
        appDelegate.saveData.setObject(cellCount as Int, forKey: "cellCount")
//        appDelegate.saveData.setObject(appDelegate.contactTitle, forKey: "title")
//        appDelegate.saveData.setObject(appDelegate.contactContent, forKey: "content")
//        appDelegate.saveData.synchronize()
        
        table.reloadData()
    }
    
    @IBAction func edit() {
        if table.editing == false {
            editBtn.title = "done"
            super.setEditing(true, animated: true)
            table.editing = true
        } else {
            editBtn.title = "edit"
            super.setEditing(false, animated: false)
            table.editing = false
        }
    }
    
    func saveDate(number: Int) {
        appDelegate.saveData.setObject(cellCount as Int, forKey: "cellCount")
        appDelegate.saveData.synchronize()
        ParseManager.saveDate(self.appDelegate.contactTitle, contacts: self.appDelegate.contactContent, username: self.appDelegate.username!)
    }

}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        if(appDelegate.contactTitle.count != 0){
            cell.textLabel?.text = appDelegate.contactTitle![indexPath.row] as? String
        }
        
        return cell
    }
    
    //セルが押されたときの処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectCell = indexPath.row
        print("\(selectCell)行が選択されました")
        
        appDelegate.saveData.setObject(selectCell, forKey: "cellNum")
        
        let segue: MemoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Memo") as! MemoViewController
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
        
        //        appDelegate.saveData.setObject(cellCount, forKey: "cellCount")
        //        appDelegate.saveData.setObject(appDelegate.contactTitle, forKey: "title")
        //        appDelegate.saveData.setObject(appDelegate.contactContent, forKey: "content")
        //        appDelegate.saveData.synchronize()
        
        // テーブルの更新
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
            withRowAnimation: UITableViewRowAnimation.Fade)
    }
}
