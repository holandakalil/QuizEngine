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
    
    let q1 = "Q1", q2 = "Q2", q3 = "Q3"
    let a1 = "A1", a2 = "A2"
    
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        makeSUT(questions: [q1]).start()
        
        XCTAssertEqual(delegate.handledQuestions, [q1])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(questions: [q1, q2]).start()
        
        XCTAssertEqual(delegate.handledQuestions.first, q1)
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: [q1, q2])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestions, [q1, q1])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_delegatesSecondAndThirdQuestionsHandling() {
        let questions = [q1, q2, q3]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletion(a1)
        delegate.answerCompletion(a2)
        
        XCTAssertEqual(delegate.handledQuestions, questions)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let questions = [q1]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletion(a1)
        
        XCTAssertEqual(delegate.handledQuestions, questions)
    }
    
    func test_start_withOneQuestion_doesNotCompleteQuiz() {
        makeSUT(questions: [q1]).start()
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestions_completeWithEmptyQuiz() {
        let sut = makeSUT(questions: [])
        sut.start()
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: [q1, q2])
        sut.start()
        
        delegate.answerCompletion(a1)
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_completesQuiz() {
        let sut = makeSUT(questions: [q1])
        sut.start()
        
        delegate.answerCompletion(a1)
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [(q1, a1)])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_completesQuiz() {
        let sut = makeSUT(questions: [q1, q2])
        sut.start()
        
        delegate.answerCompletion(a1)
        delegate.answerCompletion(a2)
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [(q1, a1), (q2, a2)])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_scores() {
        let sut = makeSUT(questions: [q1, q2]) { _ in 10 }
        sut.start()
        
        delegate.answerCompletion(a1)
        delegate.answerCompletion(a2)
        
        XCTAssertEqual(delegate.handledResults?.score, 10)
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers: [String: String] = [:]
        let sut = makeSUT(questions: [q1, q2]) { answers in
            receivedAnswers = answers
            return 20
        }
        sut.start()
        
        delegate.answerCompletion(a1)
        delegate.answerCompletion(a2)
        
        XCTAssertEqual(receivedAnswers, [q1: a1, q2: a2])
    }
    
    // MARK: - Helpers
    private let delegate = DelegateSpy()
    private weak var weakSUT: Flow<DelegateSpy>?
    
    override func tearDown() {
        super.tearDown()
        
        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
    }
    
    private func makeSUT(questions: [String], scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, delegate: delegate, scoring: scoring)
        weakSUT = sut
        return sut
    }
    
    private func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
    }
    
    private final class DelegateSpy: QuizDelegate {
        var handledQuestions: [String] = []
        var handledResults: Result<String, String>? = nil
        var completedQuizzes: [[(String, String)]] = []
        
        var answerCompletion: ((String) -> Void) = { _ in }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCompletion = completion
        }
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers)
        }
        
        func handle(result: Result<String, String>) {
            handledResults = result
        }
    }
}
