//
//  FlipPresentAnimationController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/15.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject {

    // To store an information about starting point for the animation
    // タップした際のカードサイズを保持する
    private let originalFrame: CGRect

    init(originalFrame: CGRect) {
        self.originalFrame = originalFrame
    }

}

extension FlipPresentAnimationController: UIViewControllerAnimatedTransitioning {

    // 1. 画面遷移にかかる時間
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let duration = 2.0
        return TimeInterval(duration)
    }

    // 2. Animatorオブジェクトに対し, 遷移アニメーション処理を実行する
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // 置き換え後のViewControllerと表示済みのViewControllerへの参照を抽出する
        // 遷移後のスクリーンの見え方を表すスナップショットを作成する
        guard let toVC =  transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else {
                return
        }

        // ビュー階層とアニメーションの管理を簡略化するため, コンテナ・ビュー内に全体的な遷移を内包しています。
        // そんため, コンテナ・ビューへの参照を取得し, 新たなビューとなる最終フレームを判別します。
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        // スナップショットのフレームと "from"ビューのカードを一致させて, 正確に覆えるように設定を施します
        snapshot.frame = finalFrame
        snapshot.layer.cornerRadius = fromVC.view.layer.cornerRadius
        snapshot.layer.masksToBounds = true

        // 新たな "to"View をビュー階層に追加して非表示にする。その前面にはスナップショットが配置される。
        // ViewController.viewが見えず, snapshotのみが表示された状態になる
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true

        // アニメーション時間を取得する
        let duration = transitionDuration(using: transitionContext)


        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
        },
            completion: { _ in
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity

                // To informs UIKit that the animation is complete
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

}

