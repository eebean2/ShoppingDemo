//
//  JSONParser.swift
//  iOSTest
//
//  Created by Erik Bean on 7/28/16.
//  Copyright © 2016 Erik Bean. All rights reserved.
//

import Foundation

class JSONParser {
    var timeStamp = Int()
    var eur: (rate: Float, sign: String) = (1, "EUR")
    var gbp: (rate: Float, sign: String) = (1, "EBP")
    var cad: (rate: Float, sign: String) = (1, "CAD")
    var pln: (rate: Float, sign: String) = (1, "PLN")
    
    let apiKey = "9ec527e87b254a68a5cdfee4fd23cbe6"
    var updateReady = false
    
    static let sharedInstance = JSONParser()
    
    private init() { }
    
    func fetch(locale: NSLocale?, completion: (success: Bool) -> Void) {
        var currancies = currancy(for: locale)
        if currancies == nil {
            currancies = "EUR,GBP,CAD,PLN"
        }
        let url = "http://apilayer.net/api/live?access_key=" + apiKey + "&currencies=" + currancies! + "&source=USD&format=1"
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            if error != nil {
                print(error)
                completion(success: false)
            } else {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    self.timeStamp = json["timestamp"] as! Int
                    if json["success"] as! Bool {
                        self.updateReady = true
                        if let rates = json["quotes"] as? [String: Float] {
                            for rate in rates {
                                self.setRate(rate.1, for: rate.0)
                            }
                        }
                    } else {
                        print("Error retriving rates!")
                        completion(success: false)
                    }
                } catch {
                    print("Error serializing JSON: \(error)")
                    completion(success: false)
                }
            }
        }
        task.resume()
        completion(success: true)
    }
    
    private func currancy(for locale: NSLocale?) -> String? {
        if locale != nil {
            if locale!.localeIdentifier == "en_US" {
                return nil
            } else if locale!.localeIdentifier == "en_IT" {
                return eur.sign
            } else if locale!.localeIdentifier == "en_GB" {
                return gbp.sign
            } else if locale!.localeIdentifier == "en_CA" {
                return cad.sign
            } else if locale!.localeIdentifier == "pl_PL" {
                return pln.sign
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func setRate(rate: Float, for name: String) {
        if name == "USDEUR" {
            eur.rate = rate
        } else if name == "USDGBP" {
            gbp.rate = rate
        } else if name == "USDCAD" {
            cad.rate = rate
        } else if name == "USDPLN" {
            pln.rate = rate
        } else {
            print("Currancy unknown!")
        }
    }
    
    func getPrice(for locale: NSLocale, amount: Double) -> Double {
        var rate = Float()
        var total = Float()
        if locale.localeIdentifier == "en_US" {
            rate = 0
        } else if locale.localeIdentifier == "en_IT" {
            rate = eur.rate
        } else if locale.localeIdentifier == "en_GB" {
            rate = gbp.rate
        } else if locale.localeIdentifier == "en_CA" {
            rate = cad.rate
        } else if locale.localeIdentifier == "pl_PL" {
            rate = pln.rate
        } else {
            rate = 0
            print("Locale Unknown! Rate set to 0.")
        }
        
        if rate != 0 {
            total = Float(amount) * rate
        } else {
            total = Float(amount)
        }
        
        return round(Double(total) * pow(10.0, 2.0)) / pow(10.0, 2.0)
    }
    
    func format(for locale: NSLocale, amount: Double) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = locale
        
        return formatter.stringFromNumber(amount)!
    }
    
    func getTotal(for locale: NSLocale, amount: Double) -> String {
        var rate = Float()
        var total = Float()
        if locale.localeIdentifier == "en_US" {
            rate = 0
        } else if locale.localeIdentifier == "en_IT" {
            rate = eur.rate
        } else if locale.localeIdentifier == "en_GB" {
            rate = gbp.rate
        } else if locale.localeIdentifier == "en_CA" {
            rate = cad.rate
        } else if locale.localeIdentifier == "pl_PL" {
            rate = pln.rate
        } else {
            rate = 0
            print("Locale Unknown! Rate set to 0.")
        }
        
        if rate != 0 {
            total = Float(amount) * rate
        } else {
            total = Float(amount)
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = locale
        
        return formatter.stringFromNumber(total)!
    }
}