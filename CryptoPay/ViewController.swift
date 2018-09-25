//
//  ViewController.swift
//  CryptoPay
//
//  Created by Shaista Iqbal on 7/26/18.
//  Copyright © 2018 Shaista Iqbal. All rights reserved.
//

import UIKit
import SwiftQRCode
class ViewController: UIViewController {

    @IBOutlet weak var payButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        payButton.layer.cornerRadius = 20
    }

    @IBAction func payDidPress(_ sender: Any) {
        performSegue(withIdentifier: "goToScanner", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

