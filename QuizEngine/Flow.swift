//
//  Flow.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 03/04/21.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallback: @escaping (String) -> Void)
}

class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        guard let firstQuestion = questions.first else { return }
        router.routeTo(question: firstQuestion) { [weak self] _ in
            guard let self = self else { return }
            guard let questionIndex = self.questions.index(of: firstQuestion) else { return }
            let nextQuestion = self.questions[questionIndex + 1]
            self.router.routeTo(question: nextQuestion) { _ in }
        }
    }
}
