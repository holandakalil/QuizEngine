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
        
        XCTAssertTrue(delegate.questionsAsked.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        makeSUT(questions: [q1]).start()
        
        XCTAssertEqual(delegate.questionsAsked, [q1])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(questions: [q1, q2]).start()
        
        XCTAssertEqual(delegate.questionsAsked.first, q1)
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: [q1, q2])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.questionsAsked, [q1, q1])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_delegatesSecondAndThirdQuestionsHandling() {
        let questions = [q1, q2, q3]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletions[0](a1)
        delegate.answerCompletions[1](a2)
        
        XCTAssertEqual(delegate.questionsAsked, questions)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let questions = [q1]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletions[0](a1)
        
        XCTAssertEqual(delegate.questionsAsked, questions)
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
        
        delegate.answerCompletions[0](a1)
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_completesQuiz() {
        let sut = makeSUT(questions: [q1])
        sut.start()
        
        delegate.answerCompletions[0](a1)
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [(q1, a1)])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_completesQuiz() {
        let sut = makeSUT(questions: [q1, q2])
        sut.start()
        
        delegate.answerCompletions[0](a1)
        delegate.answerCompletions[1](a2)
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [(q1, a1), (q2, a2)])
    }
    
    func test_startAndAnswerFirstAndSecondQuestionsTwice_withTwoQuestions_completesQuizTwice() {
        let sut = makeSUT(questions: [q1, q2])
        sut.start()

        delegate.answerCompletions[0](a1)
        delegate.answerCompletions[1](a2)

        delegate.answerCompletions[0](a2)
        delegate.answerCompletions[1](a1)

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [(q1, a1), (q2, a2)])
        assertEqual(delegate.completedQuizzes[1], [(q1, a2), (q2, a1)])
    }
    
    // MARK: - Helpers
    private let delegate = DelegateSpy()
    private weak var weakSUT: Flow<DelegateSpy>?
    
    override func tearDown() {
        super.tearDown()
        
        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
    }
    
    private func makeSUT(questions: [String]) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, delegate: delegate)
        weakSUT = sut
        return sut
    }
    
    private func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
    }
    
    private final class DelegateSpy: QuizDelegate {
        var questionsAsked: [String] = []
        var answerCompletions: [(String) -> Void] = []
        
        var handledResults: Result<String, String>? = nil
        var completedQuizzes: [[(String, String)]] = []
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            questionsAsked.append(question)
            self.answerCompletions.append(completion)
        }
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers)
        }
        
        func handle(result: Result<String, String>) {
            handledResults = result
        }
    }
}
