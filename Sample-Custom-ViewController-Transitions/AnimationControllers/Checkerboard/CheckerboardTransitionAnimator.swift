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

        let transitionContainer = UIView(frame: containerView.frame)
        transitionContainer.isOpaque = true
        transitionContainer.backgroundColor = .black
        containerView.addSubview(transitionContainer)

        /// Apply a perpective transform to the sublayers of transitionContainer.
        let dz = CGFloat(1.0 / -900.0)
        AnimationHelper.perspectiveTransform(for: transitionContainer, axes: [.z: dz])

        /// The size and number of slices is a function of the width.
        let sliceSize = round(CGFloat(transitionContainer.frame.width) / CGFloat(10.0))
        let horizontalSlices = Int(ceil(transitionContainer.frame.width / sliceSize))
        let verticalSlices = Int(ceil(transitionContainer.frame.height / sliceSize))

        // transitionSpacing controls the transition duration for each slice.
        // Higher values produce longer animations with multiple slices having
        // their animations 'in flight' simultaneously.
        let transitionSpacing: CGFloat = 160.0
        let tDuration = transitionDuration(using: transitionContext)


        var transitionVector: CGVector
        if isPush {
            let maxX = transitionContainer.bounds.maxX
            let maxY = transitionContainer.bounds.maxY
            let minX = transitionContainer.bounds.minX
            let minY = transitionContainer.bounds.minY
            transitionVector = CGVector(dx: maxX - minX, dy: maxY - minY)
        } else {
            let maxX = transitionContainer.bounds.maxX
            let maxY = transitionContainer.bounds.maxY
            let minX = transitionContainer.bounds.minX
            let minY = transitionContainer.bounds.minY
            transitionVector = CGVector(dx: minX - maxX, dy: minY - maxY)
        }

        let vectorLength = CGFloat(sqrt(transitionVector.dx * transitionVector.dx + transitionVector.dy * transitionVector.dy))
        let unitVector = CGVector(dx: transitionVector.dx / vectorLength,
                                  dy: transitionVector.dy / vectorLength)

        for y in 0 ..< verticalSlices {
            for x in 0 ..< horizontalSlices {
                pasteCheckboards(indices: (x, y),
                                 sliceSize: sliceSize,
                                 containerView: containerView,
                                 fromViewSnapshot: fromViewSnapshot,
                                 toViewSnapshot: toViewSnapshot)
            }
        }

        // Used to track how many slices have animations which are still in flight.
        var sliceAnimationsPending = 0

        for y in 0 ..< verticalSlices {
            for x in 0 ..< horizontalSlices {

                let toCheckboardSquareView = transitionContainer.subviews[y * horizontalSlices * 2 + (x * 2)]
                let fromCheckboardSquareView = transitionContainer.subviews[y * horizontalSlices * 2 + (x * 2 + 1)]

                var sliceOriginVector: CGVector
                if isPush {
                    // Define a vector from the origin of transitionContainer to the
                    // top left corner of the slice.
                    let squareViewX = fromCheckboardSquareView.frame.minX
                    let squareViewY = fromCheckboardSquareView.frame.minY
                    let containerX = transitionContainer.frame.minX
                    let containerY = transitionContainer.frame.minY
                    sliceOriginVector = CGVector(dx: squareViewX - containerX,
                                                 dy: squareViewY - containerY)
                } else {
                    // Define a vector from the bottom right corner of
                    // transitionContainer to the bottom right corner of the slice.
                    let squareViewX = fromCheckboardSquareView.frame.maxX
                    let squareViewY = fromCheckboardSquareView.frame.maxY
                    let containerX = transitionContainer.frame.maxX
                    let containerY = transitionContainer.frame.maxY
                    sliceOriginVector = CGVector(dx: squareViewX - containerX,
                                                 dy: squareViewY - containerY)
                }

                // Project sliceOriginVector onto transitionVector.
                let dot = sliceOriginVector.dx * transitionVector.dx + sliceOriginVector.dy * transitionVector.dy
                let projection = CGVector(dx: unitVector.dx * dot / vectorLength,
                                          dy: unitVector.dy * dot / vectorLength)

                // Compute the length of the projection.
                let projectionLength = CGFloat(sqrt(projection.dx * projection.dx + projection.dy * projection.dy))

                let startTime = TimeInterval(projectionLength / (projectionLength + transitionSpacing)) * tDuration
                let duration = TimeInterval((projectionLength + vectorLength) / (vectorLength + transitionSpacing)) * tDuration - startTime

                sliceAnimationsPending += 1

                UIView.animate(
                    withDuration: duration,
                    delay: startTime,
                    options: [.curveEaseInOut],
                    animations: {
                        fromCheckboardSquareView.layer.transform = AnimationHelper.yRotate( .pi)
                        toCheckboardSquareView.layer.transform = AnimationHelper.identity
                },
                    completion: { (isFinished: Bool) in
                        // Finish the transition once the final animation completes.
                        sliceAnimationsPending -= 1
                        if sliceAnimationsPending == 0 {
                            let wasCancelled = transitionContext.transitionWasCancelled

                            transitionContainer.removeFromSuperview()

                            // When we complete, tell the transition context
                            // passing along the BOOL that indicates whether the transition
                            // finished or not.
                            transitionContext.completeTransition(!wasCancelled)
                        }
                })
            }
        }

    }


    // MARK: - Private methods

    private func pasteCheckboards(indices latice: (column: Int, row: Int), sliceSize: CGFloat, containerView: UIView, fromViewSnapshot: UIImage, toViewSnapshot: UIImage) -> Void {
        let x = CGFloat(latice.column)
        let y = CGFloat(latice.row)

        let fromContentLayer = CALayer()
        fromContentLayer.frame = CGRect(x: x*sliceSize*(-1.0),
                                        y: y*sliceSize*(-1.0),
                                        width: containerView.bounds.size.width,
                                        height: containerView.bounds.size.height)
        fromContentLayer.rasterizationScale = fromViewSnapshot.scale
        fromContentLayer.contents = fromViewSnapshot.cgImage

        let toContentLayer = CALayer()
        toContentLayer.frame = CGRect(x: x*sliceSize*(-1.0),
                                      y: y*sliceSize*(-1.0),
                                      width: containerView.bounds.size.width,
                                      height: containerView.bounds.size.height)
        // Snapshotting the toView was deferred so we must also defer applying
        // the snapshot to the layer's contents.
        DispatchQueue.main.async {
            // Disable actions so the contents are applied without animation.
            let wereActionDisabled = CATransaction.disableActions()
            CATransaction.setDisableActions(true)

            toContentLayer.rasterizationScale = toViewSnapshot.scale
            toContentLayer.contents = toViewSnapshot.cgImage

            CATransaction.setDisableActions(wereActionDisabled)
        }


        let toCheckboardSquareView = UIView()
        toCheckboardSquareView.frame = CGRect(x: x*sliceSize, y: y*sliceSize, width: sliceSize, height: sliceSize)
        toCheckboardSquareView.isOpaque = true
        toCheckboardSquareView.layer.masksToBounds = true
        toCheckboardSquareView.layer.isDoubleSided = false
        toCheckboardSquareView.layer.transform = AnimationHelper.yRotate( .pi)
        toCheckboardSquareView.layer.addSublayer(toContentLayer)

        let fromCheckboardSquareView = UIView()
        fromCheckboardSquareView.frame = CGRect(x: x*sliceSize, y: y*sliceSize, width: sliceSize, height: sliceSize)
        fromCheckboardSquareView.isOpaque = false
        fromCheckboardSquareView.layer.masksToBounds = true
        fromCheckboardSquareView.layer.isDoubleSided = false
        fromCheckboardSquareView.layer.transform = AnimationHelper.identity
        fromCheckboardSquareView.layer.addSublayer(fromContentLayer)

        containerView.addSubview(toCheckboardSquareView)
        containerView.addSubview(fromCheckboardSquareView)
    }

}
