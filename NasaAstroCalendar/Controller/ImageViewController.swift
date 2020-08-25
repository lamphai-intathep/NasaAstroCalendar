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
    
    var photoInfo: PhotoInfo!
    var selectedDate: Date?
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
        
        if let _ = selectedDate {
            networkManager.fetchData(selectedDate: selectedDate!, completion: { (photoInfo) in
                DispatchQueue.main.async {
                   //print("closure \(photoInfo)")
                    self.photoInfo = photoInfo
                    photoInfo.isVideo
                        ? self.displayVideo(photoInfo: photoInfo)
                        : self.displayImage(photoInfo: photoInfo)
                }
            })
        }
    }
    
    func displayVideo(photoInfo: PhotoInfo) {
        activityIndicator.stopAnimating()
        videoButton.isHidden = false
        titleLabel.text = photoInfo.title
        descTextView.text = photoInfo.explanation
    }
    
    func displayImage(photoInfo: PhotoInfo) {
        networkManager.loadImage(url: photoInfo.url, completion: { (image) in
            //print("image \(image)")
            DispatchQueue.main.async {
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
                self.isImageDownloadCompleted = true
            }
        })
        
        titleLabel.text = photoInfo.title
        descTextView.text = photoInfo.explanation
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
