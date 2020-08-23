//
//  DetailViewController.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 20/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//

import UIKit
import SafariServices
import AVKit

class ImageViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var videoButton: UIButton!
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var selectedDate: String = ""
    var photoInfo: PhotoInfo!
    var image: UIImage!
    var isImageDownloadCompleted: Bool = false
    
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = descTextView {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        videoButton.isHidden = true
        
        displayActivityIndicator()
        if (!selectedDate.isEmpty) {
            fetchData()
        }
    }
    
    func displayActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.center = imageView.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    // MARK: - Make GET request
    func fetchData() {
        let baseUrl = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "8e0SOielQeixak1Zaygd4Gb8abJnuvrjpLXOeHIN",
            "date": selectedDate
        ]
        let url = baseUrl.withQueries(query)!
        //print(url)
        let task = URLSession.shared.dataTask(with: url) { (data,
        response, error) in
            // decode the data returned into a dictionary[String: String]
            let jsonDecoder = JSONDecoder()

            if let data = data,
                let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
                    DispatchQueue.main.async {
                        print(photoInfo.url)
                        self.photoInfo = photoInfo
                        self.displayData()
                    }
                }
        }
        // send the request
        task.resume()
    }
    
    func displayData() {
        isVideo() ? goToVideoDisplay() : goToImageDisplay()
    }
    
    func isVideo() -> Bool {
        return photoInfo!.url.contains("youtube") || photoInfo!.url.contains(".mp4")
        //return urlStr.contains("youtube") || urlStr.endsWith(".mp4")
    }
    
    func goToVideoDisplay() {
        activityIndicator.stopAnimating()
        videoButton.isHidden = false
        
        titleLabel.text = photoInfo?.title
        descTextView.text = photoInfo?.explanation
        //getThumbnailFromVideo()
    }
    
    func goToImageDisplay() {
        displayImage()
        titleLabel.text = photoInfo?.title
        descTextView.text = photoInfo?.explanation
    }
    
    func displayImage() {
        let url = URL(string: photoInfo.url)
        //print(url!)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                        self?.activityIndicator.stopAnimating()
                        self?.image = image
                        self?.isImageDownloadCompleted = true
                    }
                }
            }
        }
        addTapGestureRecogniser()
    }
    
    func addTapGestureRecogniser() {
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecogniser:)))
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        imageView.addGestureRecognizer(tapGestureRecogniser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "displayVideo" {
    //            let destinationVC = segue.destination as! VideoViewController
    //            destinationVC.photoInfo = photoInfo
    //        }
        if isImageDownloadCompleted {
            if segue.identifier == "displayImageDetail" {
                let destinationVC = segue.destination as! ImageDetailViewController
                //print(selectedImage!)
                destinationVC.image = image
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecogniser: UITapGestureRecognizer) {
        if isImageDownloadCompleted && !isVideo(){
            //print("tapped")
            self.performSegue(withIdentifier: "displayImageDetail", sender: self)
        }
        //self.performSegue(withIdentifier: "displayVideo", sender: self)
    }
    
    @IBAction func onVideoButtonClicked(_ sender: Any) {
        if let url = URL(string: photoInfo.url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func getThumbnailFromVideo() {
        DispatchQueue.global().async {
            print("getThumbnail")
            let url = URL(string: self.photoInfo.url)
            print(url!)
            let asset = AVAsset(url: url!)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            let time = CMTimeMake(value: 7, timescale: 1)
            do {
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                print("cg")
                print(cgImage)
                print("Image")
                print(image)
                DispatchQueue.main.async {
                    print("cgImage")
                    print(image)
                    //self.imageView.image = image
                }
            } catch {
                print("error")
            }
        }
    }
}

// update URL with a dictionary of queries
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
        resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}


