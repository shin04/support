//
//  ContactViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/11/06.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import RealmSwift

class ContactViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var editBtn: UIBarButtonItem!
    @IBOutlet var navi: UINavigationBar?
    
    var cellCount: Int = 0 //セル数を保存
    var selectCell: Int = 0 //選択されたセルを保存
    
    var indicator: UIActivityIndicatorView!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
        
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
        self.makeIndicator()
        
        //データ読み込み
        let realm = try! Realm()
        let memos = realm.objects(Memo)
        cellCount = realm.objects(Memo).count
        print(memos)
        
        indicator.stopAnimating()
        
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
            let realm = try! Realm()
            self.makeAlert(realm.objects(Memo)[selectCell].title, messages: realm.objects(Memo)[selectCell].content)
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
    
    @IBAction func newContent() {
        let memo = Memo()
        memo.title = "題名"
        memo.content = "内容"
        let realm = try! Realm()
        try! realm.write {
            realm.add(memo)
        }
        
        cellCount++
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
    
    func swipe(sender: UISwipeGestureRecognizer) {
        print("スワイプ")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makeIndicator() {
        // インジケータを作成する.
        indicator = UIActivityIndicatorView()
        indicator.frame = CGRectMake(0, 0, 50, 50)
        indicator.center = self.view.center
        indicator.color = UIColor.blackColor()
        
        // アニメーションを開始する.
        indicator.startAnimating()
        
        // インジケータをViewに追加する.
        self.view.addSubview(indicator)
    }

}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let realm = try! Realm()
        return realm.objects(Memo).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        let realm = try! Realm()
        cell.textLabel?.text = realm.objects(Memo)[indexPath.row].title as String
        
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
        //TODO: cell並び替えの処理
        // sourceIndexPathは移動前の位置
        // destinationIndexPathは移動後の位置
        let realm = try! Realm()
        let selectedMemo = realm.objects(Memo)[sourceIndexPath.row]
        try! realm.write {
            realm.delete(selectedMemo)
        }
    }
    
    //編集終了時の処理
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // データを更新
        let realm = try! Realm()
        let deleateMemo = realm.objects(Memo)[indexPath.row]
        try! realm.write {
            realm.delete(deleateMemo)
        }
        
        // テーブルの更新
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
            withRowAnimation: UITableViewRowAnimation.Fade)
    }
}
