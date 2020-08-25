//
//  NetworkController.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 24/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//

import UIKit
import AVKit

struct NetworkController {
    
    func fetchData(selectedDate: Date, completion: @escaping (PhotoInfo) -> Void) {
        let url = prepareURL(selectedDate: selectedDate)
        performRequest(url: url, finished: { (data) in
            if let photoInfo = self.parseJSON(photoData: data) {
                completion(photoInfo)
            }
        })
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage) -> Void) {
        performRequest(url: url, finished: { (data) in
            if let image = UIImage(data: data) {
                completion(image)
            }
        })
    }
    
    func performRequest(url: URL, finished: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Loading image failed: \(String(describing: error))")
                    return
                }
                
                if let data = data {
                    finished(data)
                }
            }
        }.resume()
    }
    
    func parseJSON(photoData: Data) -> PhotoInfo? {
        do {
            let decoder = JSONDecoder()
            let photoInfo = try decoder.decode(PhotoInfo.self, from: photoData)
            return photoInfo
        } catch {
            print("Parsing JSON failed: \(error)")
            return nil
        }
    }
    
    func prepareURL(selectedDate: Date) -> URL {
        let dateUrlFormatter = DateFormatter()
        dateUrlFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateUrlFormatter.string(from: selectedDate)
        
        let baseUrl = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "8e0SOielQeixak1Zaygd4Gb8abJnuvrjpLXOeHIN",
            "date": dateStr
        ]
        
        let url = baseUrl.withQueries(query)!
        return url
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
        resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
