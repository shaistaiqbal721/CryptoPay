//
//  FinalPayViewController.swift
//  CryptoPay
//
//  Created by Shaista Iqbal on 7/26/18.
//  Copyright © 2018 Shaista Iqbal. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class FinalPayViewController: UIViewController{
    
    @IBOutlet weak var priceTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func payButtonPressed(_ sender: Any) {
        let price: String = priceTextField.text!
        let parameters: [String: Any] = [
            "amount" : "1"
            ]
        payTransaction(url: "https://yourdomain.com/index.php?amount=1&transaction=1", parameters: parameters)
    }
    func payTransaction(url: String, parameters: [String: Any]) {
        let scanningStr = NSLocalizedString("Paying the retailer", comment: "")
        SVProgressHUD.showInfo(withStatus: scanningStr)
        Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {
                    let resultJSON : JSON = JSON(response.result.value!)
                    print(resultJSON)
                        if resultJSON["success"] == true{
                            SVProgressHUD.dismiss()
                            let alertTitle = NSLocalizedString("Success", comment: "")
                            let alertMessage = NSLocalizedString("Transaction complete!", comment: "")
                            let okButtonText = NSLocalizedString("OK", comment: "")
                            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: okButtonText, style: .cancel, handler: { _ in
                                self.tabBarController?.selectedIndex = 2
                            }))
                            self.present(alert, animated: true)
                            
                        }else{
                            SVProgressHUD.dismiss()
                            print("error")
                            let alertTitle = NSLocalizedString("Error", comment: "")
                            let alertMessage = NSLocalizedString("Please try the payment again!", comment: "")
                            let okButtonText = NSLocalizedString("OK", comment: "")
                            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: okButtonText, style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        }
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    //self.someErrorHappened()
                }
        }
        
    }
    
}
