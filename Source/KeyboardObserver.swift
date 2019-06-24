//
//  UIViewController+GM.swift
//  tectec
//
//  Created by gdollardollar on 12/18/15.
//

import UIKit

/// #Base protocol for Keyboard Observing
///
/// It provides a simplified way to handle keyboard notifications.
/// For a basic implementation:
/// - Make your UIViewController conform to the `KeyboardObserver` protocol
/// - Call `addKeyboardObservers()` in `viewWillAppear(animated:)` and
/// `removeKeyboardObservers()` in `viewWillDisappear(animated:)`
/// - Override `keyboardWillChange(frameInView:animationDuration:animationOptions:userInfo:)`
public protocol KeyboardObserver: class {

    /// Boolean value that is set when keyboard is displayed.
    ///
    /// The default implementation stores it as an associated object,
    /// Feel free to override it to provide your own implementation.
    var isKeyboardDisplayed: Bool { get set }

    /// Array containing all the keyboard observers.
    /// Notifications had to be handled using a block method to allow calling
    /// protocol methods. Observers then had to be store manually to be
    /// removed on exit.
    ///
    /// The default implementation stores it as an associated object,
    /// Feel free to override it to provide your own implementation.
    var keyboardObservers: [Any]? { get set }

    /// This method is called when the `UIKeyboardWillShow` notification
    /// is triggered, i-e everytime the keyboard frame
    /// changes.
    ///
    /// Override this method only when you need special handling when the
    /// keyboard is shown.
    /// If you need to do something only when the keyboard is displayed,
    /// you should probably override the `isKeyboardDisplayed` to detect
    /// changes instead.
    /// If all you need to do is update the layouts, you should probably
    /// not override this method directly (Override
    /// `keyboardWillChange(frameInView:animationDuration:animationOptions:userInfo:)
    /// instead).
    ///
    /// If you override it, to preserve behavior, call:
    /// ```isKeyboardDisplayed = true
    /// handleKeyboardNotificationUserInfo(notification.userInfo!)```
    ///
    /// - Parameter notification: the keyboard notification
    func keyboardWillShow(notification: Notification)

    /// This method is called when the `UIKeyboardWillHide` notification
    /// is triggered, i-e when the keyboard hides.
    ///
    /// Override this method only when you need special handling when the
    /// keyboard is hidden.
    ///
    /// If all you need to do is update the layouts, you should probably
    /// not override this method directly (Override
    /// `keyboardWillChange(frameInView:animationDuration:animationOptions:userInfo:)
    /// instead).
    ///
    /// If you override it, to preserve behavior, call:
    /// ```isKeyboardDisplayed = false
    /// handleKeyboardNotificationUserInfo(notification.userInfo!)```
    ///
    /// - Parameter notification: the keyboard notification
    func keyboardWillHide(notification: Notification)

    /// Base method to be overriden.
    /// It takes the appropriate parameters present in the Notification
    /// userInfo and presents them in a nicer way
    ///
    /// - Parameters:
    ///   - frame: the frame of the keyboard in the UIViewController's view
    ///   - animationDuration: the duration of the animation `UIKeyboardAnimationDurationUserInfoKey`
    ///   - animationOptions: the animation curve, adapted from `UIKeyboardAnimationCurveUserInfoKey`
    ///   - userInfo: the notification userInfo dictionary
    func keyboardWillChange(frameInView frame: CGRect,
                            animationDuration: TimeInterval,
                            animationOptions: UIView.AnimationOptions,
                            userInfo: [AnyHashable: Any])
}

extension KeyboardObserver where Self: UIViewController {

    /// Handles the notification and calls
    /// `keyboardWillChange(frameInView:animationDuration:animationOptions:userInfo:)
    /// with the right parameters from the userInfo dictionary
    ///
    /// - Parameter userInfo: the notification userInfo
    public func handleKeyboardNotificationUserInfo(_ userInfo: [AnyHashable: Any]) {
        guard isViewLoaded else {
            return
        }

        keyboardWillChange(frameInView: self.view.convert(userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect, from: nil),
                           animationDuration: userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval,
                           animationOptions: _gm_optionFromCurve(userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int),
                           userInfo: userInfo)
    }

    /// Handles `UIKeyboardWillShow` notification
    /// Sets `isKeyboardDisplayed` to `true` and calls
    /// handleKeyboardNotificationUserInfo(_:)
    ///
    /// - Parameter notification: the notification
    public func keyboardWillShow(notification: Notification) {
        isKeyboardDisplayed = true
        handleKeyboardNotificationUserInfo(notification.userInfo!)
    }

    /// Handles `UIKeyboardWillHide` notification
    /// Sets `isKeyboardDisplayed` to `false` and calls
    /// handleKeyboardNotificationUserInfo(_:)
    ///
    /// - Parameter notification: the notification
    public func keyboardWillHide(notification: Notification) {
        isKeyboardDisplayed = false
        handleKeyboardNotificationUserInfo(notification.userInfo!)
    }

    /// Adds the keyboard observers to the default notification center
    /// and stores them in the `keyboardObservers` variable
    public func addKeyboardObservers() {
        let center = NotificationCenter.default
        //Doing blocks because compiler complains that methods are not visible to obj-C
        keyboardObservers = [
            center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
               self.keyboardWillShow(notification: notification)
            },
            center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { notification in
                self.keyboardWillHide(notification: notification)
            }
        ]
    }

    /// Stores keyboard observers
    /// Default implementation is an associated object
    public var keyboardObservers: [Any]? {
        get {
            return objc_getAssociatedObject(self, &GM_OBSERVERS_KEY) as? [Any] ?? nil
        }
        set {
            objc_setAssociatedObject(self, &GM_OBSERVERS_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// Removes keyboard observers from the default notification center
    /// and sets `keyboardObservers` to nil
    public func removeKeyboardObservers() {
        let center = NotificationCenter.default
        keyboardObservers?.forEach { center.removeObserver($0) }
        keyboardObservers = nil

        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// `true` if keyboard is displayed
    /// Only set if observers were properly
    public var isKeyboardDisplayed: Bool {
        get {
            return objc_getAssociatedObject(self, &GM_ISKEYBOARDDISPLAYED_KEY) as? Bool ?? false
        }
        set {
             objc_setAssociatedObject(self, &GM_ISKEYBOARDDISPLAYED_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }

}

private var GM_ISKEYBOARDDISPLAYED_KEY = "GMKeyboard.isKeyboardDisplayed"
private var GM_OBSERVERS_KEY = "GMKeyboard.observers"

private func _gm_optionFromCurve(_ rawValue: Int) -> UIView.AnimationOptions {
    switch rawValue {
    case 0:
        return .curveEaseIn
    case 1:

        return .curveEaseOut
    case 2:
        return .curveEaseInOut
    case 3:
        return .curveLinear
    default:
        return .curveEaseInOut
    }
}
