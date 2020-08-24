//
//  NetworkController.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 24/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//

import UIKit
import AVKit

protocol NetworkControllerDelegate {
    func fetchData(photoInfo: PhotoInfo)
}

struct NetworkController {
    
    var delegate: NetworkControllerDelegate?
    
    func performRequest(selectedDate: Date) {
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
                        self.delegate?.fetchData(photoInfo: photoInfo)
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
            //self.photo = decodedPhoto
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
    
    func displayImage(url: URL) -> UIImage {
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        var image = UIImage()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Diplaying image failed: \(error)")
                    return
                }
                
                if let data = data {
                    image = UIImage(data: data)!
                    semaphore.signal()
                }
            }
        }.resume()
        semaphore.wait()
        return image
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
