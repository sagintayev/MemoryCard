//
//  AnswerComplexity.swift
//  MemoryCard
//
//  Created by Zhanibek on 26.02.2021.
//

enum AnswerComplexity: String {
    case easy = "Easy"
    case good = "Good"
    case hard = "Hard"
    case impossible = "Again"
    
    func choice(multiplier: Int) -> String {
        let days = (daysUntilNextCheck(multiplier: multiplier) != 0) ? "\(daysUntilNextCheck(multiplier: multiplier))d" : "today"
        return "\(rawValue) (\(days))"
    }
    
    func daysUntilNextCheck(multiplier: Int) -> Int {
        return daysInterval * multiplier
    }
 
    private var daysInterval: Int {
        switch self {
        case .easy: return 3
        case .good: return 2
        case .hard: return 1
        case .impossible: return 0
        }
    }
}
