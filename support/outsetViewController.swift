//
//  outsetViewController.swift
//  support
//
//  Created by 梶原大進 on 2016/01/24.
//  Copyright © 2016年 梶原大進. All rights reserved.
//

import UIKit
import Parse

class outsetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var navi: UINavigationBar?
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビ透過
        navi?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navi?.shadowImage = UIImage()
        navi?.translucent = true
    }
    
    @IBAction func signInAction() {
        let alert = UIAlertController(title: "Sign In",
            message: "Please input your username and passward.",
            preferredStyle: .Alert)
        
        //cancel
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,handler: nil)
        
        //login
        let loginAction:UIAlertAction = UIAlertAction(title: "sign in", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
            print("login...")
            
            let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
            
            print("username is \(textFields![0].text!)")
            
            PFUser.logInWithUsernameInBackground(textFields![0].text!, password: textFields![1].text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    print("success")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("\(error)")
                }
            }
        })
        
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        
        //e-mail
        alert.addTextFieldWithConfigurationHandler({(text: UITextField) -> Void in
            text.placeholder = "input email"
            text.delegate = self
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 50, 30))
            label.text = "MAIL"
            text.leftView = label
            text.leftViewMode = UITextFieldViewMode.Always
        })
        
        //passward
        alert.addTextFieldWithConfigurationHandler({(text: UITextField!) -> Void in
            text.placeholder = "input passward"
            text.secureTextEntry = true
            text.delegate = self
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 50, 30))
            label.text = "PASS"
            text.leftView = label
            text.leftViewMode = UITextFieldViewMode.Always
        })
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpAction() {
        let alert = UIAlertController(title: "Sign Up",
            message: "Please input your informstion",
            preferredStyle: .Alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,handler: nil)
        
        let registerAction:UIAlertAction = UIAlertAction(title: "sign up", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
            print("prepare...")
            
            let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
            
            if textFields![0].text != nil && textFields![1].text != nil {
                let user = PFUser()
                user.username = textFields![0].text!
                user.password = textFields![1].text!
                
                user.signUpInBackgroundWithBlock {
                    (succeeded, error) -> Void in
                    if error == nil {
                        print("success")
                        print("Your name is \(user.username!)")
                        
                        self.appDelegate.username = user.username!
                        print("\(self.appDelegate.username) is login")
                        
                        self.newObject("Lessons", email: user.username!)
                        self.newObject("memo", email: user.username!)
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        print(error)
                    }
                }
            }
            
        })
        
        alert.addAction(cancelAction)
        alert.addAction(registerAction)
        
        //username
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "input your email adress"
            text.delegate = self
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 50, 30))
            label.text = "MAIL"
            text.leftView = label
            text.leftViewMode = UITextFieldViewMode.Always
        })
        
        //passward
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "input passward"
            text.secureTextEntry = true
            text.delegate = self
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 50, 30))
            label.text = "PASS"
            text.leftView = label
            text.leftViewMode = UITextFieldViewMode.Always
        })
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func newObject(className: String, email: String) {
        let object = PFObject(className: className)
        object["createBy"] = email
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("save date")
            } else {
                print(error)
            }
        }
    }
}
