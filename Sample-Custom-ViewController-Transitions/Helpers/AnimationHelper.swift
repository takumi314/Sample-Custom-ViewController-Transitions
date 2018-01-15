//
//  AnimationHelper.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/15.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

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

}
