//
//  PhotoInfo.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 20/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//

import Foundation

struct PhotoInfo: Codable {
    var title: String
    var explanation: String
    var url: URL
    var hdurl: URL?
    
    init(title:String, explanation:String, url:URL, hdurl:URL) {
        self.title = title
        self.explanation = explanation
        self.url = url
        self.hdurl = hdurl
    }
    
    var isVideo: Bool {
        return url.absoluteString.contains("youtube") || url.absoluteString.contains(".mp4")
    }
}
