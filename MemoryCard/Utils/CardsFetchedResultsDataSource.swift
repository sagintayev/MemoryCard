//
//  CardsFetchedResultsDataSource.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-29.
//

import UIKit
import CoreData

final class CardsFetchedResultsDataSource: NSObject {
    var deck: Deck
    
    private unowned let tableView: UITableView
    private var fetchRequest: NSFetchRequest<Card> {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.sortDescriptors = fetchSortDescriptors
        fetchRequest.predicate = fetchPredicate
        return fetchRequest
    }
    private let fetchSortDescriptors = [NSSortDescriptor(keyPath: \Card.question, ascending: false)]
    private lazy var fetchPredicate = NSPredicate(format: "%K == %@", #keyPath(Card.deck.name), deck.name!)
    private let persistenManager = PersistenceManager()
    private lazy var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistenManager.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    init(tableView: UITableView, deck: Deck) {
        self.tableView = tableView
        self.deck = deck
        super.init()
        setupFetchedResultsController()
        try? fetchedResultsController.performFetch()
    }
    
    private func setupFetchedResultsController() {
        fetchedResultsController.delegate = self
    }
}

extension CardsFetchedResultsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = fetchedResultsController.object(at: indexPath)
        let cardViewModel = CardViewModel(from: card)
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath)
        if let cell = cell as? CardTableViewCell {
            cell.setViewModel(cardViewModel)
        }
        return cell
    }
}

extension CardsFetchedResultsDataSource: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? CardTableViewCell else { return }
        guard let card = anObject as? Card else { return }
        
        cell.setViewModel(CardViewModel(from: card))
        
        switch type {
        case .update:
            tableView.reloadRows(at: [indexPath], with: .right)
        case .insert:
            tableView.insertRows(at: [indexPath], with: .right)
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .right)
        case .move:
            guard let newIndexPath = newIndexPath else { return }
            tableView.reloadRows(at: [indexPath, newIndexPath], with: .right)
        @unknown default:
            break
        }
    }
}
