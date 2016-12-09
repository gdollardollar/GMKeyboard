//
//  ConstrainedKeyboardObserver.swift
//  Pods
//
//  Created by Guillaume on 12/4/16.
//
//

import Foundation

public protocol BottomConstraintKeyboardObserver: AnimatedKeyboardObserver {
    
    weak var bottomConstraint: NSLayoutConstraint! { get }
    
    var bottomOffset: CGFloat { get }
    
}

extension BottomConstraintKeyboardObserver where Self: UIViewController {
    
    public var bottomOffset: CGFloat {
        return 0
    }
    
    public func animateKeyboardChange(frameInView frame: CGRect, userInfo: [AnyHashable : Any]) {
        bottomConstraint.constant = bottomOffset + max(0, view.bounds.height - frame.minY)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}

public protocol BottomViewKeyboardObserver: AnimatedKeyboardObserver {
    
    var translatableViews: [UIView]! { get }
    
    weak var bottomView: UIView! { get }
    
    var minimumMargin: CGFloat { get }
    
}

extension BottomViewKeyboardObserver where Self: UIViewController {
    
    public var translatableViews: [UIView]! {
        return [bottomView]
    }
    
    public var minimumMargin: CGFloat {
        return 10
    }
    
    public func animateKeyboardChange(frameInView frame: CGRect, userInfo: [AnyHashable : Any]) {
        
        let oldT = bottomView.transform
        bottomView.transform = .identity
        let ty = -max(0, view.convert(bottomView.frame, from: bottomView.superview!).maxY - frame.minY)
        bottomView.transform = oldT
        
        translatableViews.forEach { $0.transform.ty = ty }
        
    }
    
}
