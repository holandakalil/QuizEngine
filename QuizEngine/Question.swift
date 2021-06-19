//
//  Question.swift
//  QuizApp
//
//  Created by Kalil Holanda on 10/06/21.
//

import Foundation

public enum Question<T: Hashable> : Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
    
    public var hashValue: Int {
        switch self {
            case .singleAnswer(let value):
                return value.hashValue
            case .multipleAnswer(let value):
                return value.hashValue
        }
    }
}
