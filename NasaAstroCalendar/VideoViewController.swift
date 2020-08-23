//
//  VideoViewController.swift
//  NasaAstroCalendar
//
//  Created by Lamphai Intathep on 21/8/20.
//  Copyright © 2020 Lamphai Intathep. All rights reserved.
//
import UIKit
import Foundation
import SafariServices

class VideoViewController: UIViewController {

    var photoInfo: PhotoInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayVideo()
    }
    
    func displayVideo() {
        if let url = URL(string: photoInfo.url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}


//        url = URL(string: urlStr)
//        if cgImage != nil {
//            imageView.image = UIImage(cgImage: cgImage!)
//        }
//        var x = urlStr
//        x.append("/default.jpg")
//        print(x)
//        url = URL(string: x)
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: self!.url!) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.imageView.image = image
//                    }
//                }
//            }
//        }
//        DispatchQueue.global().async {
//            let asset = AVAsset(url: URL(string: x)!)
//            let generator = AVAssetImageGenerator(asset: asset)
//            generator.appliesPreferredTrackTransform = true
//
//            let time = CMTimeMake(value: 7, timescale: 1)
//            do {
//                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
//                let image = UIImage(cgImage: cgImage)
//                print(image)
//            } catch {
//                print("error")
//            }
//        }
