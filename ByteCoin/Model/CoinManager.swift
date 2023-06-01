//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//By convention, Swift protocols are usually written in the file that has the class/struct which will call the
//delegate methods, i.e. the CoinManager.

protocol CoinManagerDelegate {
    
    //Create the method stubs wihtout implementation in the protocol.
    //It's usually a good idea to also pass along a reference to the current class.
    //e.g. func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    //Check the Clima module for more info on this.
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    //Create an optional delegate that will have to implement the delegate methods.
    //Which we can notify when we have updated the price.
    var delegate: CoinManagerDelegate?
    
    // base url
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    // apikey
    let apiKey = "B7ED2019-2E3B-44F5-A3B1-A460BCAE9314"
    
    
    // possible currencies in an array
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    //function to get the coin price from an api
    func getCoinPrice(for currency: String) {
        
        // our url based on user selection
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //Use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            
            //Create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print (error!)
                    return
                }
                
                //JSON - STEP 4
                
                if let safeData = data {
                    let bitcoinPrice = self.parseJSON(safeData)
                    
                    //Optional: round the price down to 2 decimal places.
                    let priceString = String(format: "%.2f", bitcoinPrice!)
                    
                    //Call the delegate method in the delegate (ViewController) and
                    //pass along the necessary data.
                    self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                }
                
                //Format the data we got back as a string to be able to print it.
//                let dataAsString = String(data: data!, encoding: String.Encoding.utf8)
//                print(dataAsString)
            }
            //Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
    
    // JSON - STEP 4
    
    func parseJSON(_ data: Data) -> Double? {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch {
            
            //Catch any errors.
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
