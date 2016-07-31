//
//  ViewController.swift
//  iOSTest
//
//  Created by Erik Bean on 7/28/16.
//  Copyright © 2016 Erik Bean. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let items = ["Peas (per bag)", "Eggs (per dozen)", "Milk (per bottle)", "Beans (per can)"]
    let prices = [0.95, 2.10, 1.30, 0.73]
    var tempPrices = [Double]()
    var locale = NSLocale.currentLocale()
    
    let parser = JSONParser.sharedInstance
    let cart = Cart.sharedInstance

    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var titleOne: UILabel!
    @IBOutlet weak var priceOne: UILabel!
    
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var titleTwo: UILabel!
    @IBOutlet weak var priceTwo: UILabel!
    
    @IBOutlet weak var imgThree: UIImageView!
    @IBOutlet weak var titleThree: UILabel!
    @IBOutlet weak var priceThree: UILabel!
    
    @IBOutlet weak var imgFour: UIImageView!
    @IBOutlet weak var titleFour: UILabel!
    @IBOutlet weak var priceFour: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgOne.image = UIImage(named: "peas.jpg")
        titleOne.text = items[0]
        imgTwo.image = UIImage(named: "eggs.jpg")
        titleTwo.text = items[1]
        imgThree.image = UIImage(named: "milk.jpg")
        titleThree.text = items[2]
        imgFour.image = UIImage(named: "beans.jpg")
        titleFour.text = items[3]
        
        updatePrices(for:locale)
    }
    
    @IBAction func presentCart(sender: UIBarButtonItem) {
        if cart.canOpenCart() {
            self.performSegueWithIdentifier("cart", sender: self)
        } else {
            let alert = UIAlertController(title: "Oh No!", message: "Your cart is empty! Add items to fill it up!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func updatePrices(for locale: NSLocale) {
        priceOne.text = parser.getTotal(for: locale, amount: prices[0])
        priceTwo.text = parser.getTotal(for: locale, amount: prices[1])
        priceThree.text = parser.getTotal(for: locale, amount: prices[2])
        priceFour.text = parser.getTotal(for: locale, amount: prices[3])
        tempPrices.removeAll()
        tempPrices.append(parser.getPrice(for: locale, amount: prices[0]))
        tempPrices.append(parser.getPrice(for: locale, amount: prices[1]))
        tempPrices.append(parser.getPrice(for: locale, amount: prices[2]))
        tempPrices.append(parser.getPrice(for: locale, amount: prices[3]))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cart" {
            let nav = segue.destinationViewController as! UINavigationController
            let nvc = nav.topViewController as! CartView
            nvc.locale = self.locale
        }
    }

    @IBAction func addOneToCart(sender: AnyObject) {
        let item = Item(name: titleOne.text!, price: tempPrices[0], image: UIImage(named: "peas.jpg")!)
        cart.addItemToCart(item)
    }
    
    @IBAction func addTwoToCart(sender: AnyObject) {
        let item = Item(name: titleTwo.text!, price: tempPrices[1], image: UIImage(named: "eggs.jpg")!)
        cart.addItemToCart(item)
    }
    
    @IBAction func addThreeToCart(sender: AnyObject) {
        let item = Item(name: titleThree.text!, price: tempPrices[2], image: UIImage(named: "milk.jpg")!)
        cart.addItemToCart(item)
    }
    
    @IBAction func addFourToCart(sender: AnyObject) {
        let item = Item(name: titleFour.text!, price: tempPrices[3], image: UIImage(named: "beans.jpg")!)
        cart.addItemToCart(item)
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindUpdate" {
            updatePrices(for: locale)
        }
    }
    
}

