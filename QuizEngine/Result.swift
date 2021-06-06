//
//  Result.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 05/06/21.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answer: [Question: Answer]
    public let score: Int
}
