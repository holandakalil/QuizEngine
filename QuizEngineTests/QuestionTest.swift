//
//  QuestionTest.swift
//  QuizAppTests
//
//  Created by Kalil Holanda on 10/06/21.
//

import Foundation
import XCTest
@testable import QuizEngine

class QuestionTest: XCTestCase {
    let type = "a string"
    let anotherType = "another string"
    
    func test_hashValue_singleAnswer_returnsTypeHash() {
        let sut = Question.singleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_hashValue_multipleAnswer_returnsTypeHash() {
        let sut = Question.multipleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
}
