//
//  ViewController.swift
//  Test
//
//  Created by Apple on 30/07/2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var rateTblView: UITableView!
    
    var currency = ""
    var symbol = ""
    var rate = 0.0
    
    var ratesList: [HistoricalRateModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblCurrency.text = "\(currency) • \(symbol)"
        lblRate.text = "\(rate)"
        
        getHistoricalRates()
    }
    
    func getHistoricalRates()
    {
        ratesList = []
        APIManager.sharedInstance.fetchHistoricalRatesList(startDate: "2020-01-01", endDate: "2020-01-04",baseCurrency: currency, symbol: symbol, completion: {(responseArray: [String: Any]?) in
            
            print(responseArray)
            let rateDict:[String:Any] = responseArray!["rates"] as! [String : Any]
            
            for (key, value) in rateDict
            {
                let rateModel = HistoricalRateModel(date: key, value: value as? [String : Double])
                self.ratesList.append(rateModel)
            }
            print(self.ratesList)
            self.ratesList = self.ratesList.sorted { $0.date! < $1.date! }
            
            DispatchQueue.main.async {
                self.rateTblView.reloadData()
            }
        })
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ratesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricalRateCell") as? HistoricalRateCell {
            
            let rateModel = ratesList[indexPath.row]
            
            cell.lblDate.text = rateModel.date
            cell.lblRate.text = "123"
            
            return cell
        }
        return UITableViewCell()
    }
}
