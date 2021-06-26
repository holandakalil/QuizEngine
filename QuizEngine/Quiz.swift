//
//  Quiz.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 26/06/21.
//

import Foundation

public final class Quiz {
    private let flow: Any
    
    private init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(questions: [Question], delegate: Delegate, correctAnswers: [Question: Answer]) -> Quiz where Delegate.Question == Question, Delegate.Answer == Answer {
        let flow = Flow(questions: questions, delegate: delegate, scoring: {
            scoring($0, correctAnswers: correctAnswers)
        })
        flow.start()
        return Quiz(flow: flow)
    }
}
