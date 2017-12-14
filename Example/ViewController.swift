//
//  ViewController.swift
//  GMKeyboard
//
//  Created by Guillaume on 9/21/16.
//  Copyright © 2016 Guillaume. All rights reserved.
//

import UIKit
import GMKeyboard

class ViewController: UIViewController, BottomViewKeyboardObserver {
    
    @IBOutlet var translatableViews: [UIView]!
    
    @IBOutlet weak var bottomView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyboardObservers()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func click(sender: UIButton) {
        self.view.endEditing(true)
    }
}

