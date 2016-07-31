//
//  CartView.swift
//  iOSTest
//
//  Created by Erik Bean on 7/28/16.
//  Copyright © 2016 Erik Bean. All rights reserved.
//

import UIKit

class CartView: UITableViewController {
    
    private var cart = [Item]()
    private var cartView = Cart.sharedInstance
    private var total = Double()
    var locale: NSLocale! = nil
    let parser = JSONParser.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cart = cartView.cart
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("item", forIndexPath: indexPath)
        
        total += cart[indexPath.row].price
        let t = parser.format(for: locale, amount: total)
        self.title = "Total : \(t)"
        
        cell.imageView?.image = cart[indexPath.row].image
        cell.textLabel?.text = cart[indexPath.row].name
        let price = parser.format(for: locale, amount: cart[indexPath.row].price)
        cell.detailTextLabel?.text = price
        
        return cell

    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            cartView.removeItemFromCart(cart[indexPath.row])
            total -= cart[indexPath.row].price
            let t = parser.format(for: locale, amount: total)
            self.title = "Total : \(t)"
            cart = cartView.cart
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if cart.count == 0 {
                let alert = UIAlertController(title: "Oh No!", message: "Your cart is now empty! Press ok to go back to buy more stuff!", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                    self.performSegueWithIdentifier("empty", sender: self)
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func checkOut(sender: AnyObject) {
        let t = parser.format(for: locale, amount: total)
        let alert = UIAlertController(title: "Thank you!", message: "Your total is \(t)", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(action)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
