//
//  task.swift
//  JustDoIt
//
//  Created by Kirill Tarasko on 18.02.2023.
//

import UIKit


class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        
    NotificationCenter.default.addObserver(self,
        selector:#selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
    }
    
    
    
    
    @IBAction func doneButtonPressed() {
        guard let title = taskTextView.text, !title.isEmpty else { return }
        let priority = Int16(prioritySegmentedControl.selectedSegmentIndex)
        if let task = task {
            StorageManager.shared.edit(task: task, with: title, and: priority)
        } else {
            StorageManager.shared.saveTask(withTitle: title, andPriority: priority)
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    private func setupTextView() {
        taskTextView.becomeFirstResponder()
        if let task = task {
            taskTextView.text = task.title
            prioritySegmentedControl.selectedSegmentIndex = Int(task.priority)
        } else {
            doneButton.isHidden = true
        }
    }
    
}

extension NewTaskViewController {
    
    @objc private func keyboardWillShow(with notification: Notification) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        
        guard let keyBoardFrame = notification.userInfo?[key] as? CGRect else { return }
        bottomConstraint.constant = keyBoardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension NewTaskViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden {
            textView.text.removeAll()
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

