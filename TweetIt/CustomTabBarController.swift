//
//  CustomTabBarController.swift
//  ExplodingMenu
//
//  Created by Nicholas Montgomery on 4/20/15.
//  Copyright (c) 2015 Nicholas Montgomery. All rights reserved.
//

import UIKit
import TwitterKit

class CustomTabBarController: UITabBarController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    // Custom tab bar to add over the default tab bar
    var customTabBar: UITabBar!
    
    // Tab bar items
    var itemA: UITabBarItem!
    var hiddenItem: UITabBarItem! // hidden by a large menu button
 
    
    // View controllers linked to each tab bar item
    // Note these are created in the storyboard without segues
    // They are referenced by a unique storyboard ID
    var vcA: UIViewController!
    var vcHidden: UIViewController!

    
    // Used to manually create the background fade effect when presenting a popup subview
    var fadeView: UIView!
    
    // Exploding menu elements
    var menuButton: UIButton!
    var logoutButton: UIButton!
    var profileButton: UIButton!
    var tweetButton: UIButton!
    
    // Tracks which tab bar item is currently selected
    var selectedItem: UITabBarItem!
    
    // Stores the height and width of the view (for formatting)
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    
    // Tracks whether the exploding menu is currently shown or not
    var menuEnabled = false
    
    // Passed from downstream CustomAlertViewController to then pass back downstream to the DetailViewController
    var selection = ""
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton()
        
    }
    
    func createButton() {
        // Configure the fadeView to be totally transparent
        fadeView = UIView(frame: self.view.frame)
        fadeView.backgroundColor = UIColor.blackColor()
        fadeView.alpha = 0.0
        
        // Add a gesture recognizer to control when the fadeView is tapped
        let singleTapBackground = UITapGestureRecognizer(target: self, action: #selector(CustomTabBarController.backgroundTapped(_:)))
        singleTapBackground.numberOfTapsRequired = 1
        fadeView.addGestureRecognizer(singleTapBackground)
        
        view.addSubview(fadeView)
        
        // Get the height and width of the view
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        
        // Add the menu button
        let menuButtonSize = tabBar.frame.height * 1.1
        
        menuButton = UIButton(frame: CGRect(x: viewWidth / 2 - menuButtonSize / 2, y: viewHeight - menuButtonSize * 1.05, width: menuButtonSize, height: menuButtonSize))
        
        menuButton.setImage(UIImage(named: "menu-button"), forState: UIControlState.Normal)
        
        // Add a gesture recognizer to the menu button
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CustomTabBarController.menuTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        menuButton.addGestureRecognizer(singleTap)
        
        // Add the buttons revealsed when the menu "explodes"
        // Give each its own gusture recognizer
        let menuItemSize = CGFloat(Int(0.9 * menuButtonSize))
        
        logoutButton = UIButton(frame: CGRect(x: viewWidth / 2 - menuItemSize / 2, y: viewHeight - menuButtonSize * 1.05, width: menuItemSize, height: menuItemSize))
        logoutButton.setImage(UIImage(named: "Logout"), forState: UIControlState.Normal)
        
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(CustomTabBarController.logOutTapped(_:)))
        logoutTap.numberOfTapsRequired = 1
        logoutButton.addGestureRecognizer(logoutTap)
        
        profileButton = UIButton(frame: CGRect(x: viewWidth / 2 - menuItemSize / 2, y: viewHeight - menuButtonSize * 1.05, width: menuItemSize, height: menuItemSize))
        profileButton.setImage(UIImage(named: "Food"), forState: UIControlState.Normal)
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(CustomTabBarController.profileTapped(_:)))
        profileTap.numberOfTapsRequired = 1
        profileButton.addGestureRecognizer(profileTap)
        
        tweetButton = UIButton(frame: CGRect(x: viewWidth / 2 - menuItemSize / 2, y: viewHeight - menuButtonSize * 1.05, width: menuItemSize, height: menuItemSize))
        tweetButton.setImage(UIImage(named: "tweetthumb"), forState: UIControlState.Normal)
        
        let tweetTap = UITapGestureRecognizer(target: self, action: #selector(CustomTabBarController.tweetTapped(_:)))
        tweetTap.numberOfTapsRequired = 1
        tweetButton.addGestureRecognizer(tweetTap)
        
        // Hide the built-in tab bar
        tabBar.hidden = true
        
        // Configure the custom tab bar
        customTabBar = UITabBar(frame: CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y, width: tabBar.frame.width, height: tabBar.frame.height))
        
        // Initiate each view controller and assign its associated tab bar item
        vcA = (storyboard?.instantiateViewControllerWithIdentifier("Timeline"))! as UIViewController
        vcHidden = (storyboard?.instantiateViewControllerWithIdentifier("Hidden"))! as
        UIViewController
        
        
        // Add the view controllers to the tab bar controller
        viewControllers = [vcA, vcHidden]
        
        // Disable editing of the tab bar arrangement
        customizableViewControllers = []
        
        // Set the first one as selected by default
        selectedViewController = vcA
        customTabBar.selectedItem = itemA
        selectedItem = itemA
        
        // Set this class as the tab bar delegate
        customTabBar.delegate = self
        
        // Hide the fadeView for now (brought to the front when triggered by user interaction)
        view.sendSubviewToBack(fadeView)
        
        // Add the customTabBar and exploding menu elements
        view.addSubview(customTabBar)
        view.addSubview(logoutButton)
        view.addSubview(profileButton)
        view.addSubview(tweetButton)
        view.addSubview(menuButton)

    }
    
    // MARK: - Tab Bar Delegate Methods
    
    // Responds to tab bar item selection
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        // Select the view controller associated with the chosen tab bar item and update selectedItem
        // unless the hidden item is tapped, in which case do nothing
        switch(item) {
        case itemA:
            selectedViewController = vcA
            customTabBar.selectedItem = itemA
            selectedItem = itemA
            break
        case hiddenItem:
            customTabBar.selectedItem = selectedItem
            break
              default:
            selectedViewController = vcA
            customTabBar.selectedItem = itemA
            break
        }
    }
    
    // MARK: - Gesture Recognizer Methods
    
    // This method is invoked when the menu is tapped
    func menuTapped(gestureRecognizer: UIGestureRecognizer) {
        
        // If the menu is closed, open it
        if(!menuEnabled) {
            
            menuEnabled = true
            openMenu()
        }
            // If the menu is open, close it
        else {
            
            menuEnabled = false
            closeMenu(true)
        }
        
    }
    
    // This method is invoked when the gray background is tapped
    func backgroundTapped(gestureRecognizer: UIGestureRecognizer) {
        
        // Close the menu
        menuEnabled = false
        closeMenu(true)
    }
    

    // This method is invoked when the water button is tapped
    func logOutTapped(gestureRecognizer: UIGestureRecognizer) {
        
        // Animate fading out the other buttons and opening the custom alert view
        UIView.animateWithDuration(0.4, animations: {
            
            self.profileButton.alpha = 0.0
            self.tweetButton.alpha = 0.0
            }, completion: { (value: Bool) in
                
                self.menuEnabled = false
                self.closeMenu(false)
                //self.openCustomAlertView() // make this unique for a more interesting user interface
                
                Twitter.sharedInstance().sessionStore.logOutUserID(self.appDelegate.twittderID)
                print("signed out from \(self.appDelegate.twittderID)")
                self.performSegueWithIdentifier("logOut", sender: self)
        })
    }
    
    // This method is invoked when the exercise button is tapped
    func tweetTapped(gestureRecognizer: UIGestureRecognizer) {
        
        // Animate fading out the other buttons and opening the custom alert view
        UIView.animateWithDuration(0.4, animations: {
            
            self.logoutButton.alpha = 0.0
            self.profileButton.alpha = 0.0
            }, completion: { (value: Bool) in
                
                self.menuEnabled = false
                self.closeMenu(false)
               // self.openCustomAlertView() // make this unique for a more interesting user interface
                
                if let session = Twitter.sharedInstance().sessionStore.session() {
                    
                    // User generated image
                    let image = UIImage()
                    
                    // Create the card and composer
                    let card = TWTRCardConfiguration.appCardConfigurationWithPromoImage(image, iPhoneAppID: "12345", iPadAppID: nil, googlePlayAppID: nil)
                    let composer = TWTRComposerViewController(userID: session.userID, cardConfiguration: card)
                    
                    // Optionally set yourself as the delegate
                    //composer.delegate = self
                    
                    // Show the view controller
                    self.presentViewController(composer, animated: true, completion: nil)
                }

        })
    }
    
    // This method is invoked when the weight button is tapped
    func profileTapped(gestureRecognizer: UIGestureRecognizer) {
        
        // Animate fading out the other buttons and opening the custom alert view
        UIView.animateWithDuration(0.4, animations: {
            
            self.logoutButton.alpha = 0.0
            self.profileButton.alpha = 0.0
            self.tweetButton.alpha = 0.0
            }, completion: { (value: Bool) in
                
                self.menuEnabled = false
                self.closeMenu(false)
                self.openCustomAlertView() // make this unique for a more interesting user interface
        })
    }
    
    // MARK: Menu Animations
    
    // Animates opening the exploding menu
    func openMenu() {
        
        // Restore the opaqueness of all the buttons
        self.logoutButton.alpha = 1.0
        self.profileButton.alpha = 1.0
        self.tweetButton.alpha = 1.0
        
        // Bring the buttons and fadeView to front such that the fadeView covers everything EXCEPT the buttons
        self.view.bringSubviewToFront(self.fadeView)
        self.view.bringSubviewToFront(self.logoutButton)
        self.view.bringSubviewToFront(self.profileButton)
        self.view.bringSubviewToFront(self.tweetButton)
        self.view.bringSubviewToFront(self.menuButton)
        
        // Animate rotating to menu button and fading the background quickly
        UIView.animateWithDuration(0.3, animations: {
            
            self.menuButton.transform = CGAffineTransformMakeRotation((-45.0 * CGFloat(M_PI)) / 180.0)
            self.fadeView.alpha = 0.7
            }, completion: nil)
        
        // Animate springing out the individual menu buttons a little more slowly
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            
            self.logoutButton.transform = CGAffineTransformMakeTranslation(-0.18 * self.viewWidth, -0.22 * self.viewHeight)
            self.profileButton.transform = CGAffineTransformMakeTranslation(0, -0.25 * self.viewHeight)
            self.tweetButton.transform = CGAffineTransformMakeTranslation(0.18 * self.viewWidth, -0.22 * self.viewHeight)
            }, completion: nil)
    }
    
    // Animates opening the exploding menu
    func closeMenu(unfadeBackground: Bool) {
        
        // Animate bring all the buttons back underneath the main menu button
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            
            // If the caller passes in true, make the fadeView completely transparent
            if unfadeBackground {
                
                self.fadeView.alpha = 0.0
            }
            
            self.menuButton.transform = CGAffineTransformMakeRotation(0.0)
            self.logoutButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.profileButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.tweetButton.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: { (value: Bool) in
                
                // If the caller passes in true, move the fadeView to the back
                // (completely restoring the UI to how it was before opening the menu)
                if unfadeBackground {
                    
                    self.view.sendSubviewToBack(self.fadeView)
                }
        })
    }
    
    // MARK: - Custom Alert View
    
    // Instantiate and present the custom alert view (popup)
    func openCustomAlertView() {
        
        let alert = storyboard?.instantiateViewControllerWithIdentifier("alert") as! CustomAlertViewController
        alert.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        alert.sender = self
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Custom Navigation
    
    // Called downstream to handle custom alert view's selection
    func segueToDetailViewController() {
        
        self.performSegueWithIdentifier("alertViewRowSelected", sender: self)
    }
    
    // MARK: - Prepare for Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "alertViewRowSelected" {
            let detailController = segue.destinationViewController as! DetailViewController
            // Pass the selection downstream
            detailController.selection = selection
            self.fadeView.alpha = 0.0
            self.view.sendSubviewToBack(self.fadeView)
        }
        
    }
}

