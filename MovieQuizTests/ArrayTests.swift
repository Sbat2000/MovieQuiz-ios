//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Александр Гарипов on 05.02.2023.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        //When:
        let value = array[safe: 2]
        //then:
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
        
    }
    
    func testGetValueOutOfRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        //When:
        let value = array[safe: 20]
        //then:
        XCTAssertNil(value)
 
    }
}
