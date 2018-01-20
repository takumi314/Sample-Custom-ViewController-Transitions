//
//  CheckerboardTransitionAnimator.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/20.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class CheckerboardTransitionAnimator: NSObject {

}

extension CheckerboardTransitionAnimator: UIViewControllerAnimatedTransitioning {

    static let transionTime = 2.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return CheckerboardTransitionAnimator.transionTime
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView

        /// In iOS 8, the viewForKey: method was introduced to get views that the
        /// animator manipulates.  This method should be preferred over accessing
        /// the view of the fromViewController/toViewController directly.
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
            return
        }

        /// If a push is being animated, the incoming view controller will have a
        /// higher index on the navigation stack than the current top view
        /// controller.
        guard let toNC = toVC.navigationController,
            let toIndex = toNC.viewControllers.index(of: toVC),
            let fromNC = fromVC.navigationController,
            let fromIndex = fromNC.viewControllers.index(of: fromVC) else {
                return
        }
        let isPush = toIndex > fromIndex

        /// Our animation will be operating o.n snapshots of the fromView and toView,
        /// so the final frame of toView can be configured now.
        fromView.frame = transitionContext.initialFrame(for: fromVC)
        toView.frame = transitionContext.finalFrame(for: toVC)

        /// We are responsible for adding the incoming view to the containerView
        /// for the transition.
        containerView.addSubview(toView)

        /** ---------------------- */

        var fromViewSnapshot: UIImage
        var toViewSnapshot = UIImage()

        guard let window = containerView.window else {
            return
        }

        /// Snapshot the fromView.
        UIGraphicsBeginImageContextWithOptions(containerView.frame.size, true, window.screen.scale)
        fromView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: false)
        fromViewSnapshot = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()

        /// To avoid a blank snapshot, defer snapshotting the incoming view until it
        /// has had a chance to perform layout and drawing (1 run-loop cycle).
        DispatchQueue.main.async {
            UIGraphicsBeginImageContextWithOptions(containerView.frame.size, true, window.screen.scale)
            toView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: false)
            toViewSnapshot = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
        }


    }
}
