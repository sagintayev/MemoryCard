//
//  CardViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-02-03.
//

import Foundation

final class CardViewModel {
    private var cardModel: Card
    var question: Observable<String>
    var answer: Observable<String>
    
    init(from model: Card) {
        cardModel = model
        question = Observable(model.question ?? "")
        answer = Observable(model.answer ?? "")
    }
}
