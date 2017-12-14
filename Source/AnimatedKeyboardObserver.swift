//
//  AnimatedKeyboardObserver.swift
//  Pods
//
//  Created by gdollardollar on 12/4/16.
//

import Foundation

/// Layer on top of `KeyboardObserver` that simplifies animating
/// the layout updates.
/// This protocol simply provides a default implementation to
/// `keyboardWillChange(frameInView:animationDuration:animationOptions:userInfo:)`
/// that calls `animateKeyboardChange(frameInView:,userInfo:) in an animation
/// block with the appropriate duration and options.
public protocol AnimatedKeyboardObserver: KeyboardObserver {
    
    
    /// Use this method to prevent animation in certain cases.
    ///
    /// For example, you might want to disable animations as long as
    /// a scrollview is dragged
    ///
    /// - Parameters:
    ///   - frame: the keyboard frame in the view controller's view
    ///   - userInfo: the keyboard notification user info
    /// - Returns: true if it should animate
    func shouldAnimateKeyboardChange(frameInView frame: CGRect, userInfo: [AnyHashable: Any]) -> Bool
    
    
    /// Function called when the keyboard frame changes.
    /// This function is called in an animation block with
    /// the appropriate values.
    ///
    /// - Parameters:
    ///   - frame: the keyboard frame in the view controller's view
    ///   - userInfo: the keyboard notification user info
    func animateKeyboardChange(frameInView frame: CGRect, userInfo: [AnyHashable: Any])
    
}

extension AnimatedKeyboardObserver {
    
    public func shouldAnimateKeyboardChange(frameInView frame: CGRect, userInfo: [AnyHashable: Any]) -> Bool {
        return true
    }
    
    public func keyboardWillChange(frameInView frame: CGRect,
                            animationDuration: TimeInterval,
                            animationOptions: UIViewAnimationOptions,
                            userInfo: [AnyHashable : Any]) {
        
        guard shouldAnimateKeyboardChange(frameInView: frame, userInfo: userInfo) else {
            return
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [animationOptions, .beginFromCurrentState], animations: { () -> Void in
            
            self.animateKeyboardChange(frameInView: frame, userInfo: userInfo)
            
        }, completion: nil)
    }
    
}
