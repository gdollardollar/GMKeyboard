//
//  BottomConstraintKeyboardObserver.swift
//  GMKeyboard
//
//  Created by gdollardollar on 12/14/17.
//

import Foundation


/// Layer on top of `AnimatedKeyboardObserver` that handles updating
/// a constraint at the bottom of the view controller.
/// The constraint is updated based on the `bottomOffset`, the
/// keyboard height and whether or not the constraint is linked to the safe
/// area (iOS 11 only)
///
/// The safe area handling only works for iOS 11 and if the
/// "Use safe area" checkbox is checked in the storyboard.
public protocol BottomConstraintKeyboardObserver: AnimatedKeyboardObserver {
    
    /// A constraint at the bottom of the view that will be updated when the
    /// keyboard is displayed.
    weak var bottomConstraint: NSLayoutConstraint! { get }
    
    
    /// An offset added to the calculated value of the constraint
    /// You could very well provide a different value depending on if
    /// the keyboard is displayed.
    ///
    /// The default implementation simply returns 0
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
