//
//  Game.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 05/06/21.
//

import Foundation

@available(*, deprecated)
public final class Game <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Flow<R>
    
    init(flow: Flow<R>) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> {
    let flow = Flow(questions: questions, router: router, scoring: {
        scoring($0, correctAnswers: correctAnswers)
    })
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { score, tuple in
        return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
