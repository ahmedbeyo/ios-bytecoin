//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

// datasouce : This says that the ViewController class is capable of providing data to any UIPickerViews.

// delegate : let’s update the PickerView with some titles and detect when it is interacted with. To do this we have set up the PickerView’s delegate methods

// in other words, delegate are the protocol functions built in like numberOfRows or titleForRow

class ViewController: UIViewController {
   
    //connect struct in model here
    // changed from let to var to use delegate variable in model
    var coinManager = CoinManager()
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Easily Missed: Must set the coinManager's delegate as this current class so that we can recieve
        //the notifications when the delegate methods are called.
        coinManager.delegate = self
        
        // to activate the datasouce and delegate protocols we have to add them here like that
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

extension ViewController: CoinManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    //Provide the implementation for the delegate methods.
    //When the coinManager gets the price it will call this method and pass over the price and currency.
    func didUpdatePrice(price: String, currency: String) {
        
        //Remember that we need to get hold of the main thread to update the UI, otherwise our app will crash if we
        //try to do this from a background thread (URLSession works in the background).
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //  number of columns of UIpickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //  number of rows. we connected the array count from the struct so that we do not count it ourselves. we are programmers!
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    // delegate: title of the row. we connected it to the array's rows in the struct. it will automatically get the title of the intended row number
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //delegate: when a row is selected. we connected it to a func in the struct in model. Update the pickerView(didSelectRow:) method to pass the selected currency to the CoinManager via the getCoinPrice() method.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

