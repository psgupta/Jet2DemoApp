//
//  SupportingExtensions.swift
//  Jet2DemoApp
//
//  Created by Prasanna Gupta on 10/07/20.
//  Copyright © 2020 Prasanna Gupta. All rights reserved.
//

import Foundation

extension String{
    func toDate(format:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let validDate = dateFormatter.date(from: self) {
            //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
            return validDate
        } else {
            // Invalid date or today's date
            return dateFormatter.date(from: Date().toString(format: format))!
        }
    }
}


extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


extension DateComponentsFormatter {
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.year,.month,.weekOfMonth,.day]
        self.maximumUnitCount = 1
        self.unitsStyle = .full
        return self.string(from: fromDate, to: toDate)
    }
}
