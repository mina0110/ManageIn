//
//  AddTaskController.swift
//  NC1
//
//  Created by Minawati on 26/04/22.
//

import Foundation
import UIKit

class AddTaskController: UIViewController {
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskPomodoroSessionTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func addTaskPressed(_ sender: UIButton) {
        
        if taskTitleTextField.text?.isEmpty == true && taskPomodoroSessionTextField.text?.isEmpty == true {
            taskTitleTextField.attributedPlaceholder = NSAttributedString(
                string: "Title must be filled",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
                )
            taskPomodoroSessionTextField.attributedPlaceholder = NSAttributedString(
                string: "Pomodoro Session must be filled",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
                )
            return
        }
        
        if taskTitleTextField.text?.isEmpty == true {
            taskTitleTextField.attributedPlaceholder = NSAttributedString(
                string: "Title must be filled",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
                )
            return
        }
        
        if taskPomodoroSessionTextField.text?.isEmpty == true {
            taskPomodoroSessionTextField.attributedPlaceholder = NSAttributedString(
                string: "Pomodoro Session must be filled",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
                )
            return
        }
        
        var taskArr: [Task] = []
        
        taskArr = retrieveDataFromUserDefault()
        
        var totalTask = 0
        
        if !taskArr.isEmpty {
            totalTask += taskArr.count
        }
        
        let pomodoro = Int(taskPomodoroSessionTextField.text ?? "") ?? 0
        let task = Task(id: totalTask+1, title: taskTitleTextField.text ?? "", currPomodoro: 0, totalPomodoros: pomodoro, isCompleted: false)

        taskArr.append(task)

        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(taskArr)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "taskArr")

        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func retrieveDataFromUserDefault() -> [Task] {
        var tasks: [Task] = []
        
        if let data = UserDefaults.standard.data(forKey: "taskArr") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                tasks = try decoder.decode([Task].self, from: data)
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        
        return tasks
    }
}
