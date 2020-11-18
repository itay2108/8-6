//
//  UIView+Extensions.swift
//  Dory
//
//  Created by itay gervash on 03/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit

public extension UIView {
    
    var widthModifier: CGFloat {
        get {
            return UIScreen.main.bounds.size.height / 812
        }
    }
    
    var heightModifier: CGFloat {
        get {
            return UIScreen.main.bounds.size.width / 375
        }
    }
    
    func circlize() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func uncirclize() {
        
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
        
    }
    
    func shadow(color: UIColor, radius: CGFloat, opacity: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
     }
    
    func addLoadingIndicator() {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .darkGray
        loadingIndicator.style = .medium
        
        self.addSubview(loadingIndicator)
    }
    
}

extension Date {
    func asString(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func startOfDay() -> Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .day, for: self)?.start
    }
    
    func at(hour: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: self)
    }
    
    var inCurrentTimeZone: Date {
        get {
            let calendar = Calendar(identifier: .gregorian)
            let timezoneSecondOffset = TimeZone.current.secondsFromGMT()
            return calendar.date(byAdding: .second, value: timezoneSecondOffset, to: self) ?? self
        }
    }
}

extension UIViewController {
    
    var widthModifier: CGFloat {
        get {
            return self.view.frame.width / 375
        }
    }
    
    var heightModifier: CGFloat {
        get {
            return self.view.frame.height / 812
        }
    }
    
    var safeAreaTop: CGFloat {
        get {
            return self.view.safeAreaInsets.top
        }
    }
    
    var safeAreaBottom: CGFloat {
        get {
            return self.view.safeAreaInsets.bottom
        }
    }

}

extension UIImage {
    func blur(amount: CGFloat) -> UIImage {
        guard let ciImage = CIImage(image: self),
              let filter = CIFilter(name: "CIGaussianBluer")
        else { print("fail"); return self }
        
        filter.setValue(ciImage, forKey: "kCIInputImageKey")
        filter.setValue(amount, forKey: "kCIInputRadiusKey")
        
        guard let output = filter.outputImage else { print("fail"); return self }
        
        return UIImage(ciImage: output)
    }
}
