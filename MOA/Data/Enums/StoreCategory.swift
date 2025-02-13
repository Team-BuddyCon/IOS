//
//  StoreCategory.swift
//  MOA
//
//  Created by 오원석 on 11/11/24.
//

import Foundation

enum StoreCategory: String, CaseIterable {
    case ALL = "전체"
    case CAFE = "카페"
    case CONVENIENCE_STORE = "편의점"
    case OTHERS = "기타"
    
    static func from(string: String) -> StoreCategory? {
        switch string {
        case StoreCategory.CAFE.code:
            return .CAFE
        case StoreCategory.CONVENIENCE_STORE.code:
            return .CONVENIENCE_STORE
        case StoreCategory.OTHERS.code:
            return .OTHERS
        default:
            return nil
        }
    }
    
    static func from(typeCode: String) -> StoreCategory? {
        switch typeCode {
        case StoreType.STARBUCKS.code:
            return .CAFE
        case StoreType.TWOSOME_PLACE.code:
            return .CAFE
        case StoreType.ANGELINUS.code:
            return .CAFE
        case StoreType.MEGA_COFFEE.code:
            return .CAFE
        case StoreType.COFFEE_BEAN.code:
            return .CAFE
        case StoreType.GONG_CHA.code:
            return .CAFE
        case StoreType.BASKIN_ROBBINS.code:
            return .CAFE
        case StoreType.MACDONALD.code:
            return .OTHERS
        case StoreType.GS25.code:
            return .CONVENIENCE_STORE
        case StoreType.CU.code:
            return .CONVENIENCE_STORE
        case StoreType.OTHERS.code:
            return .OTHERS
        default:
            fatalError()
        }
    }
    
    var code: String? {
        switch self {
        case .CAFE:
            return "CAFE"
        case .CONVENIENCE_STORE:
            return "CONVENIENCE_STORE"
        case .OTHERS:
            return "OTHERS"
        default:
            return nil
        }
    }
    
    var categoryField: [String] {
        switch self {
            case .ALL:
                return StoreCategory.allCases.compactMap { $0.code }
            default:
                if let code = self.code {
                    return [code]
                }
        }
        return []
    }
}
