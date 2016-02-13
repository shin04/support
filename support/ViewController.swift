//
//  ViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/10/31.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet var navi: UINavigationBar?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
        
        let pageSize = 6
        
        print("横のサイズは\(self.view.frame.width * 6),スクロールビューの横のサイズは\(scrollView.frame.width)")
        scrollView.contentSize = CGSizeMake(self.view.frame.width * CGFloat(pageSize), 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        // ページ数分ボタンを生成する.
        for var i = 0; i < pageSize; i++ {
            let width = self.view.frame.width * CGFloat(i) + 5
            
            if app.saveData.boolForKey("checkInit") == true {
                let label: UILabel = UILabel(frame: CGRectMake(width, 0, 100, 30))
                label.text = "NO DATA"
                scrollView.addSubview(label)
                break
            }
            
            let first: UILabel = UILabel(frame: CGRectMake(width, 0, 100, 20))
            let second: UILabel = UILabel(frame: CGRectMake(width, 20, 100, 30))
            let third: UILabel = UILabel(frame: CGRectMake(width, 50, 100, 30))
            let fourth: UILabel = UILabel(frame: CGRectMake(width, 80, 100, 30))
            let fifth: UILabel = UILabel(frame: CGRectMake(width, 110, 100, 30))
            let sixth: UILabel = UILabel(frame: CGRectMake(width, 140, 100, 30))
            let seventh: UILabel = UILabel(frame: CGRectMake(width, 170, 100, 30))
            
            let realm = try! Realm()
            switch i {
            case 0:
                first.text = realm.objects(Monday)[0].first
                second.text = realm.objects(Monday)[0].second
                third.text = realm.objects(Monday)[0].third
                fourth.text = realm.objects(Monday)[0].fourth
                fifth.text = realm.objects(Monday)[0].fifth
                sixth.text = realm.objects(Monday)[0].sixth
                seventh.text = realm.objects(Monday)[0].seventh
                
            case 1:
                first.text = realm.objects(Tuesday)[0].first
                first.text = realm.objects(Tuesday)[0].second
                first.text = realm.objects(Tuesday)[0].third
                first.text = realm.objects(Tuesday)[0].fourth
                first.text = realm.objects(Tuesday)[0].fifth
                first.text = realm.objects(Tuesday)[0].sixth
                first.text = realm.objects(Tuesday)[0].seventh
                
            default:
                print("")
            }
            
            scrollView.addSubview(first)
            scrollView.addSubview(second)
            scrollView.addSubview(third)
            scrollView.addSubview(fourth)
            scrollView.addSubview(fifth)
            scrollView.addSubview(sixth)
            scrollView.addSubview(seventh)
        }
        
        pageControl.numberOfPages = pageSize
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
}


