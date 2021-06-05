//
//  Result.swift
//  QuizEngine
//
//  Created by Kalil Holanda on 05/06/21.
//

import Foundation

struct Result<Question: Hashable, Answer> {
    let answer: [Question: Answer]
    let score: Int
}
