//
//  Date+Extension.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/24/22.
//

import Foundation


fileprivate let formatter = DateFormatter()


extension Date {
    var commentDate: String {
        formatter.dateFormat = "MM/dd yyyy HH:mm"
        return formatter.string(from: self)
    }
}
