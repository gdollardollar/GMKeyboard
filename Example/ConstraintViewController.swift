//
//  ConstraintViewController.swift
//  Example
//
//  Created by John Paul on 12/14/17.
//  Copyright © 2017 Guillaume. All rights reserved.
//

import UIKit
import GMKeyboard

class ConstraintViewController: UIViewController, BottomConstraintKeyboardObserver {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    @IBAction func click(sender: UIButton) {
        self.view.endEditing(true)
    }

}
