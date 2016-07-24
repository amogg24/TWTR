//
//  DetailViewController.swift
//  ExplodingMenu
//
//  Created by Nicholas Montgomery on 4/25/15.
//  Copyright (c) 2015 Nicholas Montgomery. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    // Passed from upstream
    var selection = ""

    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Put a blue background behind the bar at the top (for formatting)
        var barBackground: UIView = UIView(frame: CGRectMake(0, 0, view.frame.width, 20.0))
        barBackground.backgroundColor = UIColor(red: 6 / 255.0, green: 101 / 255.0, blue: 191 / 255.0, alpha: 1.0)
        view.addSubview(barBackground)

        label.text = selection
    }

    // MARK: IBOutlet for Back (Custom)
    
    @IBAction func backClicked(sender: UIBarButtonItem) {
        
        // Close and return to upstream control
        dismissViewControllerAnimated(true, completion: nil)
    }
}
