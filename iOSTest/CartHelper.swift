//
//  CartHelper.swift
//  iOSTest
//
//  Created by Erik Bean on 7/30/16.
//  Copyright © 2016 Erik Bean. All rights reserved.
//

import UIKit

class Cart {
    var cart = [Item]()
    
    static let sharedInstance = Cart()
    
    init() { }
    
    func addItemToCart(item: Item) {
        cart.append(item)
    }
    
    func removeItemFromCart(item: Item) {
        cart.removeAtIndex(cart.indexOf(item)!)
    }
    
    func canOpenCart() -> Bool {
        if cart.isEmpty {
            return false
        } else {
            return true
        }
    }
}

class Item: Hashable, Equatable {
    var hashValue: Int {
        return name.hashValue
    }
    var image = UIImage()
    var name = String()
    var price = Double()
    
    init(name: String, price: Double, image: UIImage) {
        self.name = name
        self.price = price
        self.image = image
    }
}

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.name == rhs.name
}