//
//  Extensions.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import Foundation
import SwiftUI

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension Date {
    func formattedDateString(from dateString: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            let now = Date()
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
            
            if let year = components.year, year > 0 {
                return "\(year) " + (year == 1 ? "year" : "years")
            } else if let month = components.month, month > 0 {
                return "\(month) " + (month == 1 ? "month" : "months")
            } else if let day = components.day, day > 0 {
                return "\(day) " + (day == 1 ? "day" : "days")
            } else if let hour = components.hour, hour > 0 {
                return "\(hour) " + (hour == 1 ? "hour" : "hours")
            } else if let minute = components.minute, minute > 0 {
                return "\(minute) " + (minute == 1 ? "minute" : "minutes")
            } else if let second = components.second, second > 0 {
                return "\(second) " + (second == 1 ? "second" : "seconds")
            } else {
                return "just now"
            }
        }
        return nil
    }
}
