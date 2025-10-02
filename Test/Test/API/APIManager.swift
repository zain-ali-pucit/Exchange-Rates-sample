//
//  APIManager.swift
//  Test
//
//  Created by Apple on 30/07/2021.
//

import Foundation
import Alamofire

public class APIManager
{
    struct Singleton {
        static let sharedInstance = APIManager()
    }
    
    class var sharedInstance: APIManager {
        return Singleton.sharedInstance
    }

    func fetchRatesList(baseCurrency: String, completion: @escaping ([String:Any]) -> Void)
    {
        let url = URL(string: API_LATEST + "?base=\(baseCurrency)")

        AF.request(url!).responseJSON {(response) in
            if let data = response.data{
                
                let responseString = String(data: data, encoding: .utf8)
                let jsonResult:[String:Any] = self.convertToDictionary(text: responseString!)!
                completion(jsonResult)
            }
        }
    }
    
    func fetchHistoricalRatesList(startDate: String, endDate: String,baseCurrency: String, symbol: String, completion: @escaping ([String:Any]) -> Void)
    {
//        timeseries?start_date=2020-01-01&end_date=2020-01-04&base=USD&symbols=AED
        let url = URL(string: API_HISTORICAL + "?start_date=\(startDate)&end_date=\(endDate)&base=\(baseCurrency)&symbols=\(symbol)")
        print(url)
        AF.request(url!).responseJSON {(response) in
            if let data = response.data{
                
                let responseString = String(data: data, encoding: .utf8)
                let jsonResult:[String:Any] = self.convertToDictionary(text: responseString!)!
                
                completion(jsonResult)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
