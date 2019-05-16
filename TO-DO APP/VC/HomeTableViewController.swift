//
//  HomeTableViewController.swift
//  TO-DO APP
//
//  Created by Sagar Vaghela on 10/09/18.
//  Copyright © 2018 Sagar Vaghela. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController {
    
    // MARK: - Properties
    var resultsControllers: NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        // Initialize resultControllers
        resultsControllers = NSFetchedResultsController (
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContex,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        resultsControllers.delegate = self
        
        // Fetch Data
        do {
            try resultsControllers.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsControllers.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        // Configure the cell...
        let todo = resultsControllers.object(at: indexPath)
        cell.textLabel?.text = todo.title
        
        return cell
    }
    
    // MARK: - TableView delegates
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // Delete functionality
            let todo = self.resultsControllers.object(at: indexPath)
            self.resultsControllers.managedObjectContext.delete(todo)
            do {
                try self.resultsControllers.managedObjectContext.save()
                completion(true)
            } catch {
                print("Delete fali: \(error)")
                completion(false)
            }
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            // Task complete functionality
            let todo = self.resultsControllers.object(at: indexPath)
            self.resultsControllers.managedObjectContext.delete(todo)
            do {
                try self.resultsControllers.managedObjectContext.save()
                completion(true)
            } catch {
                print("Check fali: \(error)")
                completion(false)
            }
        }
        action.image = #imageLiteral(resourceName: "check")
        action.backgroundColor = UIColor.green
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addTask", sender: tableView.cellForRow(at: indexPath))
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddTaskViewController {
            vc.managedContext = resultsControllers.managedObjectContext
        }
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddTaskViewController {
            vc.managedContext = resultsControllers.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell) {
                let todo = resultsControllers.object(at: indexPath)
                vc.todo = todo
            }
        }
    
    }
}

extension HomeTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexpath = newIndexPath{
                tableView.insertRows(at: [indexpath], with: .automatic)
            }
        case .delete:
            if let indexpath = indexPath {
                tableView.deleteRows(at: [indexpath], with: .automatic)
            }
        case .update:
            if let indexpath = indexPath, let cell = tableView.cellForRow(at: indexpath) {
                let todo = resultsControllers.object(at: indexpath)
                cell.textLabel?.text = todo.title
            }
        default:
            break
        }
    }
}




