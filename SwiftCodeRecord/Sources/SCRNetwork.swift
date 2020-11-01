//
//  SCRNetwork.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/26.
//

import Foundation

public struct SCRNetworkJSONConvertable<T: Codable> {
    static func toString(_ object: T) -> String {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(object)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("convert json string failed = \(error)")
            return ""
        }
    }
    static func toObject(_ string: String) -> Result<T,Error> {
        if let data = string.data(using: .utf8) {
            return self.toObject(data)
        }else {
            return .failure(SCRErrorEnum.convertToObject)
        }
    }
    static func toObject(_ data: Data) -> Result<T,Error> {
        let decoder = JSONDecoder()
        do {
            return .success(try decoder.decode(T.self, from: data))
        } catch {
            return .failure(error)
        }
    }
}
