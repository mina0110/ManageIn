//
//  HomeController.swift
//  NC1
//
//  Created by Minawati on 26/04/22.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var welcomingLbl: UILabel!
    @IBOutlet weak var onProgressTable: UITableView!
    @IBOutlet weak var completedTable: UITableView!
    
    // empty task
    @IBOutlet weak var workImage: UIImageView!
    @IBOutlet weak var taskEmptyLbl: UILabel!
    @IBOutlet weak var emptyTaskDescLbl: UILabel!
    @IBOutlet weak var addTaskButton: UIButton!
    
    // have task
    @IBOutlet weak var todayTaskLbl: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var onProgressLbl: UILabel!
    @IBOutlet weak var completedTaskLbl: UILabel!
    
    var allTask: [Task] = []
    var onProgressTask: [Task] = []
    var completedTask: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0.79, green: 0.41, blue: 0.41, alpha: 1.00)
        
        welcomingLbl.font = UIFont.boldSystemFont(ofSize: 24.0)
        welcomingLbl.textColor = UIColor.white
        
        allTask = retrieveDataFromUserDefault()
        
        if allTask.isEmpty {
            todayTaskLbl.isHidden = true
            addButton.isHidden = true
            onProgressLbl.isHidden = true
            completedTaskLbl.isHidden = true
            onProgressTable.isHidden = true
            completedTable.isHidden = true
            
        } else {
         
            workImage.isHidden = true
            taskEmptyLbl.isHidden = true
            emptyTaskDescLbl.isHidden = true
            addTaskButton.isHidden = true
            
            // ON PROGRESS TABLE
            onProgressTask = onProgressData()
            onProgressTable.rowHeight = 63.0
            onProgressTable.separatorStyle = .none
            
            onProgressTable.delegate = self
            onProgressTable.dataSource = self
            
            // COMPLETED TABLE
            completedTask = completeTask()
            completedTable.rowHeight = 63.0
            completedTable.separatorStyle = .none
            
            completedTable.delegate = self
            completedTable.dataSource = self
            
            onProgressTable.reloadData()
            completedTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        welcomingLbl.font = UIFont.boldSystemFont(ofSize: 24.0)
        welcomingLbl.textColor = UIColor.white
        
        allTask = retrieveDataFromUserDefault()
        
        if allTask.isEmpty {
            
            workImage.isHidden = false
            taskEmptyLbl.isHidden = false
            emptyTaskDescLbl.isHidden = false
            addTaskButton.isHidden = false
            
            todayTaskLbl.isHidden = true
            addButton.isHidden = true
            onProgressLbl.isHidden = true
            completedTaskLbl.isHidden = true
            onProgressTable.isHidden = true
            completedTable.isHidden = true
            
        } else {
         
            workImage.isHidden = true
            taskEmptyLbl.isHidden = true
            emptyTaskDescLbl.isHidden = true
            addTaskButton.isHidden = true
            
            todayTaskLbl.isHidden = false
            addButton.isHidden = false
            onProgressLbl.isHidden = false
            completedTaskLbl.isHidden = false
            onProgressTable.isHidden = false
            completedTable.isHidden = false
            
            // ON PROGRESS TABLE
            onProgressTask = onProgressData()
            onProgressTable.rowHeight = 63.0
            onProgressTable.separatorStyle = .none
            
            onProgressTable.delegate = self
            onProgressTable.dataSource = self
            
            // COMPLETED TABLE
            completedTask = completeTask()
            completedTable.rowHeight = 63.0
            completedTable.separatorStyle = .none
            
            completedTable.delegate = self
            completedTable.dataSource = self
            
            onProgressTable.reloadData()
            completedTable.reloadData()
        }
        
        onProgressTask = onProgressData()
        completedTask = completeTask()
        
        onProgressTable.reloadData()
        completedTable.reloadData()
    }
    
    @IBAction func addTaskBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddTask", sender: self)
    }
    
    @IBAction func addNewTaskBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddTask", sender: self)
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
    
    func onProgressData() -> [Task] {
        onProgressTask = []
        let tasks: [Task] = retrieveDataFromUserDefault()
        
        for task in tasks {
            if !task.isCompleted {
                onProgressTask.append(task)
            }
        }
        
        return onProgressTask
    }
    
    func completeTask() -> [Task] {
        completedTask = []
        let tasks: [Task] = retrieveDataFromUserDefault()
        
        for task in tasks {
            if task.isCompleted {
                completedTask.append(task)
            }
        }
        
        return completedTask
    }
}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        
        switch tableView {
        case onProgressTable:
            numberOfRow = onProgressTask.count
        case completedTable:
            numberOfRow = completedTask.count
        default:
            print("Error")
        }
        
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TaskCell()
        
        switch tableView {
        case onProgressTable:
            cell = tableView.dequeueReusableCell(withIdentifier: "onProgressCell") as! TaskCell
            let onProgressTask = onProgressTask[indexPath.row]
            cell.setOnProgressTask(task: onProgressTask)

        case completedTable:
            cell = tableView.dequeueReusableCell(withIdentifier: "completedCell") as! TaskCell
            let completedTask = completedTask[indexPath.row]
            cell.setCompletedTask(task: completedTask)
            
        default:
            print("Error")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = (storyboard?.instantiateViewController(withIdentifier: "TimerController") as? TimerController)!
        destinationVC.onProgressTaskData = Task(id: onProgressTask[indexPath.row].id, title: onProgressTask[indexPath.row].title, currPomodoro: 0, totalPomodoros: onProgressTask[indexPath.row].totalPomodoros, isCompleted: false)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
