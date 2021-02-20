//
//  NSNotification.Name+CustomNames.swift
//  MemoryCard
//
//  Created by Zhanibek on 20.02.2021.
//

import Foundation

extension NSNotification.Name {
    /// A notification that Card was created/updated/deleted.
    ///
    /// The notification object is the persistence manager. The userInfo dictionary contains the following keys: card, action.
    static let CardDidChange = NSNotification.Name("CardDidChangeNotification")
    
    /// A notification that Deck was created/updated/deleted.
    ///
    /// The notification object is the persistence manager. The userInfo dictionary contains the following keys: deck, action.
    static let DeckDidChange = NSNotification.Name("DeckDidChangeNotification")
}
