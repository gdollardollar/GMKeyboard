//
//  ConstraintKeyboardObserver.swift
//  GMKeyboard
//
//  Created by Guillaume Aquilina on 3/6/19.
//  Copyright © 2019 Gdollardollar. All rights reserved.
//

import Foundation

/// This keyboard Observer is a hybrid between the `BottomConstraintKeyboardObserver` and
/// `BottomViewKeyboardObserver`.
///
/// This will basically try to increase the `keyboardConstraint`'s constant so that the `bottomView` is at most at
/// `minimumMargin` from the keyboard.
///
/// This is proposed as a way to better handle the safe areas.
public protocol ConstraintKeyboardObserver: AnimatedKeyboardObserver {

    /// A view that should remain above the keyboard.
    ///
    /// Defaults to the second item of the `keyboardConstraint`
    var bottomView: UIView? { get }

    /// The space between the keyboard and the `bottomView`
    ///
    /// Defaults to `10`
    var keyboardMargin: CGFloat { get }

    /// A constraint that will be updated when the keyboard is displayed. It is assume that increasing the constant
    /// will move the `bottomView` upwards.
    ///
    /// This is the only required parameter of this protocol
    var keyboardConstraint: NSLayoutConstraint? { get }

    /// This method is called to calculate the bottom constraint constant for
    /// a certain keyboard state.
    ///
    /// The result is assigned to the keyboardConstraint?.constant in the
    /// `animateKeyboardChange(frameInView: userInfo:)` method before a
    /// new layout is requested.
    ///
    /// The default implementation does not make any assumption about min or max constraint constant. Instead, it
    /// will try to always compute a constant that places the `bottomView` at `keyboardMargin` from the keyboard's top.
    /// You should place additional constraints to prevent the view from moving in a non desired way.
    ///
    /// - Parameters:
    ///   - frame: the frame of the keyboard in the view
    ///   - userInfo: the user info
    /// - Returns: the new `bottomConstraint` constant
    func computeConstraintConstant(frameInView frame: CGRect, userInfo: [AnyHashable : Any]) -> CGFloat
    
}


extension ConstraintKeyboardObserver where Self: UIViewController {

    public var bottomView: UIView? {
        return keyboardConstraint?.secondItem as? UIView
    }

    public var keyboardMargin: CGFloat {
        return 10
    }

    public func computeConstraintConstant(frameInView frame: CGRect, userInfo: [AnyHashable : Any]) -> CGFloat {
        guard let bottomView = self.bottomView else {
            return 0
        }

        // Y of the bottom of the `bottomView` in the view coordinate system
        let bottomFrameBottom = view.convert(bottomView.frame, from: bottomView.superview).maxY

        // Translation required to put the bottom of the `bottomView` at `keyboardMargin` from the keyboard
        let ty = frame.minY - (bottomFrameBottom + keyboardMargin)

        return (keyboardConstraint?.constant ?? 0) - ty
    }

    public func animateKeyboardChange(frameInView frame: CGRect, userInfo: [AnyHashable : Any]) {
        keyboardConstraint?.constant = computeConstraintConstant(frameInView: frame, userInfo: userInfo)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

}
