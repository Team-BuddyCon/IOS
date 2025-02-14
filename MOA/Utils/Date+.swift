//
//  Date+.swift
//  MOA
//
//  Created by 오원석 on 10/1/24.
//

import Foundation

// 기프티콘 조회 API : yyyy.MM.dd 형태로 반환
// 상세 기프티콘 조회 API : yyyy-MM-dd 형태로 반환
let AVAILABLE_GIFTICON_RESPONSE_TIME_FORMAT = "yyyy-MM-dd"
let AVAILABLE_GIFTICON_TIME_FORMAT = "yyyy.MM.dd"

extension Date {
    var timeInMills: Int {
        Int(self.timeIntervalSince1970 * 1000.0)
    }
    
    func add(offset: Int) -> Date {
        Date().addingTimeInterval(TimeInterval(offset * 60 * 60 * 24))
    }
    
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func toDday() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = AVAILABLE_GIFTICON_TIME_FORMAT
        let date = formatter.date(from: self)
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: Date(), to: date ?? Date()).day ?? 0
    }
    
    func transformTimeformat(
        origin: String,
        dest: String
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = origin
        
        let destFormatter = DateFormatter()
        destFormatter.dateFormat = dest
        
        if let date = formatter.date(from: self) {
            return destFormatter.string(from: date)
        }
        
        return ""
    }
}
