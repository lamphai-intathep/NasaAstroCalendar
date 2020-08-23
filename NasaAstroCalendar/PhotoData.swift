//
//  PhotoData.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 21/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//

import Foundation

    struct PhotoData: Codable {
        var title: String
        //var desc: String
        //var url: String
        
        init(title: String, desc: String, url: String) {
            self.title = title
            // self.desc = desc
            // self.url = url
        }
}
