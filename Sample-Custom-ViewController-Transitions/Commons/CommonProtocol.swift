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
    var className: String {
        return self.description
    }

}

protocol Identifable: NSObjectProtocol {
    var identifier: String { get }
}

extension Identifable where Self: UIViewController {
    var identifier: String {
        get {
            return self.className
        }
    }
}

extension UIViewController: Identifable {

}
