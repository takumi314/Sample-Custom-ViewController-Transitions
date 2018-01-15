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
