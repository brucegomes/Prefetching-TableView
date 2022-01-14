//
//  Utilities.swift
//  Prefetching+TableView
//
//  Created by Bruce Gomes on 4/4/21.
//

import Foundation

class Utilities {
    
    func resizeImage(image:UIImage, width: Int, height: Int) -> UIImage
    {
        var newSize = CGSize(width: width, height: height);
        let widthRatio = newSize.width/image.size.width;
        let heightRatio = newSize.height/image.size.height;
        
        if widthRatio > heightRatio
        {
            newSize = CGSize(width: image.size.width * heightRatio, height: image.size.height * heightRatio);
        }
        else
        {
            newSize = CGSize(width: image.size.width * widthRatio , height: image.size.height * widthRatio);
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage ?? image
    }
}

// custom alert to be shown from anywhere
protocol AlertDisplayer {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension AlertDisplayer where Self: UIViewController {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}
