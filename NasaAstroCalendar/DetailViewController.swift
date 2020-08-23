////
////  DetailViewController.swift
////  NasaAstroCalendar
////
////  Created by Lamphai Intathep on 20/8/20.
////  Copyright © 2020 Lamphai Intathep. All rights reserved.
////
//
//import UIKit
//import SafariServices
//import AVKit
//import AVFoundation
//
//class ImageViewController: UIViewController {
//
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var descTextView: UITextView!
//    
//    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//    
//    var photoInfo: PhotoInfo?
//    
//    var selectedImage: UIImage!
//    var selectedDate: String = ""
//    var isComplete: Bool = false
//    var url: URL?
//    var detailItem: NSDate? {
//        didSet {
//            // Update the view.
//            configureView()
//        }
//    }
//    
//    func configureView() {
//        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = descTextView {
//                label.text = detail.description
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        displayActivityIndicator()
//        
//        if !selectedDate.isEmpty {
//            fetchData()
//        }
//    }
//    
//    func displayActivityIndicator() {
//        activityIndicator.startAnimating()
//        activityIndicator.center = imageView.center
//        activityIndicator.hidesWhenStopped = true
//        self.view.addSubview(activityIndicator)
//    }
//    
//    // MARK: - Make GET request
//    func fetchData() {
//        let baseUrl = URL(string: "https://api.nasa.gov/planetary/apod")!
//        let query: [String: String] = [
//            "api_key": "8e0SOielQeixak1Zaygd4Gb8abJnuvrjpLXOeHIN",
//            "date": selectedDate
//        ]
//        let url = baseUrl.withQueries(query)!
//        // print(url)
//        let task = URLSession.shared.dataTask(with: url) { (data,
//        response, error) in
//            // decode the data returned into a dictionary[String: String]
//            let jsonDecoder = JSONDecoder()
//            
//            if let data = data,
//                let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
//                    DispatchQueue.main.async {
//                        // print(photoInfo)
//                        //self.displayData(photoInfo: photoInfo)
//                        self.photoInfo = photoInfo
//                        self.displayData()
//                    }
//                }
//        }
//        // send the request
//        task.resume()
//    }
//    
////    func getValue(photoData: PhotoData) {
////        photo?.title = photoData.title
////        print(photo?.title)
////    }
//    
//    func displayData() {
//        titleLabel.text = photoInfo?.title
//        descTextView.text = photoInfo?.explanation
//        isVideo()
//            ? displayVideo()
//            : displayImage()
//    }
//    
//    func displayVideo() {
////        url = URL(string: urlStr)
////        if cgImage != nil {
////            imageView.image = UIImage(cgImage: cgImage!)
////        }
////        var x = urlStr
////        x.append("/default.jpg")
////        print(x)
////        url = URL(string: x)
////        DispatchQueue.global().async { [weak self] in
////            if let data = try? Data(contentsOf: self!.url!) {
////                if let image = UIImage(data: data) {
////                    DispatchQueue.main.async {
////                        self?.imageView.image = image
////                    }
////                }
////            }
////        }
////        DispatchQueue.global().async {
////            let asset = AVAsset(url: URL(string: x)!)
////            let generator = AVAssetImageGenerator(asset: asset)
////            generator.appliesPreferredTrackTransform = true
////
////            let time = CMTimeMake(value: 7, timescale: 1)
////            do {
////                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
////                let image = UIImage(cgImage: cgImage)
////                print(image)
////            } catch {
////                print("error")
////            }
////        }
//        
//        if let url = URL(string: photoInfo!.url) {
//            let config = SFSafariViewController.Configuration()
//            config.entersReaderIfAvailable = true
//
//            let vc = SFSafariViewController(url: url, configuration: config)
//            present(vc, animated: true)
//        }
//    }
//    
//    func displayImage() {
//        url = URL(string: photoInfo!.url)
//        print(url!)
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: self!.url!) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.imageView.image = image
//                        self?.activityIndicator.stopAnimating()
//                        self?.isComplete = true
//                        self!.selectedImage = image
//                    }
//                }
//            }
//        }
//        addTapGestureRecogniser()
//    }
//    
//    func isVideo() -> Bool {
//        return photoInfo!.url.contains("youtube") || photoInfo!.url.contains(".mp4")
//        //return urlStr.contains("youtube") || urlStr.endsWith(".mp4")
//    }
//    
//    func addTapGestureRecogniser() {
//        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecogniser:)))
//        imageView.isUserInteractionEnabled = true
//        imageView.isMultipleTouchEnabled = true
//        imageView.addGestureRecognizer(tapGestureRecogniser)
//    }
//    
//    @objc func imageTapped(tapGestureRecogniser: UITapGestureRecognizer) {
//        if isComplete {
//            //print("tapped")
//            self.performSegue(withIdentifier: "imageView", sender: self)
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if isComplete {
//            if segue.identifier == "imageView" {
//                let destinationVC = segue.destination as! ImageViewController
//                //print(selectedImage!)
//                destinationVC.image = selectedImage
//            }
//        }
//    }
//}
//
