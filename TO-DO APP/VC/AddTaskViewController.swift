//
//  AddTaskViewController.swift
//  TO-DO APP
//
//  Created by Sagar Vaghela on 10/09/18.
//  Copyright © 2018 Sagar Vaghela. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {
    
    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    var todo: Todo?

    // MARK: - Outlets
    @IBOutlet weak var addTaskTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        addTaskTextView.text.removeAll()
        addTaskTextView.becomeFirstResponder()
        
        if let todo = todo {
            addTaskTextView.text = todo.title
            addTaskTextView.text = todo.title
        }
    }
    
    // MARK: - Actions
    @objc func keyboardWillShow(with notification: Notification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        bottomConstraints.constant = keyboardHeight + 15
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func dismissAndResign() {
        addTaskTextView.resignFirstResponder()
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismissAndResign()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard let title = addTaskTextView.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo {
            todo.title = title
        } else {
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.date = Date()
        }
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            print("Error saving todo: \(error)")
        }
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        doneButton.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}




