//
//  PresentationFirstViewController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/22.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class PresentationFirstViewController: UIViewController {

    @IBOutlet weak var pushButton: UIButton!

    var promptView: UIView? = nil

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let promptView = UserPromptView(text: "Tap here next", arrowPosition: .center)
        promptView.backgroundColor = .clear
        promptView.alpha = 0.0
        promptView.center = CGPoint(
            x: pushButton.center.x,
            y: pushButton.center.y - ( promptView.frame.height + pushButton.frame.height ) / 2.0 + 5.0
        )

        self.view.addSubview(promptView)
        self.promptView = promptView

        fadein(afterTime: 0.1) { [unowned self] in
            self.promptView?.alpha = 1.0
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - IBActions

    @IBAction func onPushed(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.promptView?.alpha = 0.0
                self.promptView?.isHidden = true
        })
        guard let secondVC = storyboard?.instantiateViewController(withIdentifier: PresentationSecondViewController.identifier) else {
            return
        }
        let presentaion = CustomPresentationController(presentedViewController: secondVC, presenting: self)

        secondVC.transitioningDelegate = presentaion

        present(secondVC, animated: true, completion: nil)
    }
    
    // MAKR: - Privete mathod

    func fadein(afterTime delay: TimeInterval, outcomingTo animation: @escaping () -> ()) {
        let duration = 0.1
        let animations = {  (duration: TimeInterval) -> ()  in
            UIView.animate(
                withDuration: duration,
                animations: {
                    animation()
            })
        }

        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(
                withTimeInterval: delay,
                repeats: false,
                block: {_ in
                    animations(duration)
            })
        } else {
            // iOS9 or earlier
            Timer.scheduledTimer(
                timeInterval: delay,
                target: self,
                selector: #selector(didRecieveNotification(_:)),
                userInfo: ["ANIMATION_FADEOUT": animations,
                           "ANIMATION_DURATION": duration],
                repeats: false
            )
        }
    }

    @objc func didRecieveNotification(_ timer: Timer) {
        guard let userInfo = timer.userInfo as? [String: Any],
            let outcome =  userInfo["ANIMATION_FADEOUT"] as? ((TimeInterval) -> ()),
            let duration = userInfo["ANIMATION_DURATION"] as? TimeInterval else {
                return
        }
        outcome(duration)
    }

}
