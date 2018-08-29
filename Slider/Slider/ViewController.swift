//
//  ViewController.swift
//  Slider
//
//  Created by adam on 2018-08-29.
//  Copyright © 2018 adam. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let custom:CustomSlider = CustomSlider.init(frame: NSMakeRect(200, 200, 300, 30))

        self.view.addSubview(custom)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

