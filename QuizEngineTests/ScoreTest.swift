//
//  ScoreTest.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 10/07/21.
//

import Foundation
import XCTest

final class ScoreTest: XCTestCase {
    let correct1 = "correct1"
    let correct2 = "correct2"
    let wrong = "wrong"
    
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
    }
    
    func test_oneWrongAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [wrong], comparingTo: [correct1]), 0)
    }
    
    func test_oneRightAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: [correct1], comparingTo: [correct1]), 1)
    }
    
    func test_oneRightAndOneWrongAnswer_scoresOne() {
        let score = BasicScore.score(
            for: [correct1, wrong],
            comparingTo: [correct1, correct2])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoRightAnswer_scoresTwo() {
        let score = BasicScore.score(
            for: [correct1, correct2],
            comparingTo: [correct1, correct2])
        XCTAssertEqual(score, 2)
    }
    
    func test_withUnequalSizedData_scoresTwo() {
        let score = BasicScore.score(
            for: [correct1, correct2, "another answer"],
            comparingTo: [correct1, correct2])
        XCTAssertEqual(score, 2)
    }
    
    private final class BasicScore {
        static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
            var score = 0
            for (index, answer) in answers.enumerated() {
                if index >= correctAnswers.count { return score }
                score += (answer == correctAnswers[index]) ? 1 : 0
            }
            return score
        }
    }
}
