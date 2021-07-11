//
//  ScoreTest.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 10/07/21.
//

import Foundation
import XCTest

final class ScoreTest: XCTestCase {
    let answer1 = "an answer"
    let answer2 = "another answer"
    let wrong = "wrong"
    
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
    }
    
    func test_oneNotMathcingAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [wrong], comparingTo: [answer1]), 0)
    }
    
    func test_oneMathcingAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: [answer1], comparingTo: [answer1]), 1)
    }
    
    func test_oneMathcingAndOneNotMathcingAnswer_scoresOne() {
        let score = BasicScore.score(
            for: [answer1, wrong],
            comparingTo: [answer1, answer2])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoMathcingAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: [answer1, answer2],
            comparingTo: [answer1, answer2])
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyAnswers_twoMathcingAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: [answer1, answer2, "extra answer"],
            comparingTo: [answer1, answer2])
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
