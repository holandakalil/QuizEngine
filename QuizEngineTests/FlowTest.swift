//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Kalil Holanda on 03/04/21.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionsCount, 0)
    }
    
    func test_start_withOneQuestion_routeToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionsCount, 1)
    }
    
    func test_start_withOneQuestion_routeToCorrectQuestion() {
        let q1 = "Q1"
        let router = RouterSpy()
        let sut = Flow(questions: [q1], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestion, q1)
    }
    
    class RouterSpy: Router {
        var routedQuestionsCount = 0
        var routedQuestion: String? = nil
        
        func routeTo(question: String) {
            routedQuestionsCount += 1
            routedQuestion = question
        }
    }
}
