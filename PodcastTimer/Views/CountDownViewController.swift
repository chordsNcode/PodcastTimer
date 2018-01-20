//
//  CountDownViewController.swift
//  PodcastTimer
//
//  Created by Matt Dias on 11/25/17.
//  Copyright © 2017 Matt Dias. All rights reserved.
//

import UIKit

struct TimeUnits {
    static let hour = 3600
    static let fiveMinutes = 5 * 60
}


class CountDownViewController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var pauseButton: UIButton!
    
    var timer = Timer()
    var isRunning = false
    var timeInSeconds: Int = TimeUnits.hour {
        didSet {
            updateLabel(time: timeInSeconds)
        }
    }
    
    // MARK: -
    // MARK: -

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
        } else if time <= TimeUnits.fiveMinutes {
            self.view.backgroundColor = .orange
        }
    }
    
    func formattedTime(time: Int) -> String {
        let hours = time / TimeUnits.hour
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
        if let defaultTime = UserDefaults.standard.value(forKey: "defaultTimerValue") as? Int {
            timeInSeconds = defaultTime
        } else {
            timeInSeconds = TimeUnits.hour
        }
        
        timer.invalidate()
        isRunning = false
        self.view.backgroundColor = .black
        pauseButton.setTitle("Start", for: .normal)
    }
}
