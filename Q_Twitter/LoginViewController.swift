//
//  LoginViewController.swift
//  Q_Twitter
//
//  Created by MAC on 11/25/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBAction func logInRequest(sender: AnyObject) {

        TwitClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                // perform segue
                print("perform segue")
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle loging error
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
