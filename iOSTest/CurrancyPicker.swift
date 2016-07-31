//
//  CurrancyPicker.swift
//  iOSTest
//
//  Created by Erik Bean on 7/30/16.
//  Copyright © 2016 Erik Bean. All rights reserved.
//

import UIKit

class CurrancyPicker: UITableViewController {
    
    let parser = JSONParser.sharedInstance
    let identifiers = ["english", "euro", "british", "canada", "poland"]
    var currentLocale = NSLocale.currentLocale()
    var newLocale = NSLocale.currentLocale()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch(0)
    }
    
    // MARK: - Parser Methods
    
    private func fetch(attempt: Int) {
        if attempt < 4 {
            parser.fetch(nil, completion: { (success) in
                if !success {
                    self.tryAgain(attempt + 1)
                }
            })
        } else {
            let alert = UIAlertController(title: "Error!", message: "Excended maximum number of tries. Please try again later!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                self.performSegueWithIdentifier("unwindUpdate", sender: self)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func tryAgain(attempt: Int) {
        let alert = UIAlertController(title: "Error!", message: "Cannot get current rates!", preferredStyle: .Alert)
        let tryAgain = UIAlertAction(title: "Try Again", style: .Default) { (action) in
            self.fetch(attempt)
        }
        let cancel = UIAlertAction(title: "Stay with \(currancy())", style: .Default) { (action) in
            self.performSegueWithIdentifier("unwindUpdate", sender: self)
        }
        let swit = UIAlertAction(title: "Switch back to US Dollars", style: .Default) { (action) in
            self.newLocale = NSLocale(localeIdentifier: "en_US")
            self.performSegueWithIdentifier("unwindUpdate", sender: self)
        }
        
        alert.addAction(tryAgain)
        alert.addAction(cancel)
        if currentLocale.localeIdentifier != "en_US" {
            alert.addAction(swit)
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func currancy() -> String {
        if currentLocale.localeIdentifier == "en_US" {
            return "US Dollars?"
        } else if currentLocale.localeIdentifier == "en_IT" {
            return "Euros?"
        } else if currentLocale.localeIdentifier == "en_GB" {
            return "British Pounds?"
        } else if currentLocale.localeIdentifier == "en_CA" {
            return "Canadian Dollars?"
        } else if currentLocale.localeIdentifier == "pl_PL" {
            return "Polish Złoty?"
        } else {
            return "your current currancy?"
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identifiers.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            newLocale = NSLocale(localeIdentifier: "en_US")
            self.performSegueWithIdentifier("unwindUpdate", sender: self)
        } else if indexPath.row == 1 {
            newLocale = NSLocale(localeIdentifier: "en_IT")
            self.performSegueWithIdentifier("unwindUpdate", sender: self)
        } else if indexPath.row == 2 {
            newLocale = NSLocale(localeIdentifier: "en_GB")
            self.performSegueWithIdentifier("unwindUpdate", sender: self)
        } else if indexPath.row == 3 {
            newLocale = NSLocale(localeIdentifier: "en_CA")
            self.performSegueWithIdentifier("unwindUpdate", sender: self)
        } else {
            newLocale = NSLocale(localeIdentifier: "pl_PL")
            self.performSegueWithIdentifier("unwindUpdate", sender: self)
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindUpdate" {
            let home = segue.destinationViewController as! ViewController
            home.locale = newLocale
        }
    }

}
