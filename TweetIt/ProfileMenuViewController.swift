//
//  ProfileMenuViewController.swift
//  TweetIt
//
//  Created by Andrew Mogg on 7/23/16.
//  Copyright © 2016 Andrew Mogg. All rights reserved.

//

import UIKit

class ProfileMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    // Stores the user's selected row to pass upstream
    var selection = ""
    // Passed from upstream to trigger a callback upon returning to upstream view controller
    var sender: MainController!

    // MARK: - View Did Load
    
    @IBOutlet var handleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLabel.text! = appDelegate.userName

    }
    
    // MARK: TableViewDelegate Methods
    
    // Disallow editing
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    // Disallow moving rows
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    // Handle row creation
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("simpleLabelRow")
        
        // Assign for simple labels
        switch(row) {
        case 0:
            cell!.textLabel!.text = appDelegate.name
            break
        case 1:
            cell!.textLabel!.text = appDelegate.location
            break
        case 2:
            cell!.textLabel!.text = "Followers: \(appDelegate.followers)"
            break
        case 3:
            cell!.textLabel!.text = "Following: \(appDelegate.friends)"
            break
        default:
            cell!.textLabel!.text = "Error"
            break
        }
        
        return cell!
    }
    
    // MARK: TableViewDataSource Methods
    
    // Fixed (4) number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

    // MARK: IBOutlet to Button

    @IBAction func closeClicked(sender: UIButton) {
        
        // Close and return to upstream control
        dismissViewControllerAnimated(true, completion: nil)
    }
}
