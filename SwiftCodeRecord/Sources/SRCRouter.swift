//
//  SRCRouter.swift
//  SwiftCodeRecord
//
//  Created by 谢鸿标 on 2020/11/1.
//

import UIKit

public enum SCRRouterSkipForm {
    case present
    case push
}

public struct SCRRouterSkipConfig<Paramters> {
    var parameters: Paramters
    var skipForm: SCRRouterSkipForm
    var parameterName: String
}

public class SCRRouter {
    
    static let router = SCRRouter()
    
    private var routerPageInfo = Dictionary<String,UIViewController.Type>()
    
    private init() {}
    
    public func register(url: String, page: UIViewController.Type) {
        register(pages: [(url,page)])
    }
    
    public func register(pages: [(url: String, page: UIViewController.Type)]) {
        _ = pages.map { routerPageInfo[$0.url] = $0.page }
    }
    
    public func jumpTo<T>(url: String, from page: UIViewController, with config: SCRRouterSkipConfig<T>) {
        guard let vctype = routerPageInfo[url] else {
            return
        }
        let vc = vctype.init()
        vc.setValue(config.parameters, forKeyPath: config.parameterName)
        switch config.skipForm {
        case .present:
            page.present(vc, animated: true, completion: nil)
        case .push:
            page.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SCRRouter {
    //图片展示页面
    public static let SCRRouterPageUnsplash = "unsplash"
}
