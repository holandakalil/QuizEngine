//
//  Flow.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 03/04/21.
//

import Foundation

class Flow <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int
    
    
    init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    
    func start() {
        guard let firstQuestion = questions.first else {
            router.routeTo(result: result())
            return
        }
        router.routeTo(question: firstQuestion, answerCallback: nextCallBack(from: firstQuestion))
    }
    
    private func nextCallBack(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question: question, answer: $0) }
    }
    
    private func routeNext(question: Question, answer: Answer) {
        guard let currentQuestionIndex = questions.firstIndex(of: question) else { return }
        answers[question] = answer
        let nextQuestionIndex = currentQuestionIndex + 1
        
        if nextQuestionIndex < questions.count {
            let nextQuestion = questions[nextQuestionIndex]
            router.routeTo(question: nextQuestion, answerCallback: nextCallBack(from: nextQuestion))
        } else {
            router.routeTo(result: result())
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answer: answers, score: scoring(answers))
    }
}

