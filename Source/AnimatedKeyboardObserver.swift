//
//  AnimatedKeyboardObserver.swift
//  Pods
//
//  Created by Guillaume on 12/4/16.
//
//

import Foundation

public protocol AnimatedKeyboardObserver: KeyboardObserver{
    
    func animateKeyboardChange(frameInView frame: CGRect, userInfo: [AnyHashable: Any])
    
}

extension AnimatedKeyboardObserver {
    
    public func keyboardWillChange(frameInView frame: CGRect,
                            animationDuration: TimeInterval,
                            animationOptions: UIViewAnimationOptions,
                            userInfo: [AnyHashable : Any]) {
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [animationOptions, .beginFromCurrentState], animations: { () -> Void in
            
            self.animateKeyboardChange(frameInView: frame, userInfo: userInfo)
            
        }, completion: nil)
    }
    
}
