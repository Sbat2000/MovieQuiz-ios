//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Александр Гарипов on 07.02.2023.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //    func testExample() throws {
    //        // UI tests must launch the application that they test.
    //        let app = XCUIApplication()
    //        app.launch()
    //
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //    }
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"] // находим начальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap() // находим кнопку "Да" и нажимаем ее програмно
        sleep(3)
        let secondPoster = app.images["Poster"] // находим постер после нажатия кнопки, он должен быть другой
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData) // проверям что постеры разные
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    
    func testnoYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"] // находим начальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap() // находим кнопку "Да" и нажимаем ее програмно
        sleep(3)
        let secondPoster = app.images["Poster"] // находим постер после нажатия кнопки, он должен быть другой
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData) // проверям что постеры разные
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    
    func testFinishAlert() {
        sleep(3)
        
        for _ in 0...9 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        let alert = app.alerts["Result alert"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        sleep(3)
        
        for _ in 0...9 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        let alert = app.alerts["Result alert"]
        
        alert.buttons.firstMatch.tap()
        
        sleep (3)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "1/10")
        XCTAssertFalse(alert.exists)
    }
}
