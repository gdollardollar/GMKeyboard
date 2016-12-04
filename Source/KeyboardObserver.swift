//
//  UIViewController+GM.swift
//  tectec
//
//  Created by Guillaume Aquilina on 12/18/15.
//  Copyright © 2015 Tectec App. All rights reserved.
//

//TODO: this should be based on a protocol extension instead of categorizing UIViewController

import UIKit

public protocol KeyboardObserver: class {
    
    var isKeyboardDisplayed: Bool { get set }
    
    var keyboardObservers: [Any]? { get set }
    
    func keyboardWillChange(frameInView frame: CGRect,
                            animationDuration: TimeInterval,
                            animationOptions: UIViewAnimationOptions,
                            userInfo: [AnyHashable: Any])
}

extension KeyboardObserver {
    
    private func _gm_handleNotificationUserInfo(_ userInfo: [AnyHashable: Any]) {
        keyboardWillChange(frameInView: (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue,
                           animationDuration: (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue,
                           animationOptions: _gm_optionFromCurve((userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).int32Value),
                           userInfo: userInfo)
    }
    
    public func addKeyboardObservers() {
        let center = NotificationCenter.default
        keyboardObservers = [
            center.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { notification in
                self.isKeyboardDisplayed = true
                self._gm_handleNotificationUserInfo(notification.userInfo!)
            },
            center.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { notification in
                self.isKeyboardDisplayed = false
                self._gm_handleNotificationUserInfo(notification.userInfo!)
            }
        ]
    }
    
    public var keyboardObservers: [Any]? {
        get {
            return objc_getAssociatedObject(self, &GM_OBSERVERS_KEY) as? [AnyObject] ?? nil
        }
        set {
            objc_setAssociatedObject(self, &GM_OBSERVERS_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func removeKeyboardObservers() {
        let center = NotificationCenter.default
        keyboardObservers?.forEach { center.removeObserver($0) }
        
        
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public var isKeyboardDisplayed: Bool {
        get {
            return objc_getAssociatedObject(self, &GM_ISKEYBOARDDISPLAYED_KEY) as? Bool ?? false
        }
        set {
             objc_setAssociatedObject(self, &GM_ISKEYBOARDDISPLAYED_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
}

fileprivate var GM_ISKEYBOARDDISPLAYED_KEY = "GMKeyboard.isKeyboardDisplayed"
fileprivate var GM_OBSERVERS_KEY = "GMKeyboard.observers"

fileprivate func _gm_optionFromCurve(_ rawValue: Int32) -> UIViewAnimationOptions {
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
