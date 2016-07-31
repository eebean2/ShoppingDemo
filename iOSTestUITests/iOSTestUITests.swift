//
//  iOSTestUITests.swift
//  iOSTestUITests
//
//  Created by Erik Bean on 7/28/16.
//  Copyright © 2016 Erik Bean. All rights reserved.
//

import XCTest

class iOSTestUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        let element = app.otherElements.containingType(.NavigationBar, identifier:"Ze Market").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.childrenMatchingType(.Button).matchingIdentifier("Add To Cart").elementBoundByIndex(0).tap()
        element.childrenMatchingType(.Button).matchingIdentifier("Add To Cart").elementBoundByIndex(1).tap()
        element.childrenMatchingType(.Button).matchingIdentifier("Add To Cart").elementBoundByIndex(2).tap()
        element.childrenMatchingType(.Button).matchingIdentifier("Add To Cart").elementBoundByIndex(3).tap()
        
        let zeMarketNavigationBar = app.navigationBars["Ze Market"]
        zeMarketNavigationBar.buttons["Options"].tap()
        app.tables.staticTexts["Euro"].tap()
        zeMarketNavigationBar.buttons["Cart"].tap()
        
        let total508NavigationBar = app.navigationBars["Total : €5,08"]
        total508NavigationBar.buttons["Check Out"].tap()
        
        let iDidThankYouButton = app.alerts["Thank you!"].collectionViews.buttons["I did, thank you!"]
        iDidThankYouButton.tap()
        iDidThankYouButton.pressForDuration(0.5);
        total508NavigationBar.buttons["Done"].tap()
    }
    
}
