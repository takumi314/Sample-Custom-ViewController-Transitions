//
//  CommonProtocol.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/17.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import Foundation
import UIKit

extension NSObjectProtocol {
    static var className: String {
        return "\(self)"
    }

}

protocol Identifable: NSObjectProtocol {
    static var identifier: String { get }
}

extension Identifable where Self: UIViewController {
    static var identifier: String {
        get {
            return self.className
        }
    }
}

extension UIViewController: Identifable {

}
