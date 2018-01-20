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

    }
}
