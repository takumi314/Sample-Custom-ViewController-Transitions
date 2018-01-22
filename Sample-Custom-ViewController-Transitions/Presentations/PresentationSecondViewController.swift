//
//  PresentationSecondViewController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/22.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class PresentationSecondViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var slider: UISlider!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updatePreferredContentSize(with: traitCollection)
        
        /// NOTE: View controllers presented with custom presentation controllers
        ///       do not assume control of the status bar appearance by default
        ///       (their -preferredStatusBarStyle and -prefersStatusBarHidden
        ///       methods are not called).  You can override this behavior by
        ///       setting the value of the presented view controller's
        ///       modalPresentationCapturesStatusBarAppearance property to true.
        /* self.modalPresentationCapturesStatusBarAppearance = true; */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: - Private method

    func updatePreferredContentSize(with traitCollection: UITraitCollection) {
        let verticalSize: CGFloat = traitCollection.verticalSizeClass == .compact ? 270 : 420
        preferredContentSize = CGSize(width: self.view.bounds.size.width, height: verticalSize)

        // MEMO: set up Slider Initial Values in the following
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - IBActions

    @IBAction func sliderDidChangeValue(_ sender: UISlider) {
    }

}
