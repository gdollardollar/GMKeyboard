//
//  UIViewController+GM.swift
//  tectec
//
//  Created by Guillaume Aquilina on 12/18/15.
//  Copyright © 2015 Tectec App. All rights reserved.
//

//TODO: this should be based on a protocol extension instead of categorizing UIViewController

import UIKit

private var GM_KEYBOARD_ASSOCIATED_KEY = "GM_ASSOCIATED_KEY"

private func _gm_optionFromCurve(_ rawValue: Int32) -> UIViewAnimationOptions {
    let curve = UIViewAnimationCurve(rawValue: Int(rawValue))!
    switch curve {
    case .easeIn:
        return .curveEaseIn
    case .easeOut:
        return .curveEaseOut
    case .easeInOut:
        return UIViewAnimationOptions()
    case .linear:
        return .curveLinear
    }
}

extension UIViewController {
    
    public fileprivate(set) var gm_keyboardIsDisplayed: Bool {
        get {
            return objc_getAssociatedObject(self, &GM_KEYBOARD_ASSOCIATED_KEY) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &GM_KEYBOARD_ASSOCIATED_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func gm_addKeyboardObservers() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(UIViewController.gm_keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(UIViewController.gm_keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public func gm_removeKeyboardObservers() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    open func gm_keyboardWillShow(_ notification: Notification) {
        gm_keyboardIsDisplayed = true
        _gm_handleNotificationUserInfo((notification as NSNotification).userInfo!)
    }
    
    open func gm_keyboardWillHide(_ notification: Notification) {
        gm_keyboardIsDisplayed = false
        _gm_handleNotificationUserInfo((notification as NSNotification).userInfo!)
    }
    
    open func _gm_handleNotificationUserInfo(_ userInfo: [AnyHashable: Any]) {
        gm_keyboardWillChangeFrameInView((userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue,
            animationDuration: (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue,
            animationOptions: _gm_optionFromCurve((userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).int32Value),
            userInfo: userInfo)
    }
    
    open func gm_keyboardWillChangeFrameInView(_ frame: CGRect,
        animationDuration: TimeInterval,
        animationOptions: UIViewAnimationOptions,
        userInfo: [AnyHashable: Any]) {
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: [animationOptions, .beginFromCurrentState], animations: { () -> Void in
                
                self.gm_animateKeyboardFrameChangeInView(frame, userInfo: userInfo)
                
                }, completion: nil)
            
    }
    
    open func gm_animateKeyboardFrameChangeInView(_ frame: CGRect, userInfo: [AnyHashable: Any]) {
        
    }
    
    
}
