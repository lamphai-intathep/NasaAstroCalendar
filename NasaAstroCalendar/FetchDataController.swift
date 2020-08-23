//
//  FetchDataController.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 21/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//

import Foundation
import UIKit

class FetchDataController: UIViewController  {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var selectedDate: String = ""
    var photoInfo: PhotoInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayActivityIndicator()
        //print(selectedDate)
        if !selectedDate.isEmpty {
            fetchData()
        }
    }
    
    func displayActivityIndicator() {
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    

    

}
