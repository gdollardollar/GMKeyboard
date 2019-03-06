//
//  ConstraintViewController.swift
//  GMKeyboard
//
//  Created by gdollardollar on 12/14/17.
//

import UIKit
import GMKeyboard

class BottomConstraintViewController: UIViewController, BottomConstraintKeyboardObserver {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

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
