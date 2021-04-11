//
//  Flow.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 03/04/21.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
    func routeTo(result: [String: String])
}

class Flow {
    private let router: Router
    private let questions: [String]
    private var result: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        guard let firstQuestion = questions.first else {
            router.routeTo(result: result)
            return
        }
        router.routeTo(question: firstQuestion, answerCallback: nextCallBack(from: firstQuestion))
    }
    
    private func nextCallBack(from question: String) -> Router.AnswerCallback {
        return { [weak self] in self?.routeNext(question: question, answer: $0) }
    }
    
    private func routeNext(question: String, answer: String) {
        guard let currentQuestionIndex = questions.firstIndex(of: question) else { return }
        result[question] = answer
        let nextQuestionIndex = currentQuestionIndex + 1
        
        if nextQuestionIndex < questions.count {
            let nextQuestion = questions[nextQuestionIndex]
            router.routeTo(question: nextQuestion, answerCallback: nextCallBack(from: nextQuestion))
        } else {
            router.routeTo(result: result)
        }
    }
    
}
