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
}

class Flow {
    private let router: Router
    private let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        guard let firstQuestion = questions.first else { return }
        router.routeTo(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] _ in
            guard let sSelf = self else { return }
            guard let currentQuestionIndex = sSelf.questions.firstIndex(of: question), currentQuestionIndex + 1 < sSelf.questions.count else { return }
            let nextQuestion = sSelf.questions[currentQuestionIndex + 1]
            sSelf.router.routeTo(question: nextQuestion, answerCallback: sSelf.routeNext(from: nextQuestion))
        }
    }
}
