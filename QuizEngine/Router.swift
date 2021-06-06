//
//  Router.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 05/06/21.
//

import Foundation

public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
