//
//  CompletedCell.swift
//  NC1
//
//  Created by Minawati on 27/04/22.
//

import UIKit

class CompletedCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var pomodoros: UILabel!
    
    func setTask(task: Task){
        taskTitle.text = task.title
        pomodoros.text = String(task.currPomodoro) + " out of " + String(task.totalPomodoros) + " pomodoros"
    }
}
