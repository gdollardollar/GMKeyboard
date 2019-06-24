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
    var bottomConstraint: NSLayoutConstraint! { get }

    /// An offset added to the calculated value of the constraint
    ///
    /// The default implementation returns the distance between the
    /// bottom of the second item of the `bottomConstraint` when the
    /// bottomConstraint.constant is equal to 0 and the bottom of the superview
    /// (Only if the item is a view and has a superview):
    ///
    /// `view.frame.maxY + bottomConstraint.constant - superview.bounds.height`
    ///
    /// This just means that the bottom of the secont item will be aligned with
    /// the top of the keyboard when it is displayed.
    var bottomOffset: CGFloat { get }

    /// This method is called to calculate the bottom constraint constant for
    /// a certain keyboard state.
    /// The result is assigned to the bottomConstraint?.constant in the
    /// `animateKeyboardChange(frameInView: userInfo:)` method before a
    /// new layout is requested.
    ///
    /// The default implementation assumes that the view is at `bottomOffset`
    /// and adds the keyboard height.
    ///
    ///
    /// - Parameters:
    ///   - frame: the frame of the keyboard in the view
    ///   - userInfo: the user info
    /// - Returns: the new `bottomConstraint` constant
    func computeBottomConstraintConstant(frameInView frame: CGRect, userInfo: [AnyHashable: Any]) -> CGFloat

}

extension BottomConstraintKeyboardObserver where Self: UIViewController {

    public var bottomOffset: CGFloat {
        guard let view = bottomConstraint?.secondItem as? UIView,
            let superview = view.superview else {
            return 0
        }

        return view.frame.maxY + bottomConstraint.constant - superview.bounds.height
    }

    public func computeBottomConstraintConstant(frameInView frame: CGRect, userInfo: [AnyHashable: Any]) -> CGFloat {
        let kHeight = max(0, view.bounds.height - frame.minY)
        let guideOffset: CGFloat

        if #available(iOS 11.0, *),
            (bottomConstraint?.firstItem is UILayoutGuide || bottomConstraint?.secondItem is UILayoutGuide),
            kHeight > 0 {
            guideOffset = -self.view.safeAreaInsets.bottom
        } else {
            guideOffset = 0
        }

        return max(0, guideOffset + bottomOffset + kHeight)
    }

    public func animateKeyboardChange(frameInView frame: CGRect, userInfo: [AnyHashable: Any]) {
        bottomConstraint?.constant = computeBottomConstraintConstant(frameInView: frame, userInfo: userInfo)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

}
