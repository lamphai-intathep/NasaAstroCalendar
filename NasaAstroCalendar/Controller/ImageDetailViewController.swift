//  ImageViewController.swift
//  NasaAstroCalendar
//  Created by Lamphai Intathep on 21/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var hdurl: URL!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        //print("hdurl: \(String(describing: hdurl))")
        
        if let _ = hdurl, let _ = url {
            displayImage()
            displayHdImage()
        }
    }
    
    func displayHdImage() {
        URLSession.shared.dataTask(with: hdurl) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Diplaying HD image failed: \(error)")
                    return
                }
                
                if let data = data {
                    print("hd displayed")
                    self.imageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                    self.configureScrollView()
                }
            }
        }.resume()
    }
    
    func displayImage() {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Displaying image failed: \(error)")
                    return
                }
                
                if let data = data {
                    print("small displayed")
                    self.imageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                    self.configureScrollView()
                }
            }
        }.resume()
    }
    
    func configureScrollView() {
        scrollView.contentSize = imageView.bounds.size
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }
    
    func recenterImage() {
        
    }
}

extension ImageViewController: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //recenterImage()
    }
}

