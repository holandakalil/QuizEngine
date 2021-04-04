//
//  Flow.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 03/04/21.
//

import Foundation

protocol Router {
    func routeTo(question: String)
}

class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        guard !questions.isEmpty else { return }
        router.routeTo(question: "")
    }
}
