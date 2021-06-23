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
    private let router = RouterSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        let q1 = "Q1"
        makeSUT(questions: [q1]).start()
        
        XCTAssertEqual(router.routedQuestions, [q1])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        let q1 = "Q1", q2 = "Q2"
        makeSUT(questions: [q1, q2]).start()
        
        XCTAssertEqual(router.routedQuestions.first, q1)
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let q1 = "Q1", q2 = "Q2"
        let sut = makeSUT(questions: [q1, q2])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, [q1, q1])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_routesToSecondAndThirdQuestions() {
        let questions = ["Q1", "Q2", "Q3"]
        let a1 = "A1", a2 = "A2"
        let sut = makeSUT(questions: questions)
        sut.start()
        
        router.answerCallback(a1)
        router.answerCallback(a2)
        
        XCTAssertEqual(router.routedQuestions, questions)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let questions = ["Q1"]
        let a1 = "A1"
        let sut = makeSUT(questions: questions)
        sut.start()
        
        router.answerCallback(a1)
        
        XCTAssertEqual(router.routedQuestions, questions)
    }
    
    func test_start_withNoQuestions_RouteToResult() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(router.routedResults!.answer, [:])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_routeToResult() {
        let q1 = "Q1"
        let a1 = "A1"
        let sut = makeSUT(questions: [q1])
        sut.start()
        
        router.answerCallback(a1)
        
        XCTAssertEqual(router.routedResults?.answer, [q1: a1])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_routeToResult() {
        let q1 = "Q1", q2 = "Q2"
        let a1 = "A1", a2 = "A2"
        let sut = makeSUT(questions: [q1, q2])
        sut.start()
        
        router.answerCallback(a1)
        router.answerCallback(a2)
        
        XCTAssertEqual(router.routedResults?.answer, [q1: a1, q2: a2])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_scores() {
        let q1 = "Q1", q2 = "Q2"
        let a1 = "A1", a2 = "A2"
        let sut = makeSUT(questions: [q1, q2]) { _ in 10 }
        sut.start()
        
        router.answerCallback(a1)
        router.answerCallback(a2)
        
        XCTAssertEqual(router.routedResults?.score, 10)
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers: [String: String] = [:]
        let q1 = "Q1", q2 = "Q2"
        let a1 = "A1", a2 = "A2"
        let sut = makeSUT(questions: [q1, q2]) { answers in
            receivedAnswers = answers
            return 20
        }
        sut.start()
        
        router.answerCallback(a1)
        router.answerCallback(a2)
        
        XCTAssertEqual(receivedAnswers, [q1: a1, q2: a2])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(questions: [String], scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: router, scoring: scoring)
    }
    
    private final class RouterSpy: Router {
        var routedQuestions: [String] = []
        var routedResults: Result<String, String>? = nil
        
        var answerCallback: ((String) -> Void) = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: Result<String, String>) {
            routedResults = result
        }
    }
}
