//
//  UNSNetwork.swift
//  SwiftCodeRecord
//
//  Created by 谢鸿标 on 2020/11/1.
//

import Foundation
import Alamofire

private let UNSHost = "https://api.unsplash.com/"
private let UNSAccessKey = "p5CvNX85stB0M0lc7GcSErdFxg0I3KdJu6Y8bOhf1ro"
private let UNSSecretKey = "zs-H1z_wQGAk7GucbaUheceyLDo9JZ_RYwSPiUohwO8"

//MARK: Request Model

public enum UNSServerOrder {
    static let latest = "latest"
    static let oldest = "oldest"
    static let popular = "popular"
}

public enum UNSServerOrientation {
    static let landscape = "landscape"
    static let portrait = "portrait"
    static let squarish = "squarish"
}

public enum UNSServerColor {
    static let none = ""
    static let black_and_white = "black_and_white"
    static let black = "black"
    static let white = "white"
    static let yellow = "yellow"
    static let orange = "orange"
    static let red = "red"
    static let purple = "purple"
    static let magenta = "magenta"
    static let green = "green"
    static let teal = "teal"
    static let blue = "blue"
}

public struct UNSServerList: Encodable {
    var page = 1
    var perPage = 10
    var orderBy = UNSServerOrder.latest
    
    public enum UNSCodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case orderBy = "oder_by"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UNSCodingKeys.self)
        try container.encode(page,forKey: .page)
        try container.encode(perPage,forKey: .perPage)
        try container.encode(orderBy,forKey: .orderBy)
    }
}

public struct UNSServerSearch: Encodable {
    var query: String
    var page = 1
    var perPage = 10
    var orderBy  = UNSServerOrder.latest
    var collections = "" //多个id需要使用"-"分割
    var contentFilter = "low"
    var color = UNSServerColor.none
    var orientation = UNSServerOrientation.landscape
    
    public enum UNSCodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case orderBy = "oder_by"
        case collections
        case contentFilter = "content_filter"
        case color
        case orientation
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UNSCodingKeys.self)
        try container.encode(page,forKey: .page)
        try container.encode(perPage,forKey: .perPage)
        try container.encode(orderBy,forKey: .orderBy)
        try container.encode(collections,forKey: .collections)
        try container.encode(contentFilter,forKey: .contentFilter)
        try container.encode(color,forKey: .color)
        try container.encode(orientation,forKey: .orientation)
    }
}

//MARK: Response Model

public struct UNSPhoto: Codable {
    
    public struct UNSUser: Codable {
        public var id: String = ""
        public var username: String = ""
        public var portfolio_url: String = ""
        public var bio: String = ""
        public var location: String = ""
        public var total_likes: Int = 0
        public var total_collections: Int = 0
    }
    
    public struct UNSPhotoUrls: Codable {
        public var raw: String = ""
        public var full: String = ""
        public var regular: String = ""
        public var small: String = ""
        public var thumb: String = ""
    }
    
    public var id: String = ""
    public var created_at: String = ""
    public var width: Int = 0
    public var height: Int = 0
    public var color: String = ""
    public var blur_hash: String = ""
    public var likes: Int = 0
    public var liked_by_user: Bool = false
    public var description: String = ""
    public var user: Self.UNSUser = Self.UNSUser()
    public var urls: Self.UNSPhotoUrls = Self.UNSPhotoUrls()
    
}

public typealias UNSServerAccessCompletion = (Result<[UNSPhoto],Error>) -> Void

public enum UNSServerPath {
    
    case list(UNSServerList)
    case serach(UNSServerSearch)
    
    private static let headers = HTTPHeaders(["Authorization": "Client-ID \(UNSAccessKey)"])
    
    private var response: DataRequest? {
        switch self {
        case .list(let photoList):
            let url = UNSHost + "/photos"
            return AF.request(url, method: .get, parameters: photoList, headers: Self.headers)
        case .serach(let query):
            let url = UNSHost + "/search/photos"
            return AF.request(url, method: .get, parameters: query, headers: Self.headers)
        }
    }
    
    public func requestPhotos(completion: @escaping UNSServerAccessCompletion) {
        self.response?.responseData(completionHandler: { (response) in
            if let error = response.error {
                completion(.failure(error))
            }else {
                completion(SCRNetworkJSONConvertable<[UNSPhoto]>.toObject(response.data!))
            }
        })
    }
}
