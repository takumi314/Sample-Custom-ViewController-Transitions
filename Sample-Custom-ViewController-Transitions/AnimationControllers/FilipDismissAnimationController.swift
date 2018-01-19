//
//  FilipDismissAnimationController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/17.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class FilipDismissAnimationController: NSObject {

    private let destinationFrame: CGRect

    init(destinationFrame: CGRect) {
        self.destinationFrame = destinationFrame
    }

}

extension FilipDismissAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // 遷移前のスクリーンの見え方を表すスナップショットを作成する（presentと入れ替わる）
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else {
                return
        }

        snapshot.layer.cornerRadius = CardFrontViewController.cardCornerRadius
        snapshot.layer.masksToBounds = true

        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapshot)
        fromVC.view.isHidden = true

        AnimationHelper.perspectiveTransform(for: containerView, axes: [.z: -0.002])

        // snapshotを直接回転せず, toVCのviewを回す
        toVC.view.layer.transform = AnimationHelper.yRotate(-.pi / 2)


        // 遷移時間
        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                    snapshot.frame = self.destinationFrame
                }

                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                    snapshot.layer.transform = AnimationHelper.yRotate(.pi / 2)
                }

                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                    toVC.view.layer.transform = AnimationHelper.yRotate(0.0)
                }
        },
            completion: { _ in
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })

    }
}
