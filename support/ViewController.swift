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
    
    var first: NSMutableArray = []
    var second: NSMutableArray = []
    var third: NSMutableArray = []
    var fourth: NSMutableArray = []
    var fifth: NSMutableArray = []
    var sixth: NSMutableArray = []
    var seventh: NSMutableArray = []
    
    let pageSize: Int = 6
    var selectCell: Int = 0
    
    var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初期化するかどうか
        if app.saveData.boolForKey("checkInit") != true {
            //初期化する
            Initialization.lessonInit()
            app.saveData.setBool(true, forKey: "checkInit")
        }
        
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
        let now = NSDate()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let comps: NSDateComponents = calendar!.components([NSCalendarUnit.Weekday], fromDate: now)
        print("Today is \(Int(comps.weekday))")
        pageControl.currentPage = comps.weekday - 2
        pageControl.userInteractionEnabled = false
        
        let dayArray = ["monday.png", "tuesday.png", "wednesday.png", "thursday.png", "friday.png", "saturday.png"]
        
        for var i = 0; i < pageSize; i++ {
            let width = self.view.frame.width * CGFloat(i)
            
            let dayImageView = UIImageView(frame: CGRectMake(width + 20, 50, 80, 80))
            let dayImage = UIImage(named: dayArray[i])
            dayImageView.image = dayImage
            scrollView.addSubview(dayImageView)
            
            first[i] = UILabel(frame: CGRectMake(width + 120, 0, 200, 20))
            second[i] = UILabel(frame: CGRectMake(width + 120, 25, 200, 20))
            third[i] = UILabel(frame: CGRectMake(width + 120, 50, 200, 20))
            fourth[i] = UILabel(frame: CGRectMake(width + 120, 75, 200, 20))
            fifth[i] = UILabel(frame: CGRectMake(width + 120, 100, 200, 20))
            sixth[i] = UILabel(frame: CGRectMake(width + 120, 125, 200, 20))
            seventh[i] = UILabel(frame: CGRectMake(width + 120, 150, 200, 20))
            
            scrollView.addSubview(first[i] as! UILabel)
            scrollView.addSubview(second[i] as! UILabel)
            scrollView.addSubview(third[i] as! UILabel)
            scrollView.addSubview(fourth[i] as! UILabel)
            scrollView.addSubview(fifth[i] as! UILabel)
            scrollView.addSubview(sixth[i] as! UILabel)
            scrollView.addSubview(seventh[i] as! UILabel)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if (first.count != 0) {
            for var i = 0; i < 6; i++ {
                self.loadLesson(i, first: first[i] as! UILabel, second: second[i] as! UILabel, third: third[i] as! UILabel, fourth: fourth[i] as! UILabel, fifth: fifth[i] as! UILabel, sixth: sixth[i] as! UILabel, seventh: seventh[i] as! UILabel)
            }
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func toSetteing() {
        let vc = self.tabBarController?.viewControllers![3]
        self.tabBarController?.selectedViewController = vc
    }
    
    @IBAction func toLessons() {
        let vc = self.tabBarController?.viewControllers![1]
        self.tabBarController?.selectedViewController = vc
    }
    
    @IBAction func toMemos() {
        let vc = self.tabBarController?.viewControllers![2]
        self.tabBarController?.selectedViewController = vc
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
            
        case 2:
            first.text = "１時間目：\(realm.objects(Wednesday)[0].first)"
            second.text = "２時間目：\(realm.objects(Wednesday)[0].second)"
            third.text = "３時間目：\(realm.objects(Wednesday)[0].third)"
            fourth.text = "４時間目：\(realm.objects(Wednesday)[0].fourth)"
            fifth.text = "５時間目：\(realm.objects(Wednesday)[0].fifth)"
            sixth.text = "６時間目：\(realm.objects(Wednesday)[0].sixth)"
            seventh.text = "７時間目：\(realm.objects(Wednesday)[0].seventh)"
            
        case 3:
            first.text = "１時間目：\(realm.objects(Thursday)[0].first)"
            second.text = "２時間目：\(realm.objects(Thursday)[0].second)"
            third.text = "３時間目：\(realm.objects(Thursday)[0].third)"
            fourth.text = "４時間目：\(realm.objects(Thursday)[0].fourth)"
            fifth.text = "５時間目：\(realm.objects(Thursday)[0].fifth)"
            sixth.text = "６時間目：\(realm.objects(Thursday)[0].sixth)"
            seventh.text = "７時間目：\(realm.objects(Thursday)[0].seventh)"
            
        case 4:
            first.text = "１時間目：\(realm.objects(Friday)[0].first)"
            second.text = "２時間目：\(realm.objects(Friday)[0].second)"
            third.text = "３時間目：\(realm.objects(Friday)[0].third)"
            fourth.text = "４時間目：\(realm.objects(Friday)[0].fourth)"
            fifth.text = "５時間目：\(realm.objects(Friday)[0].fifth)"
            sixth.text = "６時間目：\(realm.objects(Friday)[0].sixth)"
            seventh.text = "７時間目：\(realm.objects(Friday)[0].seventh)"
            
        case 5:
            first.text = "１時間目：\(realm.objects(Saturday)[0].first)"
            second.text = "２時間目：\(realm.objects(Saturday)[0].second)"
            third.text = "３時間目：\(realm.objects(Saturday)[0].third)"
            fourth.text = "４時間目：\(realm.objects(Saturday)[0].fourth)"
            fifth.text = "５時間目：\(realm.objects(Saturday)[0].fifth)"
            sixth.text = "６時間目：\(realm.objects(Saturday)[0].sixth)"
            seventh.text = "７時間目：\(realm.objects(Saturday)[0].seventh)"
            
        default:
            print("")
        }
    }
    
}
