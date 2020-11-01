//
//  SCRMainDataLoader.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/31.
//

import Foundation

public typealias SCRCompletionHandler<T> = (Result<T,Error>) -> Void 

public class SCRMainDataLoader {
    
    public static func loadMainTitles(completion: @escaping SCRCompletionHandler<[String]>) {
        DispatchQueue.global().async {
            
            var mainTitles = Array<String>()
            var loadError: Error?
            if let filePath = Bundle.main.path(forResource: "SCRMainTitles", ofType: "plist"),
               let plistData = FileManager.default.contents(atPath: filePath) {
                do {
                    var format = PropertyListSerialization.PropertyListFormat.xml
                    if let titles = try PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String] {
                        mainTitles = titles
                    }
                } catch {
                    loadError = error
                }
            }else {
                loadError = SCRErrorEnum.noFilePath
            }
            
            DispatchQueue.main.async {
                if let e = loadError {
                    completion(.failure(e))
                }else {
                    completion(.success(mainTitles))
                }
            }
            
        }
        
    }
    
}
