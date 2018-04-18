//
//  CountDownViewController.swift
//  PodcastTimer
//
//  Created by Matt Dias on 11/25/17.
//  Copyright © 2017 Matt Dias. All rights reserved.
//

import UIKit

let hour = 3600
let fiveMinutes = 5 * 60

class CountDownViewController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    
    var savableTime = hour
    var timer = Timer()
    var isRunning = false
    var timeInSeconds: Int = hour {
        didSet {
            updateLabel(time: timeInSeconds)
        }
    }
    
    // MARK: -
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // MARK: - Formatters
    
    func updateLabel(time: Int) {
        if timeInSeconds >= 0 {
            timeLabel.text = formattedTime(time: timeInSeconds)
        } else {
            timeLabel.text = "- " + formattedTime(time: -timeInSeconds)
        }
        
        if time <= 0 {
            self.view.backgroundColor = .red
        } else if Double(time) <= Double(savableTime) * 0.083 {
            self.view.backgroundColor = .orange
        }
    }
    
    func formattedTime(time: Int) -> String {
        let hours = time / hour
        let minutes = (time / 60) % 60
        let seconds = time % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    // MARK: - Selectors
    
    @objc func updateTimer() {
        timeInSeconds -= 1
    }
    
    // MARK: - Actions
    
    @IBAction func didTapStartStop(_ sender: UIButton) {
        if isRunning {
            timer.invalidate()
            isRunning = false
            
            pauseButton.setTitle("Start", for: .normal)
        } else {
            runTimer()
            isRunning = true
            
            pauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func didTapReset(_ sender: UIButton) {
        let defaultHour = pickerView.selectedRow(inComponent: 0)
        let defaultMin = pickerView.selectedRow(inComponent: 1)
        let defaultSec = pickerView.selectedRow(inComponent: 2)
        savableTime = (defaultHour * hour) + (defaultMin * 60) + defaultSec
        
        pickerView.isHidden = !pickerView.isHidden
        timeLabel.isHidden = !timeLabel.isHidden
        
        timeLabel.text = formattedTime(time: savableTime)
        
        timeInSeconds = savableTime
        
        timer.invalidate()
        isRunning = false
        self.view.backgroundColor = .black
        pauseButton.setTitle("Start", for: .normal)
    }
}

extension CountDownViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }
}

extension CountDownViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 60
        case 2:
            return 60
        default:
            return 0
        }
    }
}
