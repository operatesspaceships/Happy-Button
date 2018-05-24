//
//  ViewController.swift
//  Happy Button
//
//  Created by Pierre Liebenberg on 5/21/18.
//  Copyright © 2018 The Seahorse Company. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: HappyButton!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func buttonTapped(_ sender: Any) {
        print("Tapped.")
    }
    
    @IBAction func resultReceived(_ sender: Any) {
        self.button.perform(action: .showSuccessAnimation) {
            print("Success.")
        }
    }
    
    @IBAction func resetAnimation(_ sender: Any) {
        self.button.perform(action: .showResetAnimation) {
            print("Button reset.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !button.animationShouldLoop {
            self.successButton.alpha = 0
            self.resetButton.alpha = 0
        }
    }

}

