//
//  ConstraintViewController.swift
//  Example
//
//  Created by Guillaume Aquilina on 3/6/19.
//  Copyright © 2019 Guillaume. All rights reserved.
//

import UIKit
import GMKeyboard

class ConstraintViewController: UIViewController, BottomConstraintKeyboardObserver {

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
