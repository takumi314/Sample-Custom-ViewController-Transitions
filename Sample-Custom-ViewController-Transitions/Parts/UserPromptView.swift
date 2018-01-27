//
//  UserPromptView.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/26.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

let TEXT_FONT_SIZE: CGFloat = 30

final class UserPromptView: UIView {

    enum ArrowPosition {
        case left
        case center
        case right
    }

    private static let suggestedHeight: CGFloat = 35.0
    private static let padding: CGFloat = 15.0
    var arrowPosition: ArrowPosition = .center

    init(text: String, arrowPosition: ArrowPosition = .center) {
        self.arrowPosition = arrowPosition
        let size = UserPromptView.sizeThatWillFit(text: text)
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        super.init(frame: frame)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 0.75))
        label.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = text
        self.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        // Constants
        let width = rect.width
        let height = rect.height
        let centerX = rect.width / 2.0
        let arrowWidth = rect.height / 2.0

        let darkBlue = UIColor(red: 0.325, green: 0.431, blue: 0.992, alpha: 1.000).cgColor
        let lightBlue = UIColor(red: 0.216, green: 0.792, blue: 1.000, alpha: 1.000).cgColor

        let context = UIGraphicsGetCurrentContext()!

        let blueGradient = CGGradient(
            colorsSpace: nil,
            colors: [darkBlue, lightBlue] as CFArray, locations: [0, 1])!

        // Rectangle Drawing
        let rectanglePath = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: width, height: height * 0.75),
            cornerRadius: (height * 0.75) / 2.0
        )
        context.saveGState()
        rectanglePath.addClip()
        context.drawLinearGradient(
            blueGradient,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: width, y: 0),
            options: []
        )
        context.restoreGState()

        // Polygon Drawing
        let polygonPath = UIBezierPath()

        var xPos: CGFloat
        switch self.arrowPosition {
        case .center:
            xPos = centerX
        case .left:
            xPos = height / 2.0 + arrowWidth
        case .right:
            xPos = width - height / 2.0 - arrowWidth
        }

        polygonPath.move(to: CGPoint(x: xPos, y: height))
        polygonPath.addLine(to: CGPoint(x: xPos + arrowWidth / 2.0, y: height * 0.75))
        polygonPath.addLine(to: CGPoint(x: xPos - arrowWidth / 2.0, y: height * 0.75))
        polygonPath.close()
        context.saveGState()
        polygonPath.addClip()
        context.drawLinearGradient(
            blueGradient,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: width, y: 0),
            options: []
        )
        context.restoreGState()
    }

    class func sizeThatWillFit(text: String, weight: UIFont.Weight = .medium) -> CGSize {
        return sizeThatFits { (label: UILabel) -> CGSize in
            label.font = UIFont.systemFont(ofSize: 40.0, weight: weight)
            label.text = text
            return label.sizeThatFits(UILayoutFittingCompressedSize)
        }
    }

    class func sizeThatFits(within labelHandler: @escaping (UILabel) -> CGSize) -> CGSize {
        let size = labelHandler(UILabel())
        return CGSize(
            width: size.width + UserPromptView.padding * 2.0,
            height: UserPromptView.suggestedHeight
        )
    }

}
