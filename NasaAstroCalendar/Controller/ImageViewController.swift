//  DetailViewController.swift
//  NasaAstroCalendar
//  Created by Lamphai Intathep on 20/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.

import UIKit
import SafariServices
import AVKit

class ImageViewController: UIViewController, NetworkControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedDate: Date?
    var photoInfo: PhotoInfo!
    var image: UIImage!
    var isImageDownloadCompleted: Bool = false
    var networkManager = NetworkController()
    
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
        networkManager.delegate = self
        
        if let _ = selectedDate {
            networkManager.performRequest(selectedDate: selectedDate!)
        }
    }
    
    func fetchData(photoInfo: PhotoInfo) {
        print("imageview: \(photoInfo)")
    }
    
//    func fetchData() {
//        DispatchQueue.global().async {
//            let network = NetworkController()
//            let response = network.performRequest(selectedDate: self.selectedDate!)
//            self.photoInfo = response
//
//            // wrap ui update on main thread
//            DispatchQueue.main.async {
//                self.photoInfo.isVideo ? self.displayVideo() : self.displayImage()
//            }
//        }
 //   }
    
    func displayVideo() {
        activityIndicator.stopAnimating()
        videoButton.isHidden = false
        titleLabel.text = photoInfo?.title
        descTextView.text = photoInfo?.explanation
    }
    
    func displayImage() {
        loadImage()
        titleLabel.text = photoInfo?.title
        descTextView.text = photoInfo?.explanation
    }
    
    func loadImage() {
//        DispatchQueue.global().async {
//            let network = NetworkController()
//            let image = network.displayImage(url: self.photoInfo.url)
//
//            DispatchQueue.main.async {
//                self.imageView.image = image
//                self.activityIndicator.stopAnimating()
//                self.isImageDownloadCompleted = true
//            }
//        }
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
