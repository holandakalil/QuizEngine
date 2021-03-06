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
    
    private var quiz: Quiz!
    
    func test_startQuiz_answerAllQuestions_completesWithAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate)
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    func test_startQuiz_answerAllQuestionsTwice_completesWithNewAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate)

        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")

        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }
    
    // MARK: - Helper
    
    private func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
    }
    
    private final class DelegateSpy: QuizDelegate {
        var completedQuizzes: [[(String, String)]] = []
        var answerCompletions: [(String) -> Void] = []
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletions.append(completion)
        }
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers)
        }
    }
}
