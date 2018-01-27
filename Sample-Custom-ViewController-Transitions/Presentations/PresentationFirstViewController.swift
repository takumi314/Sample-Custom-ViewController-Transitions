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

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - IBActions

    @IBAction func onPushed(_ sender: UIButton) {
        guard let secondVC = storyboard?.instantiateViewController(withIdentifier: PresentationSecondViewController.identifier) else {
            return
        }
        let presentaion = CustomPresentationController(presentedViewController: secondVC, presenting: self)

        secondVC.transitioningDelegate = presentaion

        present(secondVC, animated: true, completion: nil)
    }
    
}
