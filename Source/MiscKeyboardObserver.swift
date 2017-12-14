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
        
        let kHeight = max(0, view.bounds.height - frame.minY)
        let guideOffset: CGFloat
        
        if #available(iOS 11.0, *),
            (bottomConstraint?.firstItem is UILayoutGuide || bottomConstraint?.secondItem is UILayoutGuide),
            kHeight > 0 {
            guideOffset = -self.view.safeAreaInsets.bottom
        } else {
            guideOffset = 0
        }
        
        bottomConstraint?.constant = guideOffset + bottomOffset + kHeight
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
        let ty = -max(0, view.convert(bottomView.frame, from: bottomView.superview!).maxY + minimumMargin - frame.minY)
        bottomView.transform = oldT
        
        translatableViews.forEach { $0.transform.ty = ty }
        
    }
    
}
