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
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        let q1 = "Q1"
        let router = RouterSpy()
        let sut = Flow(questions: [q1], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, [q1])
    }
    
    func test_start_withTwoQuestion_routesToFirstQuestion() {
        let q1 = "Q1"
        let q2 = "Q2"
        let router = RouterSpy()
        let sut = Flow(questions: [q1, q2], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions.first, q1)
    }
    
    func test_startTwice_withTwoQuestion_routesToFirstQuestionTwice() {
        let q1 = "Q1"
        let q2 = "Q2"
        let router = RouterSpy()
        let sut = Flow(questions: [q1, q2], router: router)
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, [q1, q1])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_routesToSecondQuestion() {
        let questions = ["Q1", "Q2"]
        let a1 = "A1"
        let router = RouterSpy()
        let sut = Flow(questions: questions, router: router)
        sut.start()
        
        router.answerCallback(a1)
        
        XCTAssertEqual(router.routedQuestions, questions)
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
}
