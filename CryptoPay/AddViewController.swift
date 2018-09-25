//
//  AddViewController.swift
//  CryptoPay
//
//  Created by Shaista Iqbal on 8/2/18.
//  Copyright © 2018 Shaista Iqbal. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
class AddViewController: UIViewController{
    
    @IBOutlet weak var usdAmountText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        let usd: String = usdAmountText.text!
        let parameters: [String: Any] = [
            "amount" : "1"
        ]
        addTransaction(url: "https://yourdomain.com/index.php?amount=\(usd)&add_transaction=1", parameters: parameters)
    }
    
    func addTransaction(url: String, parameters: [String: Any]) {
        let scanningStr = NSLocalizedString("Buying CPAY tokens", comment: "")
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
