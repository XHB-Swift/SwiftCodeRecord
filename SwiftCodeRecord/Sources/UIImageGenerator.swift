//
//  UIImageGenerator.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/31.
//

import UIKit

public typealias SCRDrawContentHandler = (CGContext)->Void
public typealias SCRDrawCompletionHandler = (UIImage)->Void

public class SCRDrawGenerator {
    
    public static func drawImage(size: CGSize,
                                 contentHandler: @escaping SCRDrawContentHandler,
                                 completionHandler: @escaping SCRDrawCompletionHandler) {
        
        DispatchQueue.global().async {
            UIGraphicsBeginImageContext(size)
            if let context = UIGraphicsGetCurrentContext() {
                contentHandler(context)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            DispatchQueue.main.async {
                if let img = image {
                    completionHandler(img)
                }
            }
        }
    }
}

extension UIImage: SCRDrawbale {
    
}

extension NSAttributedString: SCRDrawbale {
    
    func drawIn(size: CGSize,
                completionHandler: @escaping SCRDrawCompletionHandler) {
        SCRDrawGenerator.drawImage(size: size, contentHandler: { (context) in
            
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
            
        }, completionHandler: completionHandler)
    }
}
