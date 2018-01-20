//
//  SettingsViewController.swift
//  PodcastTimer
//
//  Created by Matthew Dias on 1/14/18.
//  Copyright © 2018 Matt Dias. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var defaultTimeButton: UIButton!
    let pickerVC = PickerViewController(nibName: "PickerViewController", bundle: Bundle.main)
    // TODO: willDisappear -> save selection to defaults
    // TODO: saveButton -> set picker to defaults
    // TODO: animate open/close of picker
    // TODO: autolayout in storyboard
    // TODO: picker labels? -> probably need to do picker as overlay
    var defaultHour: Int = 0
    var defaultMin: Int = 0
    var defaultSec: Int = 0

    override func viewDidLoad() {
        if let defaultTime = UserDefaults.standard.value(forKey: "defaultTimerValue") as? Int {
            defaultHour = defaultTime / TimeUnits.hour
            defaultMin = (defaultTime / 60) % 60
            defaultSec = defaultTime % 60
        } else {
            defaultHour = 1
        }

        let title = "\(String(format: "%02d", defaultHour)):\(String(format: "%02d", defaultMin)):\(String(format: "%02d", defaultSec))"
        defaultTimeButton.setTitle(title, for: .normal)
    }

    @IBAction func setDefaultTimerLength(sender: UIButton) {
        pickerVC.loadView()
        pickerVC.pickerView.dataSource = self
        pickerVC.pickerView.delegate = self
        pickerVC.pickerView.showsSelectionIndicator = true
        pickerVC.pickerView.selectRow(defaultHour, inComponent: 0, animated: false)
        pickerVC.pickerView.selectRow(defaultMin, inComponent: 1, animated: false)
        pickerVC.pickerView.selectRow(defaultSec, inComponent: 2, animated: false)
        pickerVC.dismissButton.addTarget(self, action: #selector(dismissOverlay), for: .touchUpInside)
        self.view.addSubview(pickerVC.view)
    }

    @objc func dismissOverlay() {
        defaultHour = pickerVC.pickerView.selectedRow(inComponent: 0)
        defaultMin = pickerVC.pickerView.selectedRow(inComponent: 1)
        defaultSec = pickerVC.pickerView.selectedRow(inComponent: 2)
        let savableTime = (defaultHour * TimeUnits.hour) + (defaultMin * 60) + defaultSec
        UserDefaults.standard.set(savableTime, forKey: "defaultTimerValue")

        let title = "\(String(format: "%02d", defaultHour)):\(String(format: "%02d", defaultMin)):\(String(format: "%02d", defaultSec))"
        defaultTimeButton.setTitle(title, for: .normal)
        
        pickerVC.view.removeFromSuperview()
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }
}

extension SettingsViewController: UIPickerViewDataSource {
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
