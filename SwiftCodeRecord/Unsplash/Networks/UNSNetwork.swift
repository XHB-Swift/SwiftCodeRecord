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

public enum UNSServerOrder: String, Codable {
    case latest = "latest"
    case oldest = "oldest"
    case popular = "popular"
}

public enum UNSServerOrientation: String, Codable {
    case landscape = "landscape"
    case portrait = "portrait"
    case squarish = "squarish"
}

public enum UNSServerColor: String, Codable {
    case none = ""
    case black_and_white = "black_and_white"
    case black = "black"
    case white = "white"
    case yellow = "yellow"
    case orange = "orange"
    case red = "red"
    case purple = "purple"
    case magenta = "magenta"
    case green = "green"
    case teal = "teal"
    case blue = "blue"
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
        try container.encode(orderBy.rawValue,forKey: .orderBy)
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

public typealias UNSServerAccessCompletion<T> = (Result<T,Error>) -> Void

public enum UNSServerPath {
    
    case list(page: Int)
    case serach(page: Int, query: String)
    
    private static let headers = ["Authorization": "Client-ID \(UNSAccessKey)"]
    
    public func request<T>(completion: @escaping UNSServerAccessCompletion<T>) {
        switch self {
        case .list(page: let page):
            let url = UNSHost + "/photos"
            let param = UNSServerList(page: page, perPage: 10, orderBy: .latest)
            AF.request(url, method: .get, parameters: param, headers: HTTPHeaders(Self.headers))
        case .serach(page: let page, query: let query):
            let url = UNSHost + "/search/photos"
            let param = UNSServerList(page: page, perPage: 10, orderBy: .latest)
            break
        }
    }
}
