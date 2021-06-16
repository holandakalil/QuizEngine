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
    
    func test_equal_isEqual() {
        XCTAssertEqual(Question.singleAnswer(type), Question.singleAnswer(type))
        XCTAssertEqual(Question.multipleAnswer(type), Question.multipleAnswer(type))
    }
    
    func test_notEqual_isNotEqual() {
        XCTAssertNotEqual(Question.singleAnswer(type), Question.singleAnswer(anotherType))
        XCTAssertNotEqual(Question.multipleAnswer(type), Question.multipleAnswer(anotherType))
        XCTAssertNotEqual(Question.singleAnswer(type), Question.multipleAnswer(anotherType))
        XCTAssertNotEqual(Question.singleAnswer(type), Question.multipleAnswer(type))
    }
}
