//
//  CardFrontViewController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/17.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class CardFrontViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onFlipped(_ sender: UIButton) {
        present()
    }
}

extension CardFrontViewController {

    // MARK: - Private methods

    private func present() {
        guard let destination = storyboard?.instantiateViewController(withIdentifier: RevealViewController.identifier) else {
            return
        }
        destination.transitioningDelegate = self
        present(destination, animated: true, completion: nil)
    }

}

extension CardFrontViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlipPresentAnimationController(originalFrame: view.frame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let _ = dismissed as? RevealViewController else {
            return nil
        }
        return FilipDismissAnimationController(destinationFrame: view.frame)
    }

}
