//  ImageViewController.swift
//  NasaAstroCalendar
//  Created by Lamphai Intathep on 21/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var networkManager = NetworkController()
    var hdurl: URL!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomImage()
        
        if let _ = hdurl, let _ = url {
            displayImage(url: url, msg: "Small image: ")
            displayImage(url: hdurl, msg: "HD image: ")
        }
    }
    
    func displayImage(url: URL, msg: String) {
        networkManager.loadImage(url: url, completion: { (image) in
            DispatchQueue.main.async {
                self.imageView.image = image
                print("\(msg) \(image)")
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    func zoomImage() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 10
        scrollView.minimumZoomScale = 1
        scrollView.addSubview(imageView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
