//
//  LoginViewController.swift
//  TweetIt
//
//  Created by Andrew Mogg on 7/23/16.
//  Copyright © 2016 Andrew Mogg. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("Check if logged in")
        
        checkIfLoggedIn()
    }
    
    func checkIfLoggedIn() {
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                self.appDelegate.twittderID = (session?.userID)!
                self.appDelegate.userName = (session?.userName)!
                self.performSegueWithIdentifier("Timeline", sender: self)

            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
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
