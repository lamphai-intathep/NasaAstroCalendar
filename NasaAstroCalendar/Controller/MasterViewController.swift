//  MasterViewController.swift
//  NasaAstroCalendar
//  Created by Lamphai Intathep on 20/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let yesterday = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        datePicker.maximumDate = yesterday
        updateDateLabel()
    }
    
    func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let strDate = dateFormatter.string(from: datePicker.date)
        selectedDateLabel.text = strDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayImage" {
            let destination = segue.destination as! ImageViewController
            destination.selectedDate = datePicker.date
        }
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        updateDateLabel()
    }
    
    @IBAction func ClickButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "displayImage", sender: self)
    }
}
