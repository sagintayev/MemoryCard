//
//  Protocols.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-28.
//

protocol CardManager {
    func saveCard(question: String, answer: String, in deck: Deck)
    func updateCard(_ card: Card, question: String?, answer: String?, deck: Deck?)
    func deleteCard(_ card: Card)
    func getAllCards() throws -> [Card]
}

protocol DeckManager {
    func saveDeck(named name: String)
    func updateDeck(_ deck: Deck, name: String)
    func deleteDeck(_ deck: Deck)
    func getAllDecks() throws -> [Deck]
}
