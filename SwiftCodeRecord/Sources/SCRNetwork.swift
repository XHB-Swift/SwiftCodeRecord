//
//  SCRNetwork.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/26.
//

import Foundation
import Alamofire

public protocol SCRNetworkDataConvertable {
    associatedtype T
    func convert(_ data: Data) -> Result<T,Error>
}

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
    static func toObject(_ string: String) -> T? {
        if let data = string.data(using: .utf8) {
            return self.toObject(data)
        }else {
            return nil
        }
    }
    static func toObject(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
             return try decoder.decode(T.self, from: data)
        } catch {
            print("convert object failed = \(error)")
            return nil
        }
    }
}

public enum SCRNetworkError: Error {
    case unknown
    case convertData
}

public struct SCRNetworkRequest<Body> {
    
    public var url: URLConvertible
    public var method: HTTPMethod = .get
    public var params: Body?
    public var headers: HTTPHeaders?
    public var encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default
    public var interceptor: RequestInterceptor?
    public var requestModifier: Session.RequestModifier?
    
}

public struct SCRNetworkResponse<Convertable: SCRNetworkDataConvertable> {
    public var dataConvertable: Convertable
}

public struct SCRNetworkConfiguration<Body, Convertable: SCRNetworkDataConvertable> {
    public var request: SCRNetworkRequest<Body>
    public var response: SCRNetworkResponse<Convertable>
}

extension Session {
    
    public typealias SCRNetworkCompletion<C: SCRNetworkDataConvertable> = (Result<C.T,Error>)->Void
    
    private func handle<C: SCRNetworkDataConvertable>(_ response: (origin:AFDataResponse<Data?>, handler:SCRNetworkResponse<C>),
                                                      completion: @escaping SCRNetworkCompletion<C>) {
        if let data = response.origin.data {
            let result = response.handler.dataConvertable.convert(data)
            completion(result)
        }else {
            completion(.failure(response.origin.error ?? SCRNetworkError.unknown))
        }
    }
    
    public func request<B: Encodable, C: SCRNetworkDataConvertable>(_ config: SCRNetworkConfiguration<B,C>, completion: @escaping SCRNetworkCompletion<C>) {
        
        let request = config.request
        self.request(request.url,
                     method: request.method,
                     parameters: request.params,
                     encoder: request.encoder,
                     headers: request.headers,
                     interceptor: request.interceptor,
                     requestModifier: request.requestModifier).response { (response) in
                        self.handle((origin: response, handler: config.response), completion: completion)
                     }
        
    }
}


class OCClass: NSObject, URLSessionDataDelegate {
    
}
