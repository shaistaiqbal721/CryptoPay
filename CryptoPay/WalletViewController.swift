//
//  WalletViewController.swift
//  CryptoPay
//
//  Created by Shaista Iqbal on 8/1/18.
//  Copyright © 2018 Shaista Iqbal. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class WalletViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var usdBalance: UILabel!
    @IBOutlet weak var cpayBalance: UILabel!
    
    var transactionsArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchBalance(url: "https://yourdomain.com/index.php?balance=1")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func fetchBalance(url: String) {
        print("balance print")
        let scanningStr = NSLocalizedString("Fetching balance", comment: "")
        SVProgressHUD.showInfo(withStatus: scanningStr)
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let resultJSON : JSON = JSON(response.result.value!)
                    print(resultJSON)
                    if resultJSON["success"] == true{
                        
                        var token_balance = resultJSON["data"]["balance"]["token_balance"].floatValue
                        token_balance = round(1000*token_balance)/1000
                        self.cpayBalance.text = "\(token_balance)"
                        let usdBalance = token_balance * 0.01
                        self.usdBalance.text = "\(usdBalance)"
                        self.cpayBalance.sizeToFit()
                        self.usdBalance.sizeToFit()
                        self.fetchLedger(url: "https://yourdomain.com/index.php?ledger=1")
                        
                    }else{
                        print("error")
                        let alertTitle = NSLocalizedString("Error", comment: "")
                        let alertMessage = NSLocalizedString("Please try again!", comment: "")
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
    
    func fetchLedger(url: String) {
        print("ledger print")
        let scanningStr = NSLocalizedString("Fetching recent transactions", comment: "")
        SVProgressHUD.showInfo(withStatus: scanningStr)
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let resultJSON : JSON = JSON(response.result.value!)
                    //print(resultJSON)
                    if resultJSON["success"] == true{
                        SVProgressHUD.dismiss()
                        if let _ = resultJSON["data"]["transactions"].array{
                            let transactionsList = resultJSON["data"]["transactions"].arrayValue
                            for transaction in transactionsList{
                                
                                if(transaction["amount"] != JSON.null){
                                    print(transaction["amount"])
                                    self.transactionsArray.append("CPAY \(transaction["amount"].string!)")
                                }
                            }
                            
                            self.tableView.reloadData()
                        }else{
                            print ("Data not returned")
                            //someErrorHappened()
                        }
                    }else{
                        print("error")
                        let alertTitle = NSLocalizedString("Error", comment: "")
                        let alertMessage = NSLocalizedString("Please try again!", comment: "")
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
    
    //MARK:- TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath)
        cell.textLabel?.text = transactionsArray[indexPath.item]
        cell.detailTextLabel?.text = NSLocalizedString("Complete", comment: "")
        cell.backgroundColor = UIColor(red:1.00, green:0.92, blue:0.65, alpha:1.0)
        return cell
    }
}
