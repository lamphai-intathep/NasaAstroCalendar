//
//  MasterViewController.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 20/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var indicatorImageView: UIImageView!

    var selectedDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let yesterday = Date().addingTimeInterval(-86400)
        let yesterday = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        datePicker.maximumDate = yesterday
        displayDate()
    }
    
    // MARK: - Display date on label
    func displayDate() {
        let dateUrlFormatter = DateFormatter()
        dateUrlFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateUrlFormatter.string(from: datePicker.date)
        //print(selectedDate)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let strDate = dateFormatter.string(from: datePicker.date)
        selectedDateLabel.text = strDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayImage" {
            let destination = segue.destination as! ImageViewController
            destination.selectedDate = selectedDate
        }
    }
    
    // MARK: - DatePicker Handler
    @IBAction func datePickerChanged(_ sender: Any) {
        displayDate()
    }
    
    // MARK: - Segues
    @IBAction func ClickButton(_ sender: UIButton) {
        //fetchData()
        //self.performSegue(withIdentifier: "displayImage", sender: self)
        self.performSegue(withIdentifier: "displayImage", sender: self)
    }
}
