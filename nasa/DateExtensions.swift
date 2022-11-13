//
//  DateExtensions.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import Foundation

extension Date {
    
    func toString()-> String {
        let dateformatter = DateFormatter()
        dateformatter.timeZone = .init(identifier: "UTC")
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: self)
    }
    
}
