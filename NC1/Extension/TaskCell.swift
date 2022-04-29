//
//  OnProgressCell.swift
//  NC1
//
//  Created by Minawati on 27/04/22.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var pomodoros: UILabel!
    
    @IBOutlet weak var completedTaskTitle: UILabel!
    @IBOutlet weak var completedPomodoros: UILabel!
    
    func setOnProgressTask(task: Task){
        taskTitle.text = task.title
        pomodoros.text = String(task.currPomodoro) + " out of " + String(task.totalPomodoros) + " pomodoros"
    }
    
    func setCompletedTask(task: Task) {
        completedTaskTitle.text = task.title
        completedPomodoros.text = String(task.currPomodoro) + " out of " + String(task.totalPomodoros) + " pomodoros"
    }
}
