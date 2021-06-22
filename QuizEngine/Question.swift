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
}
