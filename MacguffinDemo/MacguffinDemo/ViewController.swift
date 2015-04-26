//
//  ViewController.swift
//  MacguffinDemo
//
//  Created by Evan Hildreth on 3/15/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var bottomConsole: NSTextField!

    @IBOutlet weak var player1name: NSTextField!
    @IBOutlet weak var player1status: NSTextField!
    @IBOutlet weak var player1bar: NSProgressIndicator!
    
    @IBOutlet weak var player2name: NSTextField!
    @IBOutlet weak var player2status: NSTextField!
    @IBOutlet weak var player2bar: NSProgressIndicator!
    
    @IBOutlet weak var player3name: NSTextField!
    @IBOutlet weak var player3status: NSTextField!
    @IBOutlet weak var player3bar: NSProgressIndicator!
    
    @IBOutlet weak var player4name: NSTextField!
    @IBOutlet weak var player4status: NSTextField!
    @IBOutlet weak var player4bar: NSProgressIndicator!
}

