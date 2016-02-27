//
//  ViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/10/31.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var navi: UINavigationBar?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var tableView: UITableView!
    
    var first: UILabel!
    var second: UILabel!
    var third: UILabel!
    var fourth: UILabel!
    var fifth: UILabel!
    var sixth: UILabel!
    var seventh: UILabel!
    
    let pageSize: Int = 6
    var selectCell: Int = 0
    
    var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print("横のサイズは\(self.view.frame.width * 6),スクロールビューの横のサイズは\(scrollView.frame.width)")
        scrollView.contentSize = CGSizeMake(self.view.frame.width * CGFloat(pageSize), 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        pageControl.numberOfPages = pageSize
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = false
        
        for var i = 0; i < pageSize; i++ {
            let width = self.view.frame.width * CGFloat(i) + 5
            
            if app.saveData.boolForKey("checkInit") == false {
                let label: UILabel = UILabel(frame: CGRectMake(width, 0, 100, 30))
                label.text = "NO DATA"
                scrollView.addSubview(label)
                break
            }
            
            first = UILabel(frame: CGRectMake(width, 0, 200, 20))
            second = UILabel(frame: CGRectMake(width, 25, 200, 20))
            third = UILabel(frame: CGRectMake(width, 50, 200, 20))
            fourth = UILabel(frame: CGRectMake(width, 75, 200, 20))
            fifth = UILabel(frame: CGRectMake(width, 100, 200, 20))
            sixth = UILabel(frame: CGRectMake(width, 125, 200, 20))
            seventh = UILabel(frame: CGRectMake(width, 150, 200, 20))
            
            self.loadLesson(i, first: first, second: second, third: third, fourth: fourth, fifth: fifth, sixth: sixth, seventh: seventh)
            
            scrollView.addSubview(first)
            scrollView.addSubview(second)
            scrollView.addSubview(third)
            scrollView.addSubview(fourth)
            scrollView.addSubview(fifth)
            scrollView.addSubview(sixth)
            scrollView.addSubview(seventh)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        print("\(realm.objects(Memo).count)行です")
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
        
        app.saveData.setObject(selectCell, forKey: "cellNum")
        
        let segue: MemoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Memo") as! MemoViewController
        segue.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(segue, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.width) == 0 {
            // ページの場所を切り替える.
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func loadLesson(dayNum: Int, first: UILabel, second: UILabel, third: UILabel, fourth: UILabel, fifth: UILabel, sixth: UILabel, seventh: UILabel) {
        
        let realm = try! Realm()
        switch dayNum {
        case 0:
            first.text = "１時間目：\(realm.objects(Monday)[0].first)"
            second.text = "２時間目：\(realm.objects(Monday)[0].second)"
            third.text = "３時間目：\(realm.objects(Monday)[0].third)"
            fourth.text = "４時間目：\(realm.objects(Monday)[0].fourth)"
            fifth.text = "５時間目：\(realm.objects(Monday)[0].fifth)"
            sixth.text = "６時間目：\(realm.objects(Monday)[0].sixth)"
            seventh.text = "７時間目：\(realm.objects(Monday)[0].seventh)"
            
        case 1:
            first.text = "１時間目：\(realm.objects(Tuesday)[0].first)"
            second.text = "２時間目：\(realm.objects(Tuesday)[0].second)"
            third.text = "３時間目：\(realm.objects(Tuesday)[0].third)"
            fourth.text = "４時間目：\(realm.objects(Tuesday)[0].fourth)"
            fifth.text = "５時間目：\(realm.objects(Tuesday)[0].fifth)"
            sixth.text = "６時間目：\(realm.objects(Tuesday)[0].sixth)"
            seventh.text = "７時間目：\(realm.objects(Tuesday)[0].seventh)"
            
        default:
            print("")
        }
    }
    
}
