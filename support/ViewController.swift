//
//  ViewController.swift
//  support
//
//  Created by 梶原大進 on 2015/10/31.
//  Copyright © 2015年 梶原大進. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var inBtn: UIButton!
    @IBOutlet var upBtn: UIButton!
    @IBOutlet var outBtn: UIButton!
    @IBOutlet var setBtn: UIButton!
    @IBOutlet var contactBtn: UIButton!
    @IBOutlet var timerBtn: UIButton!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let appDomain:String = NSBundle.mainBundle().bundleIdentifier!
        //NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        appDelegate.saveData.setObject(1, forKey: "cellCount")
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            inBtn.alpha = 0
            upBtn.alpha = 0
            outBtn.alpha = 1
            setBtn.alpha = 1
            contactBtn.alpha = 1
            timerBtn.alpha = 1
            
            appDelegate.username = currentUser?.email
            
            print("You are a member of the app!")
        } else {
            print("You are not a member of the app.")
            inBtn.alpha = 1
            upBtn.alpha = 1
            outBtn.alpha = 0
            setBtn.alpha = 0
            contactBtn.alpha = 0
            timerBtn.alpha = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - sign in action
    @IBAction func signInAction() {
        let alert = UIAlertController(title: "Sign In",
            message: "Please input your username and passward.",
            preferredStyle: .Alert)
        
        //cancel
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                print("Cancel")
        })
        
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
                    self.viewDidLoad()
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
    
    // MARK: - sign up action
    @IBAction func signUpAction() {
        let alert = UIAlertController(title: "Sign Up",
            message: "Please input your informstion",
            preferredStyle: .Alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                print("Cancel")
        })
        
        let registerAction:UIAlertAction = UIAlertAction(title: "sign up", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
            print("prepare...")
            
            let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
            
            if textFields![0].text != nil && textFields![1].text != nil && textFields![2].text != nil {
                let user = PFUser()
                user.username = textFields![0].text!
                user.email = textFields![1].text!
                user.password = textFields![2].text!
                
                user.signUpInBackgroundWithBlock {
                    (succeeded, error) -> Void in
                    if error == nil {
                        print("success")
                        print("Your name is \(user.username!)")
                        
                        self.appDelegate.username = user.username!
                        print("\(self.appDelegate.username) is login")
                        
                        self.newObject("Lessons", email: user.email!)
                        self.newObject("memo", email: user.email!)
                        
//                        let currentInstallation = PFInstallation.currentInstallation()
//                        currentInstallation.addUniqueObject("Giants", forKey: "channels")
//                        currentInstallation.saveInBackground()
                        
                        self.viewDidLoad()
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
            text.placeholder = "input username"
            text.delegate = self
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 50, 30))
            label.text = "ID"
            text.leftView = label
            text.leftViewMode = UITextFieldViewMode.Always
        })
        
        //e-mail
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "input e-mail adress"
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
        
        //self.viewDidLoad()
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - sign out action
    @IBAction func signOut() {
        PFUser.logOut()
        print("See you!")
        loadView()
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
