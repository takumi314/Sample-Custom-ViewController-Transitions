//
//  AnimationHelper.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/15.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

enum Direction {
    case x, y, z
}

class AnimationHelper {

    static func rotate(_ angle: Double, x: Double, y: Double, z: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), CGFloat(x), CGFloat(y), CGFloat(z))
    }

    static func xRotate(_ angle: Double) -> CATransform3D {
        return rotate(angle, x: 1, y: 0, z: 0)
    }

    static func yRotate(_ angle: Double) -> CATransform3D {
        return rotate(angle, x: 0, y: 1, z: 0)
    }

    static func zRotate(_ angle: Double) -> CATransform3D {
        return rotate(angle, x: 0, y: 0, z: 1)
    }

    func perspectiveTransform(for containerView: UIView, axes: [Direction: CGFloat]) -> Void {
        var transform = CATransform3DIdentity
        axes.forEach { axis in
            switch axis.key {
            case .x:
                transform.m14 = axis.value
            case .y:
                transform.m24 = axis.value
            case .z:
                transform.m34 = axis.value
            }
        }
        containerView.layer.sublayerTransform = transform
    }

}
