//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Александр Гарипов on 05.02.2023.
//

import XCTest

@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccesLoading() throws {
        //Given:
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        
        // When:
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then:
            switch result {
            case.success(let movies):
                //сравниваем данные с тем, что мы предпологали
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                //// мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест            }
            }
            
        }
        waitForExpectations(timeout: 1)
    }
    
    
    
    func testFailureLoadint() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then:
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case.success(_):
                // мы не ждем тут успешной загрузки, если это так надо будет провалить тест
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    
}


