//  DetailViewController.swift
//  NasaAstroCalendar
//  Created by Lamphai Intathep on 20/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.

import UIKit
import SafariServices
import AVKit

class ImageViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedDate: Date?
    var photoInfo: PhotoInfo!
    var image: UIImage!
    var isImageDownloadCompleted: Bool = false
    
    var detailItem: NSDate? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detail = detailItem {
            if let label = descTextView {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        videoButton.isHidden = true
        if let _ = selectedDate {
            fetchData()
        }
    }
    
    func fetchData() {
        let dateUrlFormatter = DateFormatter()
        dateUrlFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateUrlFormatter.string(from: selectedDate!)
        
        let baseUrl = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "8e0SOielQeixak1Zaygd4Gb8abJnuvrjpLXOeHIN",
            "date": dateStr
        ]
        let url = baseUrl.withQueries(query)!
        //print("url:  \(url)")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Fetching data failed: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let responseObject = try decoder.decode(PhotoInfo.self, from: data)
                        self.photoInfo = responseObject
                        self.displayData()
                    } catch {
                        print("Fetching data failed: data is nil")
                        return
                    }
                }
            }
        }.resume()
    }
    
    func displayData() {
        photoInfo.isVideo ? displayVideo() : displayImage()
    }
    
    func displayVideo() {
        print("displayvideo")
        activityIndicator.stopAnimating()
        videoButton.isHidden = false
        
        titleLabel.text = photoInfo?.title
        descTextView.text = photoInfo?.explanation
    }
    
    func displayImage() {
        loadImage() // call from networking controller: parameter: closure
        titleLabel.text = photoInfo?.title
        descTextView.text = photoInfo?.explanation
    }
    
    func loadImage() {
        URLSession.shared.dataTask(with: photoInfo.url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Loading image failed: \(error)")
                    return
                }
                
                if let data = data {
                    self.imageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                    self.isImageDownloadCompleted = true
                }
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isImageDownloadCompleted {
            if segue.identifier == "displayImageDetail" {
                let destinationVC = segue.destination as! ImageDetailViewController
                destinationVC.hdurl = photoInfo.hdurl
                destinationVC.url = photoInfo.url
            }
        }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if isImageDownloadCompleted && !photoInfo.isVideo {
            activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "displayImageDetail", sender: self)
        }
    }
    
    @IBAction func onVideoButtonTapped(_ sender: Any) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true

        let vc = SFSafariViewController(url: photoInfo.url, configuration: config)
        present(vc, animated: true)
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


