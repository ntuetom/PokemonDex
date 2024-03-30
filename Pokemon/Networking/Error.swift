//
//  Error.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Foundation

public enum ParseResponseError: Error{
    case respnseError(errCode: String, errMsg: String, data: Data? = nil)
    case parseError(errMsg: String)
    case others
    
    public var message: String {
        switch self {
        case .respnseError(_, let msg, _):
            return msg
        case .parseError(let msg):
            return "解析錯誤 \(msg)"
        default:
            return "未知的錯誤"
        }
    }
    
    public var code: String {
        switch self {
        case .respnseError(let code, _, _):
            return code
        case .parseError:
            return "PARSE_ERROR"
        default:
            return "GYResponse_UNKNOWN_ERROR"
        }
    }
}
