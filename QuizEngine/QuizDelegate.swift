//
//  QuizDelegate.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 24/06/21.
//

import Foundation

public protocol QuizDelegate {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
    func handle(result: Result<Question, Answer>)
}
