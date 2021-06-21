//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by Kalil Holanda on 05/06/21.
//

import Foundation
import QuizEngine_MacOS

final class RouterSpy: Router {
    var routedQuestions: [String] = []
    var routedResults: Result<String, String>? = nil
    
    var answerCallback: ((String) -> Void) = { _ in }
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func routeTo(result: Result<String, String>) {
        routedResults = result
    }
}
