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

        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        app.scrollViews.otherElements.buttons["detailCloseButton"].tap()
        
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
        XCTAssertTrue(topController is PokemonListViewController)
        }
    }
    
    func testPokemonListPush() {
        XCUIApplication().collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
        XCTAssertTrue(topController is PokemonDetailViewController)
        }
    }
    
    func testDetailPokemonNameStyle() {
        let label = UILabel()
        label.font = .detailPokemonNameStyle()
        
        XCTAssertEqual(label.font, UIFont.systemFont(ofSize: 28.0, weight: .heavy), "Font should be of size: 28 and weight: heavy")
    }
}
