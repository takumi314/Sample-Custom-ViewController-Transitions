//
//  RevealViewController.swift
//  Sample-Custom-ViewController-Transitions
//
//  Created by NishiokaKohei on 2018/01/17.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController {

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
    
    @IBAction func onNext(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CustomPresentation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: PresentationFirstViewController.identifier)
        present(vc, animated: true, completion: nil)
    }

    @IBAction func onBack(_ sender: UIButton) {
        dismiss(completion: nil)
    }
}

extension RevealViewController {

    // MARK: - Private methods

    private func dismiss(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }

}
