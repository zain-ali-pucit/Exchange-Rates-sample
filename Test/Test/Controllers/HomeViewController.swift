//
//  ViewController.swift
//  Test
//
//  Created by Apple on 30/07/2021.
//

import UIKit

struct RateModel
{
    var currency: String?
    var rate: Double?
}

struct HistoricalRateModel
{
    var date: String?
    var value: [String: Double]?
}

class HomeViewController: UIViewController
{
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var currencyTblView: UITableView!
    @IBOutlet weak var rateTblView: UITableView!
    @IBOutlet weak var baseCurrencyBtn: UIButton!
    
    var currencyMasterList: [String] = []
    var currencyFilteredList: [String] = []
    var ratesList: [RateModel] = []
    var favList: [RateModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyView.layer.cornerRadius = 10.0
        currencyView.layer.masksToBounds = true
        
        getAllCurrencies()
        
        getRates(baseCurrency: "USD")
        
    }
    
    //MARK:- Custom Functions
    
    func getAllCurrencies()
    {
        for code in NSLocale.isoCurrencyCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            currencyMasterList.append(name)
        }
        currencyFilteredList = currencyMasterList
        currencyTblView.reloadData()
    }
    
    func getRates(baseCurrency : String)
    {
        ratesList = []
        APIManager.sharedInstance.fetchRatesList(baseCurrency: baseCurrency, completion: {(responseArray: [String: Any]?) in
            
            let rateDict:[String:Any] = responseArray!["rates"] as! [String : Any]
            
            for (key, value) in rateDict
            {
                let rateModel = RateModel(currency: key, rate: value as? Double)
                self.ratesList.append(rateModel)
            }
            self.ratesList = self.ratesList.sorted { $0.currency! < $1.currency! }
            
            DispatchQueue.main.async {
                self.rateTblView.reloadData()
            }
        })
    }
    
    //MARK:- Actions
    
    @IBAction func currencyBtnAction(_ sender: Any)
    {
        currencyView.alpha = 1
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView.tag == 1001
        {
            return 1
        }
        else
        {
            if favList.count > 0
            {
                return 2
            }
            else
            {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1001
        {
            return currencyFilteredList.count
        }
        else
        {
            if favList.count > 0 && section == 0
            {
                return favList.count
            }
            else
            {
                return ratesList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell") as? RateCell {
            
            
            if tableView.tag == 1001
            {
                cell.lblCurrency.text = currencyFilteredList[indexPath.row]
            }
            else
            {
                let rateModel = ratesList[indexPath.row]
                
                cell.lblCurrency.text = rateModel.currency
                cell.lblRate.text = " • \(rateModel.rate ?? 0.0)"
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1001
        {
            self.view.endEditing(true)
            currencyView.alpha = 0
            let currency = currencyFilteredList[indexPath.row]
            self.baseCurrencyBtn.setTitle(currency, for: .normal)
            getRates(baseCurrency: currency)
        }
        else
        {
            let rateModel = ratesList[indexPath.row]
            
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.currency = self.baseCurrencyBtn.titleLabel?.text ?? ""
            detailVC.symbol = rateModel.currency ?? ""
            detailVC.rate = rateModel.rate ?? 0.0
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension HomeViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        currencyFilteredList = searchText.isEmpty ? currencyMasterList : currencyMasterList.filter { (currency: String) -> Bool in
            return currency.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        currencyTblView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
