//
//  Flow.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 03/04/21.
//

import Foundation

final class Flow <R: QuizDelegate> {
    typealias Question = R.Question
    typealias Answer = R.Answer
    
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
        routeToQuestion(at: questions.startIndex)
    }
    
    private func routeToQuestion(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            router.handle(question: question, answerCallback: callback(for: question, at: index))
        } else {
            router.handle(result: result())
        }
    }
    
    private func routeToQuestion(after index: Int) {
        routeToQuestion(at: questions.index(after: index))
    }
    
    private func callback(for question: Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.answers[question] = answer
            self?.routeToQuestion(after: index)
        }
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
            router.handle(question: nextQuestion, answerCallback: nextCallBack(from: nextQuestion))
        } else {
            router.handle(result: result())
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answer: answers, score: scoring(answers))
    }
}

