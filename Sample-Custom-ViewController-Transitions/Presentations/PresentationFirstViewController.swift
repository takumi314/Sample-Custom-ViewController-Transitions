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

        Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: false,
            block: { [unowned self] _ in
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.promptView?.alpha = 1.0
                })
        })
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
    
}
