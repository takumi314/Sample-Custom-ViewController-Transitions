//
//  CustomPresentationController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/22.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {

    // MARK: - Initializer

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        // The presented view controller must have a modalPresentationStyle
        // of UIModalPresentationCustom for a custom presentation controller
        // to be used.
        presentedViewController.modalPresentationStyle = .custom
    }

}

    //: - UIViewControllerTransitioningDelegate

extension CustomPresentationController: UIViewControllerTransitioningDelegate {

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

    }

}
