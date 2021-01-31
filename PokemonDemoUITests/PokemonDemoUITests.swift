//
//  PokemonDemoUITests.swift
//  PokemonDemoUITests
//
//  Created by itsector on 28/01/2021.
//

import XCTest

class PokemonDemoUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testPokemonDetailCloseButton() {
        let app = XCUIApplication()
        sleep(20)
        let cell = app.collectionViews.children(matching: .cell).element(boundBy: 0).otherElements["cellMainView"]
        cell.tap()
        
        let closeButton = app.otherElements["detailContentView"].buttons["detailCloseButton"]
        closeButton.tap()
                
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
        XCTAssertTrue(topController is PokemonListViewController)
        }
    }
    
    func testPokemonSearch() {
        
        let app = XCUIApplication()
        let introduzaONomeDoPokMonSearchField = app.searchFields.element(boundBy: 0)
        sleep(10)
        introduzaONomeDoPokMonSearchField.tap()
        
        let pKey = app.keys["p"]
        pKey.tap()
        
        let iKey = app.keys["i"]
        iKey.tap()
        
        let kKey = app.keys["k"]
        kKey.tap()
        
        let aKey = app.keys["a"]
        aKey.tap()
        
        let cKey = app.keys["c"]
        cKey.tap()
        
        let hKey = app.keys["h"]
        hKey.tap()
        
        let uKey = app.keys["u"]
        uKey.tap()
        
        let searchButton = app.buttons["Search"]
        searchButton.tap()
        app.otherElements["detailContentView"].buttons["detailCloseButton"].tap()
        introduzaONomeDoPokMonSearchField.tap()
        
        let deleteKey = app.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        searchButton.tap()
        app.alerts["Alerta"].scrollViews.otherElements.buttons["Ok"].tap()
        
    }
    
    func testDetailPokemonNameStyle() {
        let label = UILabel()
        label.font = .detailPokemonNameStyle()
        
        XCTAssertEqual(label.font, UIFont.systemFont(ofSize: 28.0, weight: .heavy), "Font should be of size: 28 and weight: heavy")
    }
}
