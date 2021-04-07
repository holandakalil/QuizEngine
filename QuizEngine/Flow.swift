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
        router.routeTo(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] answer in
            guard let sSelf = self else { return }
            guard let currentQuestionIndex = sSelf.questions.firstIndex(of: question) else { return }
            sSelf.result[question] = answer
            
            if currentQuestionIndex + 1 < sSelf.questions.count {
                let nextQuestion = sSelf.questions[currentQuestionIndex + 1]
                sSelf.router.routeTo(question: nextQuestion, answerCallback: sSelf.routeNext(from: nextQuestion))
            } else {
                sSelf.router.routeTo(result: sSelf.result)
            }
        }
    }
}
