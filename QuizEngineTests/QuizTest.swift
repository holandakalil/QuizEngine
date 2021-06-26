//
//  QuizTest.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 26/06/21.
//

import Foundation
import XCTest
import QuizEngine

final class QuizTest: XCTestCase {
    
    private let delegate = DelegateSpy()
    private var quiz: Quiz!
    
    override func setUp() {
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scores0() {
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResults!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scores1() {
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResults!.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scores2() {
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResults!.score, 2)
    }
    
    private final class DelegateSpy: QuizDelegate {
        var handledResults: Result<String, String>? = nil
        
        var answerCallback: ((String) -> Void) = { _ in }
        
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func handle(result: Result<String, String>) {
            handledResults = result
        }
    }
}
