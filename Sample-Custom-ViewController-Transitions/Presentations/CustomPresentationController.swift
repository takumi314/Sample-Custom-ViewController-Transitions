//
//  CustomPresentationController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/22.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {

    // MARK: - Private property

    private var dimmingView: UIView? = nil
    private var presentationWrappingView: UIView? = nil


    // MARK: - Initializer

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        // The presented view controller must have a modalPresentationStyle
        // of UIModalPresentationCustom for a custom presentation controller
        // to be used.
        presentedViewController.modalPresentationStyle = .custom

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

    }

    // MARK: - IBAction

    @IBAction func dimmingViewTapped(_ gesture: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }

}

    //: - UIViewControllerTransitioningDelegate

extension CustomPresentationController: UIViewControllerTransitioningDelegate {

    ///  If the modalPresentationStyle of the presented view controller is
    ///  UIModalPresentationCustom, the system calls this method on the presented
    ///  view controller's transitioningDelegate to retrieve the presentation
    ///  controller that will manage the presentation.  If your implementation
    ///  returns nil, an instance of UIPresentationController is used.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        assert(presentedViewController == presented, "You didn't initialize \(self) with the correct presentedViewController.  Expected \(presented), got \(presentedViewController).")
        return self
    }

    ///  If the modalPresentationStyle of the presented view controller is
    ///  UIModalPresentationCustom, the system calls this method on the presented
    ///  view controller's transitioningDelegate to retrieve the presentation
    ///  controller that will manage the presentation.  If your implementation
    ///  returns nil, an instance of UIPresentationController is used.
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    ///  The system calls this method on the presented view controller's
    ///  transitioningDelegate to retrieve the animator object used for animating
    ///  the dismissal of the presented view controller.  Your implementation is
    ///  expected to return an object that conforms to the
    ///  UIViewControllerAnimatedTransitioning protocol, or nil if the default
    ///  dismissal animation should be used.
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

}

    //: - UIViewControllerAnimatedTransitioning

extension CustomPresentationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let isAnimated = transitionContext?.isAnimated else {
            return 0
        }
        return isAnimated ? 0.5 : 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(true)
                return
        }

        let containerView = transitionContext.containerView

        // For a Presentation:
        //      fromView = The presenting view.
        //      toView   = The presented view.
        // For a Dismissal:
        //      fromView = The presented view.
        //      toView   = The presenting view.
        let toView = transitionContext.view(forKey: .to)

        // If NO is returned from -shouldRemovePresentersView, the view associated
        // with UITransitionContextFromViewKey is nil during presentation.  This
        // intended to be a hint that your animator should NOT be manipulating the
        // presenting view controller's view.  For a dismissal, the -presentedView
        // is returned.
        //
        // Why not allow the animator manipulate the presenting view controller's
        // view at all times?  First of all, if the presenting view controller's
        // view is going to stay visible after the animation finishes during the
        // whole presentation life cycle there is no need to animate it at all — it
        // just stays where it is.  Second, if the ownership for that view
        // controller is transferred to the presentation controller, the
        // presentation controller will most likely not know how to layout that
        // view controller's view when needed, for example when the orientation
        // changes, but the original owner of the presenting view controller does.
        let fromView = transitionContext.view(forKey: .from)

        let isPresenting = (fromVC == presentingViewController)

        // This will be the current frame of fromViewController.view.
        let fromViewInitialFrame = transitionContext.initialFrame(for: fromVC)
        print(fromViewInitialFrame)
        // For a presentation which removes the presenter's view, this will be
        // CGRectZero.  Otherwise, the current frame of fromViewController.view.
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        // This will be CGRectZero.
        var toViewInitialFrame = transitionContext.initialFrame(for: toVC)
        // For a presentation, this will be the value returned from the
        // presentation controller's -frameOfPresentedViewInContainerView method.
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        // We are responsible for adding the incoming view to the containerView
        // for the presentation (will have no effect on dismissal because the
        // presenting view controller's view was not removed).
        if let toView = toView {
            containerView.addSubview(toView)
        }

        if isPresenting {
            guard let toView = toView else {
                transitionContext.completeTransition(true)
                return
            }
            toViewInitialFrame.origin = CGPoint(x: containerView.bounds.minX, y: containerView.bounds.maxY)
            toViewInitialFrame.size = toViewFinalFrame.size
            toView.frame = toViewInitialFrame
        } else {
            guard let fromView = fromView else {
                transitionContext.completeTransition(true)
                return
            }
            fromViewFinalFrame = fromView.frame.offsetBy(dx: 0.0, dy: fromView.frame.height)
        }

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(
            withDuration: duration,
            animations: {
                if isPresenting {
                    guard let toView = toView else {
                        transitionContext.completeTransition(true)
                        return
                    }
                    toView.frame = toViewFinalFrame
                } else {
                    guard let fromView = fromView else {
                        transitionContext.completeTransition(false)
                        return
                    }
                    fromView.frame = fromViewFinalFrame
                }
        },
            completion: { (finished: Bool) in
                // When we complete, tell the transition context
                // passing along the BOOL that indicates whether the transition
                // finished or not.
                let wasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCancelled)
        })

    }

}
