//
//  BottomViewKeyboardObserver.swift
//  GMKeyboard
//
//  Created by gdollardollar on 12/4/16.
//

import Foundation


/// Layer on top of `AnimatedKeyboardObserver` that guarantees that
/// a view at the bottom of the screen will still be visible when
/// the keyboard is displayed.
///
/// It is based on the y translation of the said view and allows
/// translating other views at the same time.
public protocol BottomViewKeyboardObserver: AnimatedKeyboardObserver {
    
    /// The view that should remain above the keyboard.
    var bottomView: UIView! { get }
    
    /// An array of views that will be translated of the
    /// same amount as the the `bottomView`.
    /// The default implementation simply returns the `bottomView`.
    /// If it does not contain `bottomView`, then it will not
    /// be translated and might be hidden by the keyboard.
    var translatableViews: [UIView]! { get }
    
    /// The minimum space between the keyboard and the `bottomView`
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
