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
    let aValue = UUID()
    let anotherValue = UUID()
    
    func test_hashValue_withSameWrappedValue_isDifferenteForSingleAndMultipleAnswer() {
        XCTAssertNotEqual(Question.singleAnswer(aValue).hashValue,
                          Question.multipleAnswer(aValue).hashValue)
    }
    
    func test_hashValue_forSingleAnswer() {
        XCTAssertEqual(Question.singleAnswer(aValue).hashValue,
                       Question.singleAnswer(aValue).hashValue)
        
        XCTAssertNotEqual(Question.singleAnswer(aValue).hashValue,
                          Question.singleAnswer(anotherValue).hashValue)
    }
    
    func test_hashValue_forMultipleAnswer() {
        XCTAssertEqual(Question.multipleAnswer(aValue).hashValue,
                       Question.multipleAnswer(aValue).hashValue)
        
        XCTAssertNotEqual(Question.multipleAnswer(aValue).hashValue,
                          Question.multipleAnswer(anotherValue).hashValue)
    }
}
