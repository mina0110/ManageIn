//
//  TimerController.swift
//  NC1
//
//  Created by Minawati on 27/04/22.
//

import UIKit
import AVFoundation

class TimerController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pomodoroCounterLbl: UILabel!
    @IBOutlet weak var taskTitleLbl: UILabel!
    @IBOutlet weak var periodDescLbl: UILabel!
    
    var allTask: [Task] = []
    var onProgressTaskData: Task?
    var audioPlayer: AVAudioPlayer?
    var timer = Timer()
    var isTimerRunning = false
    var focusPeriod = true
    var breakPeriod = false
    var currSession = 0
    var totalSession = 0
    var pomodoroTime = 10 // 1500
    var breakTime = 5 // 300
    
    // circular bar
    let progressTimerShapeLayer = CAShapeLayer()
    let backgroundShapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create circular bar
        createBackgroundShape()
        createProgessTimerShape()
        
        taskTitleLbl.text = onProgressTaskData?.title
        pomodoroCounterLbl.text = "0 out of \(onProgressTaskData?.totalPomodoros ?? 0) pomodoros"
        totalSession = onProgressTaskData?.totalPomodoros ?? 0
        
        // give action back button on navigation bar
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x:0,y:0,width:2*(self.navigationController?.navigationBar.bounds.height)!,height:(self.navigationController?.navigationBar.bounds.height)!)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(abortSession(sender:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.tag = 1
        self.navigationController?.navigationBar.addSubview(imageView)
    }
    
    func createBackgroundShape() {
        backgroundShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY-19), radius: 167.5, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true).cgPath
        backgroundShapeLayer.strokeColor = UIColor(white: 0.94, alpha: 1.0).cgColor
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        backgroundShapeLayer.lineWidth = 7
        view.layer.addSublayer(backgroundShapeLayer)
    }

    func createProgessTimerShape() {
        progressTimerShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY-19), radius: 167.5, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true).cgPath
        progressTimerShapeLayer.strokeColor = UIColor(red: 0.79, green: 0.41, blue: 0.41, alpha: 1.00).cgColor
        progressTimerShapeLayer.fillColor = UIColor.clear.cgColor
        progressTimerShapeLayer.lineWidth = 7
        view.layer.addSublayer(progressTimerShapeLayer)
    }
    
    @objc func abortSession(sender: UIBarButtonItem) {
        timer.invalidate()
        
        let alertDialog = UIAlertController(title: "Stop the pomodoro?", message: "All the session will be aborted", preferredStyle: .alert)
        
        let backButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirmButton = UIAlertAction(title: "Abort", style: .destructive, handler: {
            action in
            self.pomodoroTime = 1500
            self.isTimerRunning = false
            self.timerLbl.text = "00:25:00"
            self.navigationController?.popViewController(animated: true)
        })
        
        alertDialog.addAction(backButton)
        alertDialog.addAction(confirmButton)
        
        self.present(alertDialog, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        for view in (self.navigationController?.navigationBar.subviews)!{
            if view.tag == 1 {
                view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        
        if !isTimerRunning {
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
            isTimerRunning = true
            playButton.isHidden = true
            
            if focusPeriod {
                resetButton.isHidden = false
                pauseButton.isHidden = false
            } else if breakPeriod {
                resetButton.isHidden = true
                pauseButton.isHidden = true
            }
        }
    }
    
    @IBAction func pauseBtnPressed(_ sender: UIButton) {
        
        if !isTimerRunning {
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
            
            isTimerRunning = true
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            pauseButton.setTitle(" Pause", for: .normal)
            
        } else {
            timer.invalidate()
            
            isTimerRunning = false
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            pauseButton.setTitle(" Play", for: .normal)
        }
    }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        timer.invalidate()
        
        pomodoroTime = 10 // 1500
        isTimerRunning = false
        playButton.isHidden = false
        
        if focusPeriod {
            timerLbl.text = "00:25:00"
        } else if breakPeriod {
            timerLbl.text = "00:05:00"
        }
    }
    
    @objc func countdown(){

        if focusPeriod {
            
            if pomodoroTime > 0 {
                
                pomodoroTime -= 1
                
            } else {
             
                currSession += 1
                timer.invalidate()
                pomodoroTime = 10 // 1500
                
                focusPeriod = false
                breakPeriod = true
                isTimerRunning = false
                
                self.taskTitleLbl.text = "Break Time"
                self.periodDescLbl.text = "Get up from your seat and take a short break"
                self.playButton.isHidden = false
                self.resetButton.isHidden = true
                self.pauseButton.isHidden = true
                
                playAudio()
                
                let alertDialog = UIAlertController(title: "Great Job!", message: "Take a short break! Refresh both your mind and body", preferredStyle: .alert)
                
                alertDialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    self.audioPlayer?.stop()
                }))
                
                self.present(alertDialog, animated: true, completion: nil)
            
            }
            
        } else if breakPeriod {
            
            if breakTime > 0 {
                
                breakTime -= 1
                
            } else {
                
                if currSession < totalSession {
                    
                    breakTime = 5 // 300
                    
                    timer.invalidate()
                    
                    focusPeriod = true
                    breakPeriod = false
                    isTimerRunning = false
                    
                    self.playButton.isHidden = false
                    self.resetButton.isHidden = true
                    self.pauseButton.isHidden = true
                    self.taskTitleLbl.text = onProgressTaskData?.title
                    self.periodDescLbl.text = "Keep your focus and do as much work as you can "
                    
                    playAudio()
                    
                    let alertDialog = UIAlertController(title: "Time's up!", message: "Back to work and keep your focus!", preferredStyle: .alert)
                    
                    pomodoroCounterLbl.text = String(currSession) + " out of " + String(totalSession) + " pomodoros"
                    
                    alertDialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        action in
                        self.audioPlayer?.stop()
                    }))
                    
                    self.present(alertDialog, animated: true, completion: nil)
                    
                } else {
                    
                    timer.invalidate()
                    progressTimerShapeLayer.removeAllAnimations()
                    
                    focusPeriod = false
                    breakPeriod = false
                    
                    playAudio()
                    
                    pomodoroCounterLbl.text = String(currSession) + " out of " + String(totalSession) + " pomodoros"
                    
                    allTask = retrieveDataFromUserDefault()
                    
                    let totalData = allTask.count - 1
                    
                    for i in 0...totalData {
                        if allTask[i].id == onProgressTaskData?.id {
                            allTask[i].isCompleted = true
                            allTask[i].currPomodoro = totalSession
                        }
                    }
                    
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()

                        // Encode Note
                        let data = try encoder.encode(allTask)

                        // Write/Set Data
                        UserDefaults.standard.set(data, forKey: "taskArr")

                    } catch {
                        print("Unable to Encode Array of Notes (\(error))")
                    }
                    
                    
                    let alertDialog = UIAlertController(title: "Done!", message: "You did a good job of completing the task!", preferredStyle: .alert)
                    
                    alertDialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                        self.audioPlayer?.stop()
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    self.present(alertDialog, animated: true, completion: nil)
                }
            }
        }
        
        timerLbl.text = formatTimer()
    }
    
    func formatTimer() -> String {
        var minutes = 0
        var seconds = 0
        
        if focusPeriod {
            minutes = Int(pomodoroTime) / 60 % 60
            seconds = Int(pomodoroTime) % 60
            
        } else if breakPeriod {
            minutes = Int(breakTime) / 60 % 60
            seconds = Int(breakTime) % 60
        }
        
        return String(format: "00:%02i:%02i", minutes, seconds)
    }
    
    func playAudio(){
        
        guard let url = Bundle.main.url(forResource: "timer_ringtone", withExtension: "mp3") else {
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = audioPlayer else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
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
