//
//  ViewViewController.swift
//  GMKeyboard
//
//  Created by gdollardollar on 9/21/16.
//

import UIKit
import GMKeyboard

class BottomViewViewController: UIViewController, BottomViewKeyboardObserver {

    @IBOutlet var translatableViews: [UIView]!

    @IBOutlet weak var bottomView: UIView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        addKeyboardObservers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        removeKeyboardObservers()
    }

    @IBAction func click(sender: UIButton) {
        self.view.endEditing(true)
    }
}
