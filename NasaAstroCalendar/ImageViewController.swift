//
//  ImageViewController.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 21/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//

//import Foundation
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        print("imageview")
        print(image!)
    }
    
    func setupScrollView() {
        imageView.image = image
//        scrollView.frame = view.bounds
//        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        scrollView.backgroundColor = .white
//        scrollView.contentSize = imageView.bounds.size
        scrollView.delegate = self
        self.scrollView.addSubview(imageView)
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
        recenterImage()
    }
}
