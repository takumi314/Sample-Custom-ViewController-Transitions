//
//  CustomPresentationController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/22.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {

}

extension CustomPresentationController: UIViewControllerTransitioningDelegate {

}

    //: - UIViewControllerAnimatedTransitioning

extension CustomPresentationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    }

}
