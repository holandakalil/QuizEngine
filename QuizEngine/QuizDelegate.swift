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
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    func didCompleteQuiz(withAnswers answers: [(question: Question, answer: Answer)])
}
