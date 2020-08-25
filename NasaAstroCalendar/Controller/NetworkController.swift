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
    
    func performRequest(selectedDate: Date, completion: @escaping (PhotoInfo) -> Void) {
        let url = prepareURL(selectedDate: selectedDate)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.sync {
                if error != nil {
                    print("Sending GET request failed: \(String(describing: error))")
                    return
                }
                
                if let data = data {
                    if let photoInfo = self.parseJSON(photoData: data) {
                        //print("network \(photoInfo)")
                        completion(photoInfo)
                    }
                }
            }

        }
        task.resume()
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
        
        let url = baseUrl.withQueries2(query)!
        return url
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Loading image failed: \(String(describing: error))")
                    return
                }
                
                if let data = data {
                    if let image = UIImage(data: data) {
                        completion(image)
                    }
                }
            }
        }.resume()
    }
}

extension URL {
    func withQueries2(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
        resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
